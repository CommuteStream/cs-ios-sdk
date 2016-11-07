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
    BOOL bannerClicked;
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        webView = [[CSWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        //[webView setUserInteractionEnabled:NO];
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.bounces = NO;
        [self addSubview:webView];
        webView.delegate = self;
        
        bannerClicked = NO;
        
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
    
    
    CSGestureRecognizer *webViewTappedRecognizer = [[CSGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
    //webViewTappedRecognizer.numberOfTapsRequired = 1;
    //webViewTappedRecognizer.numberOfTouchesRequired = 1;
    webViewTappedRecognizer.delegate = self;
    NSLog(@"Web View Tapped Delegate: %@", webViewTappedRecognizer.delegate);
    [webView addGestureRecognizer:webViewTappedRecognizer];
    
    
    
}

- (void)removeScrollAndBounce {
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
}


- (void)tapViewAction:(UITapGestureRecognizer *)sender
{
    //NSLog(@"%@", bannerUrl);
    NSLog(@"------------> tap recognizer called");
    bannerClicked = YES;
    //NSURL *url = [NSURL URLWithString:bannerUrl];
    //[[UIApplication sharedApplication] openURL:url];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //NSLog(@"009909009090");
    //[webView setUserInteractionEnabled:YES];
    //bannerClicked = YES;
    
//}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //NSLog(@"registereeeeeeeeder - %@", request);
    
    NSLog(@"------------> webview navigating 1");
    
    if (bannerClicked) {
        NSLog(@"------------> webview navigating 2");
        NSLog(@"------------> request URL - %@", [request URL]);
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
