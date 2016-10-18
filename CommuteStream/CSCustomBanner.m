#import "CSCustomBanner.h"
#import "CSNetworkEngine.h"
#import "CommuteStream.h"
#import <AdSupport/ASIdentifierManager.h>



@implementation CSCustomBanner

// Will be set by the AdMob SDK.
@synthesize delegate, csNetworkEngine;

- (void)dealloc {
    bannerView_.delegate = nil;
}

#pragma mark -
#pragma mark GADCustomEventBanner




GADBannerView *testView;
UIWebView *webView;

CGSize myAdSize;
NSString *bannerUrl;
NSString *appHostUrl = @"api.commutestream.com";
int portNumber = 3000;


- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)customEventRequest  {

    
    NSLog(@"CS_SDK: AdMob requesting ad.");
    
    
    if (![[CommuteStream open] isInitialized]) {
        NSLog(@"CS_SDK: Retrieving Info.");
        [[CommuteStream open] setAdUnitUUID:serverParameter];
        
        [[CommuteStream open] setIsInitialized:YES];
    }
    
    //get banner width and height
    myAdSize = CGSizeFromGADAdSize(adSize);
    NSLog(@"Banner %f width, %f height", adSize.size.width, adSize.size.height);
    
    //Store Banner Width and height and skip_fetch false
    [[CommuteStream open] setBannerWidth:[NSString stringWithFormat:@"%d", (int) myAdSize.width]];
    [[CommuteStream open] setBannerHeight:[NSString stringWithFormat:@"%d", (int) myAdSize.height]];
    [[[CommuteStream open] httpParams] setObject:@"false" forKey:@"skip_fetch"];
    
   
    
    
    csNetworkEngine = [[CSNetworkEngine alloc] initWithHostName:appHostUrl];
    [csNetworkEngine setPortNumber: portNumber];
    
    __weak MKNetworkOperation *request = [csNetworkEngine getBanner:[[CommuteStream open] httpParams]];
    
    
    
    [request setCompletionBlock:^{
        
        [[CommuteStream open] reportSuccessfulGet];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)request.responseJSON];
        
        if ([[dict objectForKey:@"item_returned"]boolValue] == YES) {
            [self performSelectorOnMainThread:@selector(buildWebView:) withObject:dict waitUntilDone:NO];
        }else{
            NSLog(@"CS_SDK: Ad request unfulfilled, deferring to AdMob");
            [self.delegate customEventBanner:self didFailAd:request.error];
        }
    }];
}

-(void)buildWebView:(NSMutableDictionary*)dict {
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    NSLog(@"Web View %f width, %f height", myAdSize.width, myAdSize.height);
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, myAdSize.width, myAdSize.height)];
    NSString *htmlString = [dict objectForKey:@"html"];
    bannerUrl = [dict objectForKey:@"url"];
    
    [webView loadHTMLString:htmlString baseURL:nil];
    
    [self.delegate customEventBanner:self didReceiveAd:webView];
    
    UITapGestureRecognizer *webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    webViewTapped.numberOfTapsRequired = 1;
    webViewTapped.delegate = self;
    [webView addGestureRecognizer:webViewTapped];
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    //NSLog(@"%@", bannerUrl);
    
    NSURL *url = [NSURL URLWithString:bannerUrl];
    [[UIApplication sharedApplication] openURL:url];
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
