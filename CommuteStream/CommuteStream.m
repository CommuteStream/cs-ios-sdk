#import "CommuteStream.h"
#import "CSNetworkEngine.h"
#import "GADBannerViewDelegate.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#import "CSCustomBanner.h"
#import "CSCustomEventDelegate.h"
#import "CSAdFactory.h"




#define SDK_VERSION @"0.3.1"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define IFT_ETHER 0x6
#pragma mark -



static char* getMacAddress(char* macAddress, char* ifName) {
    
    int  success;
    struct ifaddrs * addrs;
    struct ifaddrs * cursor;
    const struct sockaddr_dl * dlAddr;
    const unsigned char* base;
    int i;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != 0) {
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp(ifName,  cursor->ifa_name)==0 ) {
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                strcpy(macAddress, "");
                for (i = 0; i < dlAddr->sdl_alen; i++) {
                    if (i != 0) {
                        strcat(macAddress, ":");
                    }
                    char partialAddr[3];
                    sprintf(partialAddr, "%02X", base[i]);
                    strcat(macAddress, partialAddr);
                    
                }
            }
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    return macAddress;
}




@implementation CommuteStream {

    NSString *ad_unit_uuid;
    NSString *banner_height;
    NSString *banner_width;
    NSString *sdk_name;
    NSString *app_name;
    NSString *sdk_ver;
    NSString *app_ver;
    NSString *latitude;
    NSString *longitude;
    NSString *acc;
    NSString *fix_time;
    NSString *theme;
    NSString *session_ID;
    NSString *time_zone;
    
    NSMutableArray *agency_interest;
    
    NSString *idfa_sha;
    NSString *idfa;
    NSString *mac_addr_sha;
    NSString *testing;
    NSString *limit_tracking;
    
    CLLocation *location;
    
    NSMutableDictionary *http_params;
    
    NSDate *lastServerRequestTime;
    NSDate *lastParameterChange;
    
    NSTimer *parameterCheckTimer;
    
    CSNetworkEngine *networkEngine;
    
    BOOL initialized;
    NSString *agencyStringToSend;
    
    NSString *appVersion;
    NSString *localAppName;
    UIWebView *webView;
    
    NSString *bannerUrl;
    NSTimer *impressionMonitorTimer;
    
    UIView *adView;
    NSString *registerImpressionID;
    
    

}

char macAddress[32];
char ifName[3] = "en0";

//create singleton
+ (CommuteStream *)open {
    static CommuteStream *open = nil;
    
    if (!open)
        open = [[super allocWithZone:nil] init];
    
    return open;
    
}

//force create singleton
+ (id)allocWithZone:(NSZone *)zone {
    return [self open];
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSLog(@"CS_SDK: Initialized CS");
        
        http_params = [[NSMutableDictionary alloc] init];
        
        agency_interest = [[NSMutableArray alloc] init];
        
        lastServerRequestTime = [NSDate date];
        lastParameterChange = [NSDate date];
        
        NSString *appHostUrl = @"api.commutestream.com";
        networkEngine = [[CSNetworkEngine alloc] initWithHostName:appHostUrl];
        //int portNumber = 3000;
        //[networkEngine setPortNumber: portNumber];
        
        parameterCheckTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(onParameterCheckTimer:) userInfo:nil repeats:YES];
        
        appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        localAppName = [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleName"];
        
        [self setAppVer:appVersion];
        [self setSdkName:@"com.commutestreamsdk"];
        [self setAppName:localAppName];
        
        [self setSdkVer:SDK_VERSION];
        
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            
            [self getIdfa];
        }else{
            NSString *deviceMacAddress = [[NSString alloc] initWithUTF8String:getMacAddress(macAddress, ifName)];
            [self getMacSha:deviceMacAddress];
            
        }
        
        if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
            
            NSLog(@"Advertising tracking disabled.");
            [self setIOSLimitAdTracking:@"true"];
        }else {
            NSLog(@"Advertising tracking enabled.");
        }
        
    }
    
    return self;
}


