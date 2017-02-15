#import "CSCustomBanner.h"
#import "CommuteStream.h"
#import <AdSupport/ASIdentifierManager.h>



@implementation CSCustomBanner

// Will be set by the AdMob SDK.
@synthesize delegate;

- (void)dealloc {
    bannerView_.delegate = nil;
}

#pragma mark -
#pragma mark GADCustomEventBanner

CGSize myAdSize;


- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)customEventRequest  {

    
    NSLog(@"CS_SDK: AdMob requesting CommuteStream Ad.");
    
    
    if (![[CommuteStream open] isInitialized]) {
        NSLog(@"CS_SDK: Retrieving Ad Unit ID.");
        [[CommuteStream open] setAdUnitUUID:serverParameter];
        
        [[CommuteStream open] setIsInitialized:YES];
    }
    
    //get banner width and height
    myAdSize = CGSizeFromGADAdSize(adSize);
    NSLog(@"CS_SDK: Banner width = %f, Banner height = %f", adSize.size.width, adSize.size.height);
    //Store Banner Width and height and skip_fetch false
    [[CommuteStream open] setBannerWidth:[NSString stringWithFormat:@"%d", (int) myAdSize.width]];
    [[CommuteStream open] setBannerHeight:[NSString stringWithFormat:@"%d", (int) myAdSize.height]];    
    [[CommuteStream open] getAd:self];

}


- (void)didReceiveAdWithView:(UIView *)adView {
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)didFailAdWithError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}


#pragma mark -
#pragma mark GADBannerView Callbacks

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [self.delegate customEventBanner:self didReceiveAd:adView];
    
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
    
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    [self.delegate customEventBanner:self clickDidOccurInAd:adView];
    //[self.delegate customEventBannerWillPresentModal:self];
    
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    [self.delegate customEventBannerWillDismissModal:self];
    
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    [self.delegate customEventBannerDidDismissModal:self];
    
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    [self.delegate customEventBannerWillLeaveApplication:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
