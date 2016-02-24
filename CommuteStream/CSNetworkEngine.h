#import <AFNetworking/AFNetworking.h>

@interface CSNetworkEngine : NSObject

@property NSString *hostName;

- (void) initWithHostName:(NSString *)hostName;

- (void) getBanner:(NSMutableDictionary *)callParams;


@end