- (NSString *)getIdfa {
#ifndef PRE_6
    Class asIDManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (asIDManagerClass) {
        NSString *adId = nil;
        
        SEL sharedManagerSel = NSSelectorFromString(@"sharedManager");
        if ([asIDManagerClass respondsToSelector:sharedManagerSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id adManager = [asIDManagerClass performSelector:sharedManagerSel];
            if (adManager) {
                SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
                
                if ([adManager respondsToSelector:advertisingIdentifierSelector]) {
                    
                    id uuid = [adManager performSelector:advertisingIdentifierSelector];
                    
                    if (!uuid) {
                        return nil;
                    }
                    
                    SEL uuidStringSelector = NSSelectorFromString(@"UUIDString");
                    if ([uuid respondsToSelector:uuidStringSelector]) {
                        adId = [uuid performSelector:uuidStringSelector];
#pragma clang diagnostic pop
                    }
                }
            }
        }
        
        if (!adId) {
            return nil;
        }
        
        //SHA1
        NSData *sha1_data = [adId dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(sha1_data.bytes, (CC_LONG)sha1_data.length, digest);
        NSMutableString* sha1 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
            [sha1 appendFormat:@"%02x", digest[i]];
        NSString *adIdSha = [NSString stringWithFormat:@"%@",sha1];
        
        [self setIdfaSha:adIdSha];
        [self setIdfa:adId];
        
        return adId;
    }
#endif
    
    return nil;
}

- (NSString *) getMacSha:(NSString *) deviceAddress {
    
    //SHA1
    NSData *sha1_data = [deviceAddress dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(sha1_data.bytes, (CC_LONG)sha1_data.length, digest);
    NSMutableString* sha1 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [sha1 appendFormat:@"%02x", digest[i]];
    
    deviceAddress = [NSString stringWithFormat:@"%@",sha1];
    
    [self setMacAddrSha:deviceAddress];
    
    return deviceAddress;
}



#pragma mark -



-(void)onParameterCheckTimer:(NSTimer *)paramTimer {
    if ([self isInitialized] && [self lastParameterChange] > [self lastServerRequestTime]) {
        
        NSLog(@"CS_SDK: Sending client updates");
        
        [self.httpParams setObject:@"true" forKey:@"skip_fetch"];
        
        if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
            NSLog(@"Advertising tracking disabled.");
            [[CommuteStream open] setIOSLimitAdTracking:@"true"];
        }else {
            NSLog(@"Advertising tracking enabled.");
            
        }
        
        NSMutableString *uuidStringReplacement;
        
        uint8_t randomBytes[16];
        int result = SecRandomCopyBytes(kSecRandomDefault, 16, randomBytes);
        if(result == 0) {
            uuidStringReplacement = [[NSMutableString alloc] initWithCapacity:16*2];
            for(NSInteger index = 0; index < 16; index++)
            {
                [uuidStringReplacement appendFormat: @"%02x", randomBytes[index]];
            }
            NSLog(@"uuidStringReplacement is %@", uuidStringReplacement);
        } else {
            NSLog(@"SecRandomCopyBytes failed for some reason");
        }
        
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
        
        
        [[CommuteStream open] setSessionID: uuidStringReplacement];
        [[CommuteStream open] setTimeZone:tzName];
        
        
        
        __weak MKNetworkOperation *request = [networkEngine getBanner:http_params];
        
        [request setCompletionBlock:^{
            [self reportSuccessfulGet];
            [agency_interest removeAllObjects];
        }];
    }
}




- (void)reportSuccessfulGet {
    
    [self setLastServerRequestTime:[NSDate date]];
    
    NSLog(@"CS_SDK: Reported success to CommuteStream.");
    
    NSLog(@"CS_SDK: Time zone%@", time_zone);
    
    [self.httpParams removeObjectForKey:@"lat"];
    [self.httpParams removeObjectForKey:@"lon"];
    [self.httpParams removeObjectForKey:@"acc"];
    [self.httpParams removeObjectForKey:@"fix_time"];
    [self.httpParams removeObjectForKey:@"agency_interest"];
    [self.httpParams removeObjectForKey:@"limit_tracking"];
    
    [(NSMutableArray *)[self agencyInterest] removeAllObjects];
    
}

- (void)getAd:(NSObject *)banner{
    
    __weak MKNetworkOperation *request = [networkEngine getBanner:[self httpParams]];
    

    [request setCompletionBlock:^{
        
        NSDictionary *headerDict = [[request readonlyResponse] allHeaderFields];
    
        [self reportSuccessfulGet];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        
        //Get width and height from separate headers in the response to later be used for scaling within the ad unit
        //Get type of add from header
        
        NSString *creative_width = [headerDict objectForKey:@"X-CS-AD-WIDTH"];
        NSString *creative_height = [headerDict objectForKey:@"X-CS-AD-HEIGHT"];
        registerImpressionID = [headerDict objectForKey:@"X-CS-REQUEST-ID"];
        [dict setObject:[headerDict objectForKey:@"X-CS-AD-KIND"] forKey:@"kind"];
        [dict setObject:[headerDict objectForKey:@"X-CS-REQUEST-ID"] forKey:@"request_id"];
        [dict setObject:banner forKey:@"banner"];
        [dict setObject:banner_height forKey: @"bannerHeight"];
        [dict setObject:banner_width forKey: @"bannerWidth"];
        [dict setObject: creative_width forKey:@"creativeWidth"];
        [dict setObject: creative_height forKey:@"creativeHeight"];
        [dict setObject:[request responseString] forKey:@"htmlbody"];
        
        
        //if ([[dict objectForKey:@"item_returned"]boolValue] == YES) {
            if ([request responseString]){
                [self performSelectorOnMainThread:@selector(buildAd:) withObject:dict waitUntilDone:NO];
            }else{
                NSLog(@"CS_SDK: Ad request unfulfilled, deferring to AdMob");
                //[banner.delegate customEventBanner:banner didFailAd:request.error];
                NSDictionary *dictWithError = @{@"banner": [dict objectForKey:@"banner"], @"error": request.error};
                [self performSelectorOnMainThread:@selector(getAdFailedWithBanner:) withObject:dictWithError waitUntilDone:NO];
            }
        //}
    }];

    
     
}

-(void)getAdFailedWithBanner:(NSMutableDictionary *)dict{
    NSObject *customBanner = [dict objectForKey:@"banner"];
    NSError *dictError = [dict objectForKey:@"error"];
    if([customBanner conformsToProtocol:@protocol(CSCustomEventDelegate)]){
        [customBanner performSelector:@selector(didFailAdWithError:) withObject:dictError];
    }

}

-(void)buildAd:(NSMutableDictionary *)dict {
    adView = nil;
    
    NSObject *customBanner = [dict objectForKey:@"banner"];
    
    CSAdFactory *factory = [CSAdFactory factoryWithAdType:[dict objectForKey:@"kind"]];
    
    adView = [factory adViewFromDictionary:dict];
    
    
    if([customBanner conformsToProtocol:@protocol(CSCustomEventDelegate)]){
        [customBanner performSelector:@selector(didReceiveAdWithView:) withObject:adView];
    }
    
    
    impressionMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkForImpression:) userInfo:adView repeats:YES];
    
    
    
    
    
    
}

