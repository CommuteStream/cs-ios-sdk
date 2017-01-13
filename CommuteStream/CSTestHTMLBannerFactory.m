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
    
    NSString *htmlBody = [dictionary objectForKey:@"htmlbody"];

    
    
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    CSTestHTMLBanner *webView = [[CSTestHTMLBanner alloc] initWithAdUnitFrame:CGRectMake(0.0, 0.0, banner_width, banner_height) andCreativeFrame:CGRectMake(0.0, 0.0, creative_width, creative_height)];
    
    NSString *htmlPath = htmlBody;
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pan-gesture-banner" ofType:@"html"]];
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    
    bannerUrl = [dictionary objectForKey:@"url"];
    [webView loadHTML:htmlPath];
    //[webView loadURLRequest:[NSURLRequest requestWithURL:url]];
    
    //[webView setUrl:bannerUrl];
    
    
    
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
