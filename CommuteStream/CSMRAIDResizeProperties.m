//
//  CSMRAIDResizeProperties.m
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSMRAIDResizeProperties.h"

@implementation CSMRAIDResizeProperties

- (id)init
{
    self = [super init];
    if (self) {
        _width = 0;
        _height = 0;
        _offsetX = 0;
        _offsetY = 0;
        _customClosePosition = MRAIDCustomClosePositionTopRight;
        _allowOffscreen = YES;
    }
    return self;
}

+ (CSMRAIDCustomClosePosition)MRAIDCustomClosePositionFromString:(NSString *)s
{
    NSArray *names = @[
                       @"top-left",
                       @"top-center",
                       @"top-right",
                       @"center",
                       @"bottom-left",
                       @"bottom-center",
                       @"bottom-right"
                       ];
    NSUInteger i = [names indexOfObject:s];
    if (i != NSNotFound) {
        return (CSMRAIDCustomClosePosition)i;
    }
    // Use top-right for the default value
    return MRAIDCustomClosePositionTopRight;;
}

@end
