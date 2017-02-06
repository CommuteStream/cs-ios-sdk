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
    
    MKNetworkOperation *op = [self operationWithPath:@"v2/banner" params:callParams httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"CS_SDK: Call to banner server successful");
        
    }errorHandler:^(MKNetworkOperation *operation, NSError *error){
        if([[operation readonlyResponse] statusCode] != 404) {
            NSLog(@"CS_SDK: Error from banner server - %@", error);
        }
    }];
    
    
    [self enqueueOperation:op];
    return op;
    
}


- (MKNetworkOperation *) registerImpression:(NSMutableDictionary *)callParams {
    
    MKNetworkOperation *op = [self operationWithPath:@"v2/impression" params:callParams httpMethod:@"GET" ssl:YES];
   
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"CS_SDK: Registered impression successfully.");
        
    }errorHandler:^(MKNetworkOperation *operation, NSError *error){
        NSLog(@"CS_SDK: Error registering impression - %@", error);
    }];
    
    
    [self enqueueOperation:op];
    
    return op;
    
}

- (MKNetworkOperation *) registerClick:(NSMutableDictionary *)callParams {
    MKNetworkOperation *op = [self operationWithPath:@"v2/click" params:callParams httpMethod:@"GET" ssl:YES];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"CS_SDK: Registered click successfully.");
        
    }errorHandler:^(MKNetworkOperation *operation, NSError *error){
        NSLog(@"CS_SDK: Error registering click - %@", error);
    }];
    
    
    [self enqueueOperation:op];
    
    return op;
}

@end
