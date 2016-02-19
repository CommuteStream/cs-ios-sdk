//
//  CSNetworkEngine.h
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKNetworkEngine.h"

@interface CSNetworkEngine : MKNetworkEngine

- (MKNetworkOperation *) getBanner:(NSMutableDictionary *)callParams;


@end