// Client protocol definition for communication with CommuteStream

#ifndef CSClient_h
#define CSClient_h

#import <CoreLocation/CoreLocation.h>
#import "Csmessages.pbobjc.h"

@interface CSBannerRequest : NSObject
@property NSString *sessionID;
@property NSString *adUnitUUID;
@property NSString *IDFA;
@property bool limitTracking;
@property NSString *timezone;
@property CLLocation *location;
@property NSMutableSet *agencyInterests;
@property bool testing;
@property bool skipFetch;
@property uint64_t bannerWidth;
@property uint64_t bannerHeight;
@end

@interface CSBannerResponse : NSObject
@property NSString *bannerID;
@property NSString *requestID;
@property NSString *adKind;
@property NSData *ad;
@property uint64_t bannerWidth;
@property uint64_t bannerHeight;
@property uint64_t creativeWidth;
@property uint64_t creativeHeight;
@end

@protocol CSClient

- (id) initWithHostName:(NSString *)host;

- (void) getStopAds:(CSPStopAdRequest *)stopAdsRequest handler:(void(^)(CSPStopAdResponse *stopAdsResponse))callback;

- (void) getBanner:(CSBannerRequest *)bannerRequest handler:(void(^)(CSBannerResponse *bannerResponse))callback;

- (void) registerImpression:(NSString *)impressionRequest;

- (void) registerClick:(NSString *)clickRequest;

@end

#endif /* CSClient_h */
