//
//  CSMRAIDOrientationProperties.h
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MRAIDForceOrientationPortrait,
    MRAIDForceOrientationLandscape,
    MRAIDForceOrientationNone
} CSMRAIDForceOrientation;

@interface CSMRAIDOrientationProperties : NSObject

@property (nonatomic, assign) BOOL allowOrientationChange;
@property (nonatomic, assign) CSMRAIDForceOrientation forceOrientation;

+ (CSMRAIDForceOrientation)MRAIDForceOrientationFromString:(NSString *)s;

@end
