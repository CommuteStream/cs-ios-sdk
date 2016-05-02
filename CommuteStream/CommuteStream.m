//
//  CommuteStream.m
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import "CSNetworkEngine.h"
#import "CommuteStream.h"
#import "GADBannerViewDelegate.h"
#import <AdSupport/ASIdentifierManager.h>


@implementation CommuteStream

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
        int portNumber = 3000;
        [networkEngine setPortNumber: portNumber];
        
        parameterCheckTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(onParameterCheckTimer:) userInfo:nil repeats:YES];
        
    }
    
    return self;
}



-(void)onParameterCheckTimer:(NSTimer *)paramTimer {
    NSLog(@"CS_SDK: Timer Fired");
    
    
    if ([self isInitialized] && [self lastParameterChange] > [self lastServerRequestTime]) {
        
        NSLog(@"CS_SDK: Updating the server.");
        
        [self.httpParams setObject:@"true" forKey:@"skip_fetch"];
        
        if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
            
            NSLog(@"Advertising tracking disabled.");
            [[CommuteStream open] setIOSLimitAdTracking:@"true"];
        }else {
            NSLog(@"Advertising tracking enabled.");
        }
        
        
        
        
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

