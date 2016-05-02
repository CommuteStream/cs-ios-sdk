#import <Foundation/Foundation.h>
#import "GADCustomEventBanner.h"
#import "GADCustomEventBannerDelegate.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "CSNetworkEngine.h"

@interface CSCustomBanner : NSObject <GADCustomEventBanner, GADBannerViewDelegate, UIGestureRecognizerDelegate> {
    GADBannerView *bannerView_;
}

@property (nonatomic, strong) CSNetworkEngine *csNetworkEngine;
-(void)buildWebView:(NSMutableDictionary*)dict;
+ (NSString *)getIdfa;
+ (NSString *)getMacSha:(NSString *)deviceAddress;
@end