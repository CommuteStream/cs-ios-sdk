//
//  CSNetworkEngine.m
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import "CSNetworkEngine.h"

@implementation CSNetworkEngine

- (MKNetworkOperation *) getBanner:(NSMutableDictionary *)callParams {
    
    MKNetworkOperation *op = [self operationWithPath:@"banner" params:callParams httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"CS_SDK: Call to banner server successful");
        
    }errorHandler:^(MKNetworkOperation *operation, NSError *error){
        NSLog(@"CS_SDK: Error from banner server - %@", error);
    }];
    
    
    [self enqueueOperation:op];
    
    return op;
    
}


@end
