//
//  CSNetworkEngine.m
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import "CSNetworkEngine.h"


@implementation CSNetworkEngine

-(CSNetworkEngine *) initWithHostName:(NSString *)hostName {
    self.hostName = hostName;
    return self;
}

-(void) getBanner:(NSMutableDictionary *)callParams withSuccess:(CSNetworkSuccess)success withFailure:(CSNetworkFailure)failure {
    
}



@end
