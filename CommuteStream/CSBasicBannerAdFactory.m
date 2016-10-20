//
//  CSBasicBannerAdFactory.m
//  CommuteStream
//
//  Created by David Rogers on 10/20/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSBasicBannerAdFactory.h"

@implementation CSBasicBannerAdFactory

NSString *bannerUrl;

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary {
    
    float banner_width = [[dictionary objectForKey:@"bannerWidth"] floatValue];
    float banner_height = [[dictionary objectForKey:@"bannerHeight"] floatValue];
    
   
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    //NSLog(@"Web View %f width, %f height", [banner_width floatValue],  [banner_height floatValue]);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, banner_width, banner_height)];
    NSString *htmlString = [dictionary objectForKey:@"html"];
    bannerUrl = [dictionary objectForKey:@"url"];
    [webView loadHTMLString:htmlString baseURL:nil];
    
    UITapGestureRecognizer *webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    webViewTapped.numberOfTapsRequired = 1;
    webViewTapped.delegate = [dictionary objectForKey:@"banner"];
    [webView addGestureRecognizer:webViewTapped];
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    
    return webView;
    
}


- (void)tapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%@", bannerUrl);
    
    NSURL *url = [NSURL URLWithString:bannerUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
