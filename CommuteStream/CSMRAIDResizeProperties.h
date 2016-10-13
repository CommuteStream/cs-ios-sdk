//
//  CSMRAIDResizeProperties.h
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MRAIDCustomClosePositionTopLeft,
    MRAIDCustomClosePositionTopCenter,
    MRAIDCustomClosePositionTopRight,
    MRAIDCustomClosePositionCenter,
    MRAIDCustomClosePositionBottomLeft,
    MRAIDCustomClosePositionBottomCenter,
    MRAIDCustomClosePositionBottomRight
} CSMRAIDCustomClosePosition;

@interface CSMRAIDResizeProperties : NSObject

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int offsetX;
@property (nonatomic, assign) int offsetY;
@property (nonatomic, assign) CSMRAIDCustomClosePosition customClosePosition;
@property (nonatomic, assign) BOOL allowOffscreen;

+ (CSMRAIDCustomClosePosition)MRAIDCustomClosePositionFromString:(NSString *)s;

@end
