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


#define SDK_VERSION @"0.8.0"




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
    
    NSString *idfa;
    NSString *testing;
    NSString *limit_tracking;
    
    CLLocation *location;
    CSLocationManager *csLocationManager;
    
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

NSMutableDictionary *nativeAdDictionary;
CSNativeInterstitial *interstitialView;

//force create singleton
+ (id)allocWithZone:(NSZone *)zone {
    return [self open];
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSLog(@"CS_SDK: Initialized CS");
        
        http_params = [[NSMutableDictionary alloc] init];
        nativeAdDictionary = [[NSMutableDictionary alloc] init];
        
        agency_interest = [[NSMutableArray alloc] init];
        
        lastServerRequestTime = [NSDate date];
        lastParameterChange = [NSDate date];
        
        NSString *appHostUrl = @"api.commutestream.com";
        networkEngine = [[CSNetworkEngine alloc] initWithHostName:appHostUrl];
        
        parameterCheckTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(onParameterCheckTimer:) userInfo:nil repeats:YES];
        
        appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        localAppName = [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleName"];
        
        [self setAppVer:appVersion];
        [self setSdkName:@"com.commutestreamsdk"];
        [self setAppName:localAppName];
        
        [self setSdkVer:SDK_VERSION];
        
        NSData* sessionIDData;
        uint8_t randomBytes[16];
        int result = SecRandomCopyBytes(kSecRandomDefault, 16, randomBytes);
        
        if( result != 0 ) {
            for(int i = 0; i < 16; i+=1) {
                randomBytes[i] = rand();
            }
        }
        sessionIDData = [[NSData alloc] initWithBytes: randomBytes length: 16];
        NSString* sessionID = [sessionIDData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        sessionID = [sessionID stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        sessionID = [sessionID stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        [self setSessionID: sessionID];

        NSUUID* adId = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        [self setIdfa: [adId UUIDString]];
        
        if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
            NSLog(@"CS_SDK: Advertising tracking disabled.");
            [self setIOSLimitAdTracking:@"true"];
        }else {
            NSLog(@"CS_SDK: Advertising tracking enabled.");
        }
        
        csLocationManager = self.locationManager;
        
        if(csLocationManager.lastKnownLocation != nil){
            [self setLocation:csLocationManager.lastKnownLocation];
        }
        
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
        
        [self setTimeZone:tzName];
        
        
    }
    
    return self;
}


- (NSString *)idfa {
        return idfa;
}


-(void)onParameterCheckTimer:(NSTimer *)paramTimer {
    if ([self isInitialized] && [self lastParameterChange] > [self lastServerRequestTime]) {
        
        NSLog(@"CS_SDK: Sending client updates");
        
        [self.httpParams setObject:@"true" forKey:@"skip_fetch"];
        
        if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
            NSLog(@"CS_SDK: Advertising tracking disabled.");
            [[CommuteStream open] setIOSLimitAdTracking:@"true"];
        }else {
            NSLog(@"CS_SDK: Advertising tracking enabled.");
            
        }
        
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
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
        
        [self reportSuccessfulGet];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if ([[request readonlyResponse] statusCode] == 200) {
            
            @try{
                NSDictionary *headerDict = [[request readonlyResponse] allHeaderFields];
                
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
                
                if ([request responseString]){
                    [self performSelectorOnMainThread:@selector(buildAd:) withObject:dict waitUntilDone:NO];
                }else{
                    NSLog(@"CS_SDK: Ad request unfulfilled, deferring to AdMob");
                    NSError *error = [NSError errorWithDomain:@"com.commutestream.sdk" code:[[request readonlyResponse] statusCode] userInfo:@{@"Error reason": @"Unknown"}];
                    NSDictionary *dictWithError = @{@"banner": [dict objectForKey:@"banner"], @"error": error};
                    [self performSelectorOnMainThread:@selector(getAdFailedWithBanner:) withObject:dictWithError waitUntilDone:NO];
                }
            }
            
            @catch (NSException *exception){
                NSError *error = [NSError errorWithDomain:@"com.commutestream.sdk" code:[[request readonlyResponse] statusCode] userInfo:@{@"Error reason": @"Unknown"}];
                
                NSDictionary *dictWithError = @{@"banner": banner, @"error": error};
                [self performSelectorOnMainThread:@selector(getAdFailedWithBanner:) withObject:dictWithError waitUntilDone:NO];
            }
            
        }else if([[request readonlyResponse] statusCode] == 400){
            NSLog(@"CS_SDK: Ad request failed with error 400, bad request");
        }else if([[request readonlyResponse] statusCode] == 404) {
            NSLog(@"CS_SDK: No banner returned");
        }else if([[request readonlyResponse] statusCode] == 500){
            NSLog(@"CS_SDK: Ad request failed with error 500, server temporarily unavailable.");
        }else{
    
            NSError *error = [NSError errorWithDomain:@"com.commutestream.sdk" code:[[request readonlyResponse] statusCode] userInfo:@{@"Error reason": @"Unknown"}];
            NSLog(@"CS_SDK: Ad request failed with error %@, deferring to AdMob", error);
            NSDictionary *dictWithError = @{@"banner": banner, @"error": error};
            [self performSelectorOnMainThread:@selector(getAdFailedWithBanner:) withObject:dictWithError waitUntilDone:NO];
            
        }

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

    BOOL hasShown = CGRectIntersectsRect(CGRectMake(pointInAppFrame.x, pointInAppFrame.y, adView.frame.size.width, adView.frame.size.height), adView.superview.window.frame);
    
    
    if(hasShown && (adView.hidden == NO)){
        
        [impressionMonitorTimer invalidate];
        impressionMonitorTimer = nil;
        
        
        NSMutableDictionary *retryDict = [NSMutableDictionary dictionaryWithDictionary:@{@"delay" : @5.0, @"count" : @7}];
        [self callRegisterImpressionWithTimerParams:retryDict];
    
    }
}


- (void)callRegisterImpressionWithTimerParams:(NSMutableDictionary *)params {
    
    NSMutableDictionary *impressionDict = [NSMutableDictionary dictionaryWithDictionary: @{@"request_id" : registerImpressionID}];
    
    NSLog(@"Params = %@", params);
    
    __block CGFloat impressionResponseTimerDelay = [[params objectForKey:@"delay"] floatValue];
    __block NSInteger impressionResponseTimerCount = [[params objectForKey:@"count"] integerValue];
    
    
    //api call
    __weak MKNetworkOperation *request = [networkEngine registerImpression:impressionDict];
    
    [request setCompletionBlock:^{
        
        if ([[request readonlyResponse] statusCode] == 204 || [[request readonlyResponse] statusCode] == 303) {
            
            NSLog(@"CS_SDK: Reported impression successfully");
        }else{
    
            if(impressionResponseTimerCount > 0){
                
                impressionResponseTimerDelay *= 2;
                impressionResponseTimerCount--;
                
                NSLog(@"impression timer delay = %f", impressionResponseTimerDelay);
                NSLog(@"impression timer count = %ld", (long)impressionResponseTimerCount);
                
                NSMutableDictionary *retryDict = [NSMutableDictionary dictionaryWithDictionary:@{@"delay" : @(impressionResponseTimerDelay), @"count" : @(impressionResponseTimerCount)}];
                
                NSLog(@"Retry Dict = %@", retryDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSelector:@selector(callRegisterImpressionWithTimerParams:) withObject:retryDict afterDelay:impressionResponseTimerDelay];
                });
                NSLog(@"CS_SDK: Failed to report impression. Trying again in %f seconds.", impressionResponseTimerDelay);
            }
            
            
            
        }
        
    }];

}


