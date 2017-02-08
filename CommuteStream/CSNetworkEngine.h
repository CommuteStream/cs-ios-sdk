//
//  CSNetworkEngine.h
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface CSNetworkEngine : MKNetworkEngine

- (MKNetworkOperation *) getBanner:(NSMutableDictionary *)callParams;

- (MKNetworkOperation *) registerImpression:(NSMutableDictionary *)callParams;

- (MKNetworkOperation *) registerClick:(NSMutableDictionary *)callParams;


@end
