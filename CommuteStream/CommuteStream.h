#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CSNativeAdIcon.h"
#import "CSNativeInterstitial.h"
#import "CSLocationManager.h"

@interface CommuteStream : NSObject


+ (CommuteStream *)open;

- (BOOL)isInitialized;

- (void)reportSuccessfulGet;

- (NSString *)adUnitUUID;

- (NSString *)bannerHeight;

- (NSString *)bannerWidth;

- (NSString *)sessionID;

- (NSString *)timeZone;

- (NSString *)sdkName;

- (NSString *)appName;

- (NSString *)sdkVer;

- (NSString *)appVer;

- (NSString *)latitude;

- (NSString *)longitude;

- (NSString *)accuracy;

- (NSString *)fixTime;

- (NSString *)agencyInterest;

- (NSString *)idfa;

- (NSString *)testing;

- (CLLocation *)location;

+ (CSNativeAdIcon *)getNativeAdIconForStopID:(NSString *)stopID;
+ (void)getNativeAdsForStops:(NSArray *)stopsArray onComplete:(void(^)(void))callback;

- (CSLocationManager *)locationManager;

+ (NSMutableDictionary *)nativeAdDict;

- (NSDate *)lastServerRequestTime;

- (NSDate *)lastParameterChange;

- (NSString *)agencyStringToSend;

- (NSString *)theme;

- (bool)iOSLimitAdTracking;

- (void)setIOSLimitAdTracking:(bool)value;

- (void)getAd:(NSObject *)banner;

- (void)setIsInitialized:(BOOL)value;

- (void)setAdUnitUUID:(NSString *)adUnitUUID;

- (void)setBannerHeight:(NSString *)bannerHeight;

- (void)setBannerWidth:(NSString *)bannerWidth;


- (void)callRegisterClickWithTimerParams:(NSMutableDictionary*)params;

- (void)setSessionID:(NSString *)sessionID;

- (void)setTimeZone:(NSString *)timeZone;


- (void)setSdkName:(NSString *)sdkName;

- (void)setAppName:(NSString *)appName;

- (void)setSdkVer:(NSString *)sdkVer;

- (void)setAppVer:(NSString *)appVer;

- (void)setLatitude:(NSString *)thisLatitude;

- (void)setLongitude:(NSString *)thisLongitude;

- (void)setAccuracy:(NSString *)accuracy;

- (void)setFixTime:(NSString *)fixTime;

- (void)addAgencyInterest:(NSString *)typeString agencyID:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)setIdfa:(NSString *)idfa;

- (void)setTesting;

- (void)setLocation:(CLLocation *)thisLocation;

+ (void)setNaviteAdDict:(NSMutableDictionary *)nativeAdDict;

- (void)setLastServerRequestTime:(NSDate *)time;

- (void)setLastParameterChange:(NSDate *)time;

- (void)setTheme:(NSString *)themeString;

- (void)trackingDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)alertDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)mapDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)favoriteAdded:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)tripPlanningPointA:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)tripPlanningPointB:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

@end
