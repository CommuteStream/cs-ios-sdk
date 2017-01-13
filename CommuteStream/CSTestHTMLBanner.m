//
//  CSTestHTMLBanner.m
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSTestHTMLBanner.h"
#import "CSWebView.h"
#import "CSGestureRecognizer.h"




@implementation CSTestHTMLBanner{
    NSString *bannerUrl;
    CSWebView *webView;
    BOOL userInteracted;
    
}



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
        //[webView setUserInteractionEnabled:NO];
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
        
        [webView stringByEvaluatingJavaScriptFromString:@"window.open = function (open) { return function  (url, name, features) { window.location.href = url; return window; }; } (window.open);"];


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
    
    //[[[self configuration] preferences] setJavaScriptEnabled:YES];
    
    
    
    
    
}

- (void)removeScrollAndBounce {
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
}


- (void)tapViewAction:(UITapGestureRecognizer *)sender
{
    //NSLog(@"%@", bannerUrl);
    userInteracted = YES;
    //NSURL *url = [NSURL URLWithString:bannerUrl];
    //[[UIApplication sharedApplication] openURL:url];
    NSLog(@"Web View Tapped");
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //NSLog(@"009909009090");
    //[webView setUserInteractionEnabled:YES];
    //bannerClicked = YES;
    
//}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    
    //NSURL *URL = [request URL];

    if (userInteracted) {
        
        switch (navigationType) {
            case UIWebViewNavigationTypeLinkClicked:
                NSLog(@"UIWebViewNavigationTypeLinkClicked");
                break;
                
            case UIWebViewNavigationTypeFormSubmitted:
                NSLog(@"UIWebViewNavigationTypeFormSubmitted");
                break;
                
            case UIWebViewNavigationTypeBackForward:
                NSLog(@"UIWebViewNavigationTypeBackForward");
                break;
                
            case UIWebViewNavigationTypeReload:
                NSLog(@"UIWebViewNavigationTypeReload");
                break;
                
            case UIWebViewNavigationTypeFormResubmitted:
                NSLog(@"UIWebViewNavigationTypeFormResubmitted");
                break;
                
            case UIWebViewNavigationTypeOther:
                NSLog(@"UIWebViewNavigationTypeOther");
                break;
                
            default:
                NSLog(@"Unknown");
                break;
        }
    
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
