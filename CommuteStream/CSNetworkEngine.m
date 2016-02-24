@import Foundation;

#import "CSNetworkEngine.h"

@implementation CSNetworkEngine

- (void) initWithHostName:(NSString *)hostName {
    self.hostName = hostName;
}

- (void) getBanner:(NSMutableDictionary *)callParams {
    
    NSURL *url = [NSURL URLWithString:@"https://api.commutestream.com:3000/banner"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:callParams progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