- (void)checkForImpression:(NSTimer *)timerParameter {
    
    CGPoint originalPoint = CGPointMake(adView.frame.origin.x, adView.frame.origin.y);
    
    CGPoint pointInAppFrame = [adView convertPoint:originalPoint toView:adView.superview.window];
    
    //NSLog(@"-----adView Rect %@", NSStringFromCGRect(CGRectMake(pointInAppFrame.x, pointInAppFrame.y, adView.frame.size.width, adView.frame.size.height)));
    
    //NSLog(@"-----App Rect %@", NSStringFromCGRect(adView.superview.window.frame));
    
    BOOL hasShown = CGRectIntersectsRect(CGRectMake(pointInAppFrame.x, pointInAppFrame.y, adView.frame.size.width, adView.frame.size.height), adView.superview.window.frame);
    
    
    if(hasShown && (adView.hidden == NO)){
        NSLog(@"impression counted - shut timer down");
        [impressionMonitorTimer invalidate];
        impressionMonitorTimer = nil;
        
        NSMutableDictionary *impressionDict = [NSMutableDictionary dictionaryWithDictionary: @{@"request_id" : registerImpressionID}];
        
        //api call
        __weak MKNetworkOperation *request = [networkEngine registerImpression:impressionDict];
        
        [request setCompletionBlock:^{
            NSLog(@"Reported it successfully");
        }];
        
        
    }
    
    
    
}