+ (CSNativeAdIcon *)getNativeAdIconForStopID:(NSString *)stopID {
    
    CSNativeAdIcon *icon = [[CSNativeAdIcon alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70.0, 7.0, 30.0, 30.0) andTapHandler:^(void){
    
        NSLog(@"tapped stop ID - %@", stopID);
        
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CSNativeInterstitial *interstitial = [[CSNativeInterstitial alloc] initWithFrame:bounds];
        interstitial.windowLevel = UIWindowLevelAlert;
        interstitialView = interstitial;
        [interstitial makeKeyAndVisible];
        
            
    }];
    
    
    [icon setImage:[UIImage imageNamed:[[[nativeAdDictionary objectForKey:stopID] objectForKey:@"icon"] objectForKey:@"icon_name"]]];
    
    return icon;
    
}

+ (void)getNativeAdsForStops:(NSArray *)stopsArray onComplete:(void(^)(void))callback {
    
    //package up request as required by buffer protocols
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    for(NSString *stopID in stopsArray){
        [tempDict setObject:@"" forKey:stopID];
    }
    
    //make request with stops

    //response
    //add returned ads with the the stop id for the key and everything else for the value in local dictionary.
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"stop_list_icons" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath]; NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    nativeAdDictionary = json;

    callback();
    
}


