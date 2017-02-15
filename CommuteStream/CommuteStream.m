#import "CommuteStream.h"
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
#import "CSClient.h"
#import "CSHttpClient.h"

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
    NSString *idfa;
    NSString *testing;
    bool limit_tracking;
    
    CLLocation *location;
    CSLocationManager *csLocationManager;
    
    NSDate *lastServerRequestTime;
    NSDate *lastParameterChange;
    
    NSTimer *parameterCheckTimer;
    
    id<CSClient> client;
    CSBannerRequest *bannerRequest;
    
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
        
        bannerRequest = [CSBannerRequest alloc];
        
        lastServerRequestTime = [NSDate date];
        lastParameterChange = [NSDate date];
        
        NSString *appHostUrl = @"api.commutestream.com";
        client = [[CSHttpClient alloc] initWithHostName:appHostUrl];
        
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
            [self setIOSLimitAdTracking:true];
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
        
        [bannerRequest setSkipFetch:true];
        if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
            NSLog(@"CS_SDK: Advertising tracking disabled.");
            [[CommuteStream open] setIOSLimitAdTracking:true];
        }else {
            NSLog(@"CS_SDK: Advertising tracking enabled.");
        }
        
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
        [[CommuteStream open] setTimeZone:tzName];
        
        [client getBanner:bannerRequest handler:^(CSBannerResponse *bannerResponse) {
            [self onSuccessfulBannerRequest];
        }];
    }
}


- (void) onSuccessfulBannerRequest {
    [self setLastServerRequestTime:[NSDate date]];
    
    NSLog(@"CS_SDK: Reported success to CommuteStream.");
    [bannerRequest setLocation:NULL];
    [bannerRequest setAgencyInterests:NULL];
    [bannerRequest setSkipFetch:false];
}

- (void)getAd:(id<CSCustomEventDelegate>)bannerDelegate {
    [client getBanner:bannerRequest handler:^(CSBannerResponse *bannerResponse) {
        [self onSuccessfulBannerRequest];
        if(bannerResponse == NULL) {
            NSError *error = [NSError errorWithDomain:@"com.commutestream.sdk" code:0 userInfo:@{@"Error reason": @"Unknown"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getAdFailedWithDelegate:bannerDelegate error:error];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self buildAd:bannerResponse eventDelegate:bannerDelegate];
            });
        }
    }];
}

- (void)getAdFailedWithDelegate:(id<CSCustomEventDelegate>)bannerDelegate error:(NSError *)error {
    [bannerDelegate didFailAdWithError:error];
}

-(void)buildAd:(CSBannerResponse *)bannerResponse eventDelegate:(id<CSCustomEventDelegate>)eventDelegate {
    adView = nil;
    CSAdFactory *factory = [CSAdFactory factoryWithAdType:[bannerResponse adKind]];
    adView = [factory adViewFromBannerResponse:bannerResponse];
    
    [eventDelegate didReceiveAdWithView:adView];
    
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
        //[client registerImpression:?];
    }
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
    
    
    //[icon setImage:[UIImage imageNamed:[[[nativeAdDictionary objectForKey:stopID] objectForKey:@"icon"] objectForKey:@"icon_name"]]];
    
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

- (NSArray *)agencyInterest {
    return [[bannerRequest agencyInterests] allObjects];
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
    ad_unit_uuid = adUnitUUID;}

- (void)setBannerHeight:(NSString *)bannerHeight{
    banner_height = bannerHeight;
}

- (void)setBannerWidth:(NSString *)bannerWidth {
    banner_width = bannerWidth;
}

- (void)setSessionID:(NSString *)sessionID {
    session_ID = sessionID;
}

- (void)setTimeZone:(NSString *)timeZone {
    time_zone = timeZone;
}

- (void)setSdkName:(NSString *)sdkName {
    sdk_name = sdkName;
}

- (void)setAppName:(NSString *)appName {
    app_name = appName;
}

- (void)setSdkVer:(NSString *)sdkVer {
    sdk_ver = sdkVer;
}

- (void)setAppVer:(NSString *)appVer {
    app_ver = appVer;
}

- (void)setTheme:(NSString *)themeString {
    theme = themeString;
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


- (bool) iOSLimitAdTracking {
    return limit_tracking;
}

- (void)setIOSLimitAdTracking:(bool)value {
    limit_tracking = value;
    [bannerRequest setLimitTracking:value];
}

- (void)setIdfa:(NSString *)thisIdfa {
    idfa = thisIdfa;
}

- (void)setTesting {
    [bannerRequest setTesting:true];
}

- (void)setLocation:(CLLocation *)thisLocation {
    NSLog(@"setLocation called");
    location = thisLocation;
    [bannerRequest setLocation:location];
    [self setLastParameterChange:[NSDate date]];
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

- (void)addAgencyInterest:(NSString *)typeString agencyID:(NSString *)agencyIDString routeID:(NSString *)routeIDString stopID:(NSString *)stopIDString{
    if (routeIDString == nil) {
        routeIDString = @"null";
    }
    if (stopIDString == nil) {
        stopIDString = @"null";
    }
    NSString *agencyInterestString = [[NSString alloc] initWithFormat:@"%@,%@,%@,%@", typeString, agencyIDString, routeIDString, stopIDString];
    if([bannerRequest agencyInterests] == NULL) {
        [bannerRequest setAgencyInterests:[NSMutableSet alloc]];
    }
    [[bannerRequest agencyInterests] addObject:agencyInterestString];
    
    [self setLastParameterChange:[NSDate date]];
    
    
}

- (void)trackingDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self addAgencyInterest:@"TRACKING_DISPLAYED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Tracking interest added to CommuteStream parameters.");
}

- (void)alertDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self addAgencyInterest:@"ALERT_DISPLAYED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Alert interest added to CommuteStream parameters.");
}

- (void)mapDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self addAgencyInterest:@"MAP_DISPLAYED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Map interest added to CommuteStream parameters.");
}

- (void)favoriteAdded:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self addAgencyInterest:@"FAVORITE_ADDED" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Favorite added to CommuteStream parameters.");
}

- (void)tripPlanningPointA:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self addAgencyInterest:@"TRIP_PLANNING_POINT_A" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Trip Planning interest added to CommuteStream parameters.");
}

- (void)tripPlanningPointB:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString {
    [self addAgencyInterest:@"TRIP_PLANNING_POINT_B" agencyID:agencyIDString routeID:routeIDString stopID:stopIDString];
    
    NSLog(@"CS_SDK: Trip Planning interest added to CommuteStream parameters.");
}

@end