//GETTERS

- (NSString *)adUnitUUID {
    return ad_unit_uuid;
}


- (NSString *)bannerHeight{
    return banner_height;
}

- (NSString *)bannerWidth {
    return banner_width;
}

- (NSString *)sessionID {
    return session_ID;
}

- (NSString *)timeZone {
    return time_zone;
}

- (NSString *)sdkName {
    return sdk_name;
}

- (NSString *)appName {
    return app_name;
}

- (NSString *)sdkVer {
    return sdk_ver;
}

- (NSString *)appVer {
    return app_ver;
}

- (NSString *)latitude {
    return latitude;
}

- (NSString *)longitude {
    return longitude;
}

- (NSString *)accuracy {
    return acc;
}

- (NSString *)fixTime {
    return fix_time;
}
- (NSMutableArray *)agencyInterest {
    return agency_interest;
}
- (NSString *)idfaSha {
    return idfa_sha;
}
- (NSString *)macAddrSha {
    return mac_addr_sha;
}
- (NSString *)testing {
    return testing;
}

- (CLLocation *)location {
    return location;
}

- (NSMutableDictionary *)httpParams {
    return http_params;
}

-(NSDate *)lastServerRequestTime {
    return lastServerRequestTime;
}

-(NSDate *)lastParameterChange {
    return lastParameterChange;
}

-(BOOL)isInitialized {
    return initialized;
}

-(NSString *)agencyStringToSend {
    return agencyStringToSend;
}

-(NSString *)theme {
    return theme;
}

//SETTERS


- (void)setAdUnitUUID:(NSString *)adUnitUUID {
    ad_unit_uuid = adUnitUUID;
    [self.httpParams setObject:adUnitUUID forKey:@"ad_unit_uuid"];
}

- (void)setBannerHeight:(NSString *)bannerHeight{
    banner_height = bannerHeight;
    [self.httpParams setObject:bannerHeight forKey:@"banner_height"];
    
}

- (void)setBannerWidth:(NSString *)bannerWidth {
    banner_width = bannerWidth;
    [self.httpParams setObject:bannerWidth forKey:@"banner_width"];
}

- (void)setSessionID:(NSString *)sessionID {
    session_ID = sessionID;
    [self.httpParams setObject:sessionID forKey:@"session"];
}

- (void)setTimeZone:(NSString *)timeZone {
    time_zone = timeZone;
    [self.httpParams setObject:timeZone forKey:@"timezone"];
}

- (void)setSdkName:(NSString *)sdkName {
    sdk_name = sdkName;
    [self.httpParams setObject:sdkName forKey:@"sdk_name"];
}

- (void)setAppName:(NSString *)appName {
    app_name = appName;
    [self.httpParams setObject:appName forKey:@"app_name"];
}

- (void)setSdkVer:(NSString *)sdkVer {
    sdk_ver = sdkVer;
    [self.httpParams setObject:sdkVer forKey:@"sdk_ver"];
}

- (void)setAppVer:(NSString *)appVer {
    app_ver = appVer;
    [self.httpParams setObject:appVer forKey:@"app_ver"];
    
}

- (void)setTheme:(NSString *)themeString {
    theme = themeString;
    [self.httpParams setObject:themeString forKey:@"theme"];
    
}


- (void)setLatitude:(NSString *)thisLatitude {
    latitude = thisLatitude;
}

- (void)setLongitude:(NSString *)thisLongitude {
    longitude = thisLongitude;
}

