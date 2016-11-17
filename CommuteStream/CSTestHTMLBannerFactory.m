//
//  CSTestHTMLBannerFactory.m
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSTestHTMLBannerFactory.h"
#import "CSTestHTMLBanner.h"

@implementation CSTestHTMLBannerFactory

NSString *bannerUrl;

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary {
    
    
    
    float banner_width = [[dictionary objectForKey:@"bannerWidth"] floatValue];
    float banner_height = [[dictionary objectForKey:@"bannerHeight"] floatValue];
    
    float creative_width = [[dictionary objectForKey:@"creativeWidth"] floatValue];
    float creative_height = [[dictionary objectForKey:@"creativeHeight"] floatValue];
    
    
    
    //wrap this view in a superview that has the dimensions of the ad unit which are designated in the
    //initial request
    
    //I create a webview with the aspect ratio of the creative that best maximized the space of the superview
    //then I use math to center and pad appropriately
    
    //using the four width and height properties I've passed in for both the ad unit and creative returned
    
    
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    NSLog(@"Banner Height = %f", banner_height);
    NSLog(@"Banner Width = %f", banner_width);
    //NSLog(@"Web View %f width, %f height", [banner_width floatValue],  [banner_height floatValue]);
    //CSTestHTMLBanner *webView = [[CSTestHTMLBanner alloc] initWithFrame:CGRectMake(0.0, 0.0, banner_width, banner_height)];
    CSTestHTMLBanner *webView = [[CSTestHTMLBanner alloc] initWithAdUnitFrame:CGRectMake(0.0, 0.0, banner_width, banner_height) andCreativeFrame:CGRectMake(0.0, 0.0, creative_width, creative_height)];
    //NSString *htmlPath = @"<html><body><h1>Hello, world!</h1></body></html>";
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    
    
    //NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test_creative" ofType:@"html"];
    //NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    //NSString* htmlString = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //NSString *htmlString = [dictionary objectForKey:@"html"];
    bannerUrl = [dictionary objectForKey:@"url"];
    //[webView loadHTML:htmlPath];
    [webView loadURLRequest:[NSURLRequest requestWithURL:url]];
    
    [webView setUrl:bannerUrl];
    
    
    
    return webView;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    
    NSLog(@"callllleeeddd it");
    
    return YES;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
