//
//  CSMRAIDModalViewController.h
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSMRAIDModalViewController;
@class CSMRAIDOrientationProperties;

@protocol CSMRAIDModalViewControllerDelegate <NSObject>

- (void)mraidModalViewControllerDidRotate:(CSMRAIDModalViewController *)modalViewController;

@end

@interface CSMRAIDModalViewController : UIViewController

@property (nonatomic, unsafe_unretained) id<CSMRAIDModalViewControllerDelegate> delegate;

- (id)initWithOrientationProperties:(CSMRAIDOrientationProperties *)orientationProperties;
- (void)forceToOrientation:(CSMRAIDOrientationProperties *)orientationProperties;

@end
