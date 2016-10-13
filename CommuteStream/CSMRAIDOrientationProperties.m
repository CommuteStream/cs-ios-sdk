//
//  CSMRAIDOrientationProperties.m
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSMRAIDOrientationProperties.h"

@implementation CSMRAIDOrientationProperties

- (id)init
{
    self = [super init];
    if (self) {
        _allowOrientationChange = YES;
        _forceOrientation = MRAIDForceOrientationNone;
    }
    return self;
}

+ (CSMRAIDForceOrientation)MRAIDForceOrientationFromString:(NSString *)s
{
    NSArray *names = @[ @"portrait", @"landscape", @"none" ];
    NSUInteger i = [names indexOfObject:s];
    if (i != NSNotFound) {
        return (CSMRAIDForceOrientation)i;
    }
    // Use none for the default value
    return MRAIDForceOrientationNone;
}

@end
