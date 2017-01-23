#import <Foundation/Foundation.h>
#import "GADCustomEventBanner.h"
#import "GADCustomEventBannerDelegate.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "CSNetworkEngine.h"
#import "CSCustomEventDelegate.h"

@interface CSCustomBanner : NSObject <GADCustomEventBanner, GADBannerViewDelegate, UIGestureRecognizerDelegate, CSCustomEventDelegate> {
    GADBannerView *bannerView_;
}

@property (nonatomic, strong) CSNetworkEngine *csNetworkEngine;

@end