- (void)callRegisterClickWithTimerParams:(NSMutableDictionary *)params {
    
    NSMutableDictionary *clickDict = [NSMutableDictionary dictionaryWithDictionary: @{@"request_id" : [params objectForKey:@"requestID"]}];
    
    NSLog(@"Params = %@", params);
    
    __block CGFloat clickResponseTimerDelay = [[params objectForKey:@"delay"] floatValue];
    __block NSInteger clickResponseTimerCount = [[params objectForKey:@"count"] integerValue];
    __block NSString *clickResponseRequestID = [params objectForKey:@"requestID"];
    
    
    //api call
    __weak MKNetworkOperation *request = [networkEngine registerClick:clickDict];
    
    
    [request setCompletionBlock:^{
        
        if ([[request readonlyResponse] statusCode] == 204 || [[request readonlyResponse] statusCode] == 303) {
            
            NSLog(@"CS_SDK: Reported click successfully");
        }else{
            
            if(clickResponseTimerCount > 0){
                
                clickResponseTimerDelay *= 2;
                clickResponseTimerCount--;
                
                NSLog(@"click timer delay = %f", clickResponseTimerDelay);
                NSLog(@"click timer count = %ld", (long)clickResponseTimerCount);
                
                NSMutableDictionary *retryDict = [NSMutableDictionary dictionaryWithDictionary:@{@"delay" : @(clickResponseTimerDelay), @"count" : @(clickResponseTimerCount), @"requestID" : clickResponseRequestID}];
                
                NSLog(@"Retry Dict = %@", retryDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSelector:@selector(callRegisterClickWithTimerParams:) withObject:retryDict afterDelay:clickResponseTimerDelay];
                });
                
                NSLog(@"CS_SDK: Failed to report click. Trying again in %f seconds.", clickResponseTimerDelay);
            }
            
            
            
        }
        
    }];
    
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
- (NSString *)testing {
    return testing;
}

- (CLLocation *)location {
    return location;
}

- (CSLocationManager *)locationManager {
    return [[CSLocationManager alloc] init];
}

- (NSMutableDictionary *)httpParams {
    return http_params;
}

+ (NSMutableDictionary *)nativeAdDict {
    return nativeAdDictionary;
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
    [self.httpParams setObject:bannerHeight forKey:@"height"];
    
}

- (void)setBannerWidth:(NSString *)bannerWidth {
    banner_width = bannerWidth;
    [self.httpParams setObject:bannerWidth forKey:@"width"];
}

- (void)setSessionID:(NSString *)sessionID {
    session_ID = sessionID;
    [self.httpParams setObject:sessionID forKey:@"session_id"];
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

- (void)setTesting {
    [self.httpParams setObject:@"true" forKey:@"testing"];
}

- (void)setLocation:(CLLocation *)thisLocation {
    NSLog(@"setLocation called");
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

+ (void)setNaviteAdDict:(NSMutableDictionary *)nativeAdDict {
    nativeAdDictionary = nativeAdDict;
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