- (void)setAccuracy:(NSString *)accuracy {
    acc = accuracy;
}

- (void)setFixTime:(NSString *)fixTime {
    fix_time = fixTime;
}


-(NSString *)iOSLimitAdTracking {
    return limit_tracking;
}

- (void)setIOSLimitAdTracking:(NSString *)value {
    limit_tracking = value;
    
    [self.httpParams setObject:value forKey:@"limit_tracking"];
}

- (void)setIdfa:(NSString *)thisIdfa {
    idfa = thisIdfa;
    [self.httpParams setObject:idfa forKey:@"idfa"];
}

- (void)setIdfaSha:(NSString *)idfaSha {
    idfa_sha = idfaSha;
    [self.httpParams setObject:idfaSha forKey:@"idfa_sha"];
}

- (void)setMacAddrSha:(NSString *)string {
    mac_addr_sha = string;
    [self.httpParams setObject:string forKey:@"mac_addr_sha"];
}

- (void)setTesting {
    [self.httpParams setObject:@"true" forKey:@"testing"];
}

- (void)setLocation:(CLLocation *)thisLocation {
    location = thisLocation;
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *haNumber = [NSNumber numberWithDouble:location.horizontalAccuracy];
    
    long long milliseconds = (long long)([location.timestamp timeIntervalSince1970] * 1000.0);
    
    NSString *fixTimeIntString = [NSString stringWithFormat:@"%lld", milliseconds];
    
    [self.httpParams setObject:[latitudeNumber stringValue] forKey:@"lat"];
    [self.httpParams setObject:[longitudeNumber stringValue] forKey:@"lon"];
    [self.httpParams setObject:[haNumber stringValue] forKey:@"acc"];
    [self.httpParams setObject: fixTimeIntString forKey:@"fix_time"];
    
    [self setLastParameterChange:[NSDate date]];
}

- (void)setHttpParams:(NSMutableDictionary *)httpParams {
    http_params = httpParams;
}

-(void)setLastServerRequestTime:(NSDate *)time {
    lastServerRequestTime = time;
}

-(void)setLastParameterChange:(NSDate *)time {
    lastParameterChange = time;
}

-(void)setIsInitialized:(BOOL)value {
    initialized = value;
}

-(void)setAgencyStringToSend:(NSString *)string {
    
    agencyStringToSend = string;
}

- (void)setAgencyInterest:(NSString *)typeString agencyID:(NSString *)agencyIDString routeID:(NSString *)routeIDString stopID:(NSString *)stopIDString{
    
    if (routeIDString == nil) {
        routeIDString = @"null";
    }
    
    if (stopIDString == nil) {
        stopIDString = @"null";
    }
    
    
    NSString *agencyInterestString = [[NSString alloc] initWithFormat:@"%@,%@,%@,%@", typeString, agencyIDString, routeIDString, stopIDString];
    
    [agency_interest addObject:agencyInterestString];
    
    [self setAgencyStringToSend:[agency_interest componentsJoinedByString:@","]];
    
    [self.httpParams setObject:agencyStringToSend forKey:@"agency_interest"];
    
    [self setLastParameterChange:[NSDate date]];
    
    
}

- (void)trackingDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self setAgencyInterest:@"TRACKING_DISPLAYED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Tracking interest added to CommuteStream parameters.");
}

- (void)alertDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self setAgencyInterest:@"ALERT_DISPLAYED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Alert interest added to CommuteStream parameters.");
}

- (void)mapDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self setAgencyInterest:@"MAP_DISPLAYED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Map interest added to CommuteStream parameters.");
}

- (void)favoriteAdded:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self setAgencyInterest:@"FAVORITE_ADDED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Favorite added to CommuteStream parameters.");
}

- (void)tripPlanningPointA:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self setAgencyInterest:@"TRIP_PLANNING_POINT_A" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Trip Planning interest added to CommuteStream parameters.");
}

- (void)tripPlanningPointB:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self setAgencyInterest:@"TRIP_PLANNING_POINT_B" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Trip Planning interest added to CommuteStream parameters.");
}

@end

