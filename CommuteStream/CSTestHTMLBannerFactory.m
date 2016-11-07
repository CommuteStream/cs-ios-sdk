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
    
    
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    //NSLog(@"Web View %f width, %f height", [banner_width floatValue],  [banner_height floatValue]);
    CSTestHTMLBanner *webView = [[CSTestHTMLBanner alloc] initWithFrame:CGRectMake(0.0, 0.0, banner_width, banner_height)];
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
