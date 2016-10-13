//
//  CSMRAIDView.h
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSMRAIDView;
@protocol CSMRAIDServiceDelegate;

// A delegate for MRAIDView to listen for notification on ad ready or expand related events.
@protocol CSMRAIDViewDelegate <NSObject>

@optional

// These callbacks are for basic banner ad functionality.
- (void)mraidViewAdReady:(CSMRAIDView *)mraidView;
- (void)mraidViewAdFailed:(CSMRAIDView *)mraidView;
- (void)mraidViewWillExpand:(CSMRAIDView *)mraidView;
- (void)mraidViewDidClose:(CSMRAIDView *)mraidView;
- (void)mraidViewNavigate:(CSMRAIDView *)mraidView withURL:(NSURL *)url;

// This callback is to ask permission to resize an ad.
- (BOOL)mraidViewShouldResize:(CSMRAIDView *)mraidView toPosition:(CGRect)position allowOffscreen:(BOOL)allowOffscreen;

@end

@interface CSMRAIDView : UIView

@property (nonatomic, weak) id<CSMRAIDViewDelegate> delegate;
@property (nonatomic, weak) id<CSMRAIDServiceDelegate> serviceDelegate;
@property (nonatomic, weak, setter = setRootViewController:) UIViewController *rootViewController;
@property (nonatomic, assign, getter = isViewable, setter = setIsViewable:) BOOL isViewable;

// IMPORTANT: This is the only valid initializer for an MRAIDView; -init and -initWithFrame: will throw exceptions
- (id)initWithFrame:(CGRect)frame
       withHtmlData:(NSString*)htmlData
        withBaseURL:(NSURL*)bsURL
  supportedFeatures:(NSArray *)features
           delegate:(id<CSMRAIDViewDelegate>)delegate
    serviceDelegate:(id<CSMRAIDServiceDelegate>)serviceDelegate
 rootViewController:(UIViewController *)rootViewController;

- (void)cancel;

@end
