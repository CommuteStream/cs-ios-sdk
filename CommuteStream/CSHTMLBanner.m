//
//  CSTestHTMLBanner.m
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSHTMLBanner.h"
#import "CSWebView.h"
#import "CSGestureRecognizer.h"
#import "NSURL+CSURL.h"
#import "CommuteStream.h"



@implementation CSHTMLBanner{
    NSString *bannerUrl;
    NSString *requestID;
    int touchCount;
    CSWebView *webView;
    BOOL userInteracted;
    
    
    
}

@synthesize csNetworkEngine;

NSString *hostUrl = @"api.commutestream.com";


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    
    }
    return self;
}

- (id)initWithAdUnitFrame:(CGRect)adFrame andCreativeFrame:(CGRect)creativeFrame {
    if ((self = [super initWithFrame:CGRectMake(adFrame.origin.x, adFrame.origin.y, adFrame.size.width, adFrame.size.height)])) {
        webView = [[CSWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, creativeFrame.size.width, creativeFrame.size.height)];
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.bounces = NO;
        [self addSubview:webView];
        webView.delegate = self;
        
        webView.scrollView.zoomScale = 1.3;
        
        [webView setScalesPageToFit:YES];
        [self setBackgroundColor:[UIColor blackColor]];
        userInteracted = NO;
        
        
        
        double creativeHeight = round(floorf(creativeFrame.size.height * 100 + 0.5) / 100);
        double adFrameHeight = round(floorf(adFrame.size.height * 100 + 0.5) / 100);
        
        double creativeWidth = round(floorf(creativeFrame.size.width* 100 + 0.5) / 100);
        double adFrameWidth = round(floorf(adFrame.size.width * 100 + 0.5) / 100);
        
        double multiplier = adFrameHeight/creativeHeight;
      
        float xOffset = (adFrameWidth - (creativeWidth * multiplier))/2;
        [webView setFrame:CGRectMake(xOffset, 0.0, (creativeWidth * multiplier), (creativeHeight * multiplier))];
        
        CSGestureRecognizer *webViewTouchRecognizer = [[CSGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
        
        webViewTouchRecognizer.delegate = self;
        [webView addGestureRecognizer:webViewTouchRecognizer];
        
        csNetworkEngine = [[CSNetworkEngine alloc] initWithHostName:hostUrl];
        
        touchCount = 0;


    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadHTML:(NSString *)htmlString {
    [webView loadHTMLString:htmlString baseURL:nil];
}

- (void)loadURLRequest:(NSURLRequest *)request {
    [webView loadRequest:request];
}


- (void)setUrl:(NSString *)url{
    bannerUrl = url;
    
}

- (void)setRequestID:(NSString *)requestString {
    requestID = requestString;
}

- (void)removeScrollAndBounce {
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
}


- (void)tapViewAction:(UITapGestureRecognizer *)sender {
    userInteracted = YES;
    
    touchCount++;
    
    //api call
    if(touchCount == 1){
        
        NSMutableDictionary *retryDict = [NSMutableDictionary dictionaryWithDictionary:@{@"delay" : @5.0, @"count" : @7, @"requestID" : requestID}];
       
        [[CommuteStream open] callRegisterClickWithTimerParams:retryDict];
        
        
    }
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    
    NSURL *URL = [request URL];
    if ([self shouldIntercept:URL forNavigationType:navigationType]) {
        [self interceptURL:URL];
        return NO;
    } else {
        // don't handle any deep links without user interaction
        return userInteracted || [URL isSafeForLoadingWithoutUserAction];
    }
}


- (BOOL)shouldIntercept:(NSURL *)URL forNavigationType:(UIWebViewNavigationType)navigationType {
    if ([URL hasTelephoneScheme] || [URL hasTelephonePromptScheme]) {
        return YES;
    }else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return YES;
    } else if (navigationType == UIWebViewNavigationTypeOther) {
        return [[URL absoluteString] hasPrefix:@""] || [[URL absoluteString] hasPrefix:@"http://commutestream.com"];
    } else {
        return NO;
    }

}

- (void)interceptURL:(NSURL *)URL {
    [[UIApplication sharedApplication] openURL:URL];
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
