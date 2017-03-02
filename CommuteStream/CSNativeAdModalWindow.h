//
//  CSNativeInterstitial.h
//  CommuteStream
//
//  Created by David Rogers on 2/17/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSNativeAdModalWindow : UIWindow<UIGestureRecognizerDelegate>


- (id) initWithFrame:(CGRect)frame andStop:(NSDictionary *)stopObject;

@end
