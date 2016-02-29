//
//  CommuteStream.h
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CSNetworkEngine.h"


@interface CommuteStream : NSObject {
    
    
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
    
	NSMutableArray *agency_interest;
    
	NSString *idfa_sha;
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
}

+ (CommuteStream *)open;

- (BOOL)isInitialized;

-(void)reportSuccessfulGet;

- (NSString *)adUnitUUID;

- (NSString *)bannerHeight;

- (NSString *)bannerWidth;

- (NSString *)sdkName;

- (NSString *)appName;

- (NSString *)sdkVer;

- (NSString *)appVer;

- (NSString *)latitude;

- (NSString *)longitude;

- (NSString *)accuracy;

- (NSString *)fixTime;

- (NSString *)agencyInterest;

- (NSString *)idfaSha;

- (NSString *)macAddrSha;

- (NSString *)testing;

- (CLLocation *)location;

- (NSMutableDictionary *)httpParams;

-(NSDate *)lastServerRequestTime;

-(NSDate *)lastParameterChange;

-(NSString *)agencyStringToSend;

-(NSString *)theme;

-(NSString *)iOSLimitAdTracking;

- (void)setIOSLimitAdTracking:(NSString *)value;



- (void)setIsInitialized:(BOOL)value;

- (void)setAdUnitUUID:(NSString *)adUnitUUID;

- (void)setBannerHeight:(NSString *)bannerHeight;

- (void)setBannerWidth:(NSString *)bannerWidth;

- (void)setSdkName:(NSString *)sdkName;

- (void)setAppName:(NSString *)appName;

- (void)setSdkVer:(NSString *)sdkVer;

- (void)setAppVer:(NSString *)appVer;

- (void)setLatitude:(NSString *)thisLatitude;

- (void)setLongitude:(NSString *)thisLongitude;

- (void)setAccuracy:(NSString *)accuracy;

- (void)setFixTime:(NSString *)fixTime;

- (void)setAgencyInterest:(NSString *)typeString agencyID:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)setIdfaSha:(NSString *)idfaSha;

- (void)setMacAddrSha:(NSString *)string;

- (void)setTesting;

- (void)setLocation:(CLLocation *)thisLocation;

- (void)setHttpParams:(NSMutableDictionary *)httpParams;

-(void)setLastServerRequestTime:(NSDate *)time;

-(void)setLastParameterChange:(NSDate *)time;

-(void)setAgencyStringToSend:(NSString *)string;

-(void)setTheme:(NSString *)themeString;

- (void)trackingDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)alertDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)mapDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)favoriteAdded:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)tripPlanningPointA:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)tripPlanningPointB:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

@end
