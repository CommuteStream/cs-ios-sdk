#import "MKNetworkKit.h"
#import "Csmessages.pbobjc.h"

@interface CSNetworkEngine : NSObject

- (id) initWithHostName:(NSString *)host;

- (void) getStopAds:(CSPStopAdRequest *)request handler:(void(^)(CSPStopAdResponse *response))callback;

- (MKNetworkRequest *) getBanner:(NSMutableDictionary *)callParams;

- (MKNetworkRequest *) registerImpression:(NSMutableDictionary *)callParams;

- (MKNetworkRequest *) registerClick:(NSMutableDictionary *)callParams;


@end
