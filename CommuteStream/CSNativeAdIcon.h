//
//  CSNativeAdIcon.h
//  CommuteStream
//
//  Created by David Rogers on 2/15/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSNativeAdIcon : UIImageView<UIGestureRecognizerDelegate>


@property (strong, nonatomic) UIWindow *interstitial;

-(id) init;
-(void) tapViewAction:(UIGestureRecognizer *)sender;
@property (nonatomic, copy) void (^blockAction)(void);
-  (id)initWithFrame:(CGRect)aRect andTapHandler:(void(^)(void))callback;
- (void) invokeBlock:(id)sender;

@end
