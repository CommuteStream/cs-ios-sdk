//
//  CSNetworkEngine.m
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import "CSNetworkEngine.h"

@implementation CSNetworkEngine {
    MKNetworkHost *_client;
}

- (instancetype) initWithHostName:(NSString *)host {
    _client = [[MKNetworkHost alloc]initWithHostName:host];
    return self;
}

- (MKNetworkRequest *) getStopAds:(CSPStopAdRequest *)request {
    MKNetworkRequest *req = [_client requestWithPath:@"v2/stop_ads" params:nil httpMethod:@"POST" body:nil ssl:YES];
    [_client startRequest:req];
    return req;
}

- (MKNetworkRequest *) getBanner:(NSMutableDictionary *)callParams {
    MKNetworkRequest *req = [_client requestWithPath:@"v2/banner" params:callParams httpMethod:@"GET" body:nil ssl:YES];
    [req addCompletionHandler:^(MKNetworkRequest *req){
        if([req error] == nil) {
            NSLog(@"CS_SDK: Call to banner server successful");
        } else {
            NSLog(@"CS_SDK: Call to banner server error - %@", [req error]);
        }
    }];
    [_client startRequest:req];
    return req;
}


- (MKNetworkRequest *) registerImpression:(NSMutableDictionary *)callParams {
    MKNetworkRequest *req = [_client requestWithPath:@"v2/impression" params:callParams httpMethod:@"GET" body:nil ssl:YES];
    [req addCompletionHandler:^(MKNetworkRequest *req){
        if([req error] == nil) {
            NSLog(@"CS_SDK: Registered impression successfully.");
        } else {
            NSLog(@"CS_SDK: Error registering impression - %@", [req error]);
        }
    }];
    [_client startRequest:req];
    return req;
}

- (MKNetworkRequest *) registerClick:(NSMutableDictionary *)callParams {
    MKNetworkRequest *req = [_client requestWithPath:@"v2/click" params:callParams httpMethod:@"GET" body:nil ssl:YES];
    
    
    [req addCompletionHandler:^(MKNetworkRequest *req){
        if([req error] == nil) {
            NSLog(@"CS_SDK: Registered click successfully.");
        } else {
            NSLog(@"CS_SDK: Error registering click - %@", [req error]);
        }
    }];
    [_client startRequest:req];
    return req;
}

@end
