///Users/tburdick/src/ios-sdk/CommuteStream
//  CSNetworkEngine.h
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import "MKNetworkKit.h"
#import "Csmessages.pbobjc.h"

@interface CSNetworkEngine : NSObject

- (id) initWithHostName:(NSString *)host;

- (void) getStopAds:(CSPStopAdRequest *)request handler:(void(^)(CSPStopAdResponse *response))callback;

- (MKNetworkRequest *) getBanner:(NSMutableDictionary *)callParams;

- (MKNetworkRequest *) registerImpression:(NSMutableDictionary *)callParams;

- (MKNetworkRequest *) registerClick:(NSMutableDictionary *)callParams;


@end
