#import <Foundation/Foundation.h>
#import "CSHttpClient.h"

@implementation CSHttpClient {
    NSURLSession *_session;
    NSString *_hostName;
}

- (instancetype) initWithHostName:(NSString *)host  {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    [config setTimeoutIntervalForRequest:2];
    [config setTimeoutIntervalForResource:2];
    _session = [NSURLSession sessionWithConfiguration:config];
    _hostName = host;
    return self;
}

- (void) getStopAds:(CSPStopAdRequest *)request handler:(void (^)(CSPStopAdResponse *))callback {
    NSString *baseUrl = [NSString stringWithFormat:@"https://%@/v2/stop_ads", _hostName];
    NSURL *url = [[NSURL alloc] initWithString:baseUrl];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPBody:[request data]];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    }];
    [task resume];
}

- (void) getBanner:(CSBannerRequest *)bannerRequest handler:(void (^)(CSBannerResponse *))callback {
    NSString *baseUrl = [NSString stringWithFormat:@"https://%@/v2/banner", _hostName];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:baseUrl];
    NSMutableArray *queryItems = [NSMutableArray arrayWithCapacity:5];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"session_id" value:[bannerRequest sessionID]]];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"ad_unit_uuid" value:[bannerRequest adUnitUUID]]];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"timezone" value:[bannerRequest timezone]]];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"idfa" value:[bannerRequest IDFA]]];
    if([bannerRequest limitTracking]) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"limit_tracking" value:@"true"]];
    }
    if([bannerRequest skipFetch]) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"skip_fetch" value:@"true"]];
    }
    if([bannerRequest testing]) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"testing" value:@"true"]];
    }
    if([bannerRequest bannerWidth] != 0 && [bannerRequest bannerHeight] != 0) {
        NSString *width = [NSString stringWithFormat:@"%qu", [bannerRequest bannerWidth]];
        NSString *height = [NSString stringWithFormat:@"%qu", [bannerRequest bannerHeight]];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"width" value:width]];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"height" value:height]];
    }
    if([bannerRequest agencyInterests] != NULL) {
        NSString *agencyInterests = [[[bannerRequest agencyInterests] allObjects] componentsJoinedByString:@","];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"agency_interests" value:agencyInterests]];
    }
    if([bannerRequest location] != NULL) {
        CLLocationCoordinate2D coord = [[bannerRequest location] coordinate];
        NSString *lat = [NSString stringWithFormat:@"%f", coord.latitude];
        NSString *lon = [NSString stringWithFormat:@"%f", coord.longitude];
        long long loc_fix_time = (long long)([[[bannerRequest location] timestamp] timeIntervalSince1970] * 1000.0);
        NSString *fix_time = [NSString stringWithFormat:@"%qi", loc_fix_time];
        NSString *acc = [NSString stringWithFormat:@"%f", [[bannerRequest location] horizontalAccuracy]];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"lat" value:lat]];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"lon" value:lon]];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"acc" value:acc]];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"fix_time" value:fix_time]];
    }
    [components setQueryItems:queryItems];
    NSURL *url = [components URL];
    NSURLSessionDataTask *task = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        @try {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if([httpResponse statusCode] != 200) {
                return callback(NULL);
            }
            NSDictionary *headers = [httpResponse allHeaderFields];
            NSString *adKind = [headers valueForKey:@"X-CS-AD-KIND"];
            NSString *requestID =[headers valueForKey:@"X-CS-REQUEST-ID"];
            NSString *impressionUrl = [headers valueForKey:@"X-CS-IMPRESSION-URL"];
            NSString *clickUrl = [headers valueForKey:@"X-CS-CLICK-URL"];
            NSString *creativeWidth = [headers objectForKey:@"X-CS-AD-WIDTH"];
            NSString *creativeHeight = [headers objectForKey:@"X-CS-AD-HEIGHT"];
            CSBannerResponse *bannerResponse = [CSBannerResponse alloc];
            if(data == NULL || adKind == NULL || requestID == NULL || impressionUrl == NULL || clickUrl == NULL) {
                return callback(NULL);
            }
            [bannerResponse setAd:data];
            [bannerResponse setAdKind:adKind];
            [bannerResponse setRequestID:requestID];
            [bannerResponse setCreativeWidth:[creativeWidth longLongValue]];
            [bannerResponse setCreativeHeight:[creativeHeight longLongValue]];
            [bannerResponse setBannerWidth:[bannerRequest bannerWidth]];
            [bannerResponse setBannerHeight:[bannerRequest bannerHeight]];
            return callback(bannerResponse);
        }
        @catch (NSError *err) {
            return callback(nil);
        }
    }];
    [task resume];
}

- (void) registerImpression:(NSString *)impressionUrl {
    [self retryGet:impressionUrl retries:8 delay:5000];
}

- (void) registerClick:(NSString *)clickUrl {
    [self retryGet:clickUrl retries:8 delay:5000];
}

// Retry performing a GET to a given URL with a number of retries and a doubling delay starting from a given msec delay value
// each retry. Success is considered to be a 204 or 303 as no response handling is every done.
- (void) retryGet:(NSString *)path retries:(uint64_t)retries delay:(uint64_t)delay {
    NSURL *url = [[NSURL alloc] initWithString:path];
    NSURLSessionDataTask *task = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if([httpResponse statusCode] == 204 || [httpResponse statusCode] == 303) {
            return;
        }
        if(retries > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                [self retryGet:path retries:(retries - 1) delay:delay*2];
            });
        }
    }];
    [task resume];
}

@end


