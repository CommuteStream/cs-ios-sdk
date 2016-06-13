#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CommuteStream : NSObject

+ (CommuteStream *)open;

- (BOOL)isInitialized;

- (void)reportSuccessfulGet;

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

- (NSDate *)lastServerRequestTime;

- (NSDate *)lastParameterChange;

- (NSString *)agencyStringToSend;

- (NSString *)theme;

- (NSString *)iOSLimitAdTracking;

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

- (void)setIdfa:(NSString *)idfa;

- (void)setIdfaSha:(NSString *)idfaSha;

- (void)setMacAddrSha:(NSString *)string;

- (void)setTesting;

- (void)setLocation:(CLLocation *)thisLocation;

- (void)setHttpParams:(NSMutableDictionary *)httpParams;

- (void)setLastServerRequestTime:(NSDate *)time;

- (void)setLastParameterChange:(NSDate *)time;

- (void)setAgencyStringToSend:(NSString *)string;

- (void)setTheme:(NSString *)themeString;

- (void)trackingDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)alertDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)mapDisplayed:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)favoriteAdded:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)tripPlanningPointA:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

- (void)tripPlanningPointB:(NSString*)agencyIDString routeID:(NSString*)routeIDString stopID:(NSString*)stopIDString;

@end
