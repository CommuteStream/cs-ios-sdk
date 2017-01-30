//
//  CSTestHTMLBannerFactory.m
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSHTMLBannerFactory.h"
#import "CSHTMLBanner.h"

@implementation CSHTMLBannerFactory

//NSString *htmlBannerUrl;

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary {
    
    
    
    float banner_width = [[dictionary objectForKey:@"bannerWidth"] floatValue];
    float banner_height = [[dictionary objectForKey:@"bannerHeight"] floatValue];
    
    float creative_width = [[dictionary objectForKey:@"creativeWidth"] floatValue];
    float creative_height = [[dictionary objectForKey:@"creativeHeight"] floatValue];
    
    NSString *htmlBody = [dictionary objectForKey:@"htmlbody"];
    NSString *requestID = [dictionary objectForKey:@"request_id"];

    
    
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    CSHTMLBanner *webView = [[CSHTMLBanner alloc] initWithAdUnitFrame:CGRectMake(0.0, 0.0, banner_width, banner_height) andCreativeFrame:CGRectMake(0.0, 0.0, creative_width, creative_height)];
    
    
    
    NSString *htmlPath = htmlBody;
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pan-gesture-banner" ofType:@"html"]];
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    [webView setRequestID:requestID];
    //htmlBannerUrl = [dictionary objectForKey:@"url"];
    [webView loadHTML:htmlPath];

    //[webView loadURLRequest:[NSURLRequest requestWithURL:url]];
    
    //[webView setUrl:bannerUrl];
    
    
    
    return webView;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    return YES;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
