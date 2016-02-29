#import "AFNetworking/AFNetworking.h"

typedef void (^CSNetworkSuccess)(NSURLSessionTask *task, id responseObject);
typedef void (^CSNetworkFailure)(NSURLSessionTask *task, NSError *error);

@interface CSNetworkEngine : NSObject

@property NSString *hostName;

-(CSNetworkEngine *) initWithHostName:(NSString *)hostName;

-(void) getBanner:(NSMutableDictionary *)callParams withSuccess:(CSNetworkSuccess)success withFailure:(CSNetworkFailure)failure;

@end
