//
//  CSBasicBannerAdFactory.m
//  CommuteStream
//
//  Created by David Rogers on 10/20/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSBasicBannerAdFactory.h"
#import "CSBasicBannerAd.h"

@implementation CSBasicBannerAdFactory

NSString *basicBannerUrl;

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary {
    
    float banner_width = [[dictionary objectForKey:@"bannerWidth"] floatValue];
    float banner_height = [[dictionary objectForKey:@"bannerHeight"] floatValue];
    
   
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    //NSLog(@"Web View %f width, %f height", [banner_width floatValue],  [banner_height floatValue]);
    CSBasicBannerAd *webView = [[CSBasicBannerAd alloc] initWithFrame:CGRectMake(0.0, 0.0, banner_width, banner_height)];
    NSString *htmlString = [dictionary objectForKey:@"html"];
    basicBannerUrl = [dictionary objectForKey:@"url"];
    [webView loadHTMLString:htmlString baseURL:nil];
    [webView setUrl:basicBannerUrl];
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    
    
    
    return webView;
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
