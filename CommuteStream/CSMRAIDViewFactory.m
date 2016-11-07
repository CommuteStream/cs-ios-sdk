//
//  CSMRAIDViewFactory.m
//  CommuteStream
//
//  Created by David Rogers on 10/25/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSMRAIDViewFactory.h"
#import "CSMRAIDView.h"
#import "CSMRAIDServiceDelegate.h"

@interface CSMRAIDViewFactory () <CSMRAIDViewDelegate, CSMRAIDServiceDelegate>



@end


@implementation CSMRAIDViewFactory

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}


- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary {
    
    float banner_width = [[dictionary objectForKey:@"bannerWidth"] floatValue];
    float banner_height = [[dictionary objectForKey:@"bannerHeight"] floatValue];
    
    
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    //NSLog(@"Web View %f width, %f height", [banner_width floatValue],  [banner_height floatValue]);
    //CSMRAIDView *webView = [[CSTestHTMLBanner alloc] initWithFrame:CGRectMake(0.0, 0.0, banner_width, banner_height)];
    //NSString *htmlString = [dictionary objectForKey:@"html"];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString* htmlData = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    CSMRAIDView *webView = [[CSMRAIDView alloc] initWithFrame:CGRectMake(0.0, 0.0, banner_width, banner_height) withHtmlData:htmlData withBaseURL:bundleUrl supportedFeatures:@[MRAIDSupportsSMS, MRAIDSupportsTel, MRAIDSupportsCalendar, MRAIDSupportsStorePicture, MRAIDSupportsInlineVideo] delegate:self serviceDelegate:self rootViewController:[self topViewController:[self topViewController]]];
    //NSString *htmlString = @"<html><body onload='alert(\"test\");'><h1>Hello, world!</h1></body></html>";
    //NSString *htmlString = [dictionary objectForKey:@"html"];
    //bannerUrl = [dictionary objectForKey:@"url"];
    //[webView loadHTML:htmlString];
    
    //[webView setUrl:bannerUrl];
    //webView.scrollView.scrollEnabled = NO;
    //webView.scrollView.bounces = NO;
    
    
    
    return webView;
    
}

@end
