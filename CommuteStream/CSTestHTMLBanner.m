//
//  CSTestHTMLBanner.m
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSTestHTMLBanner.h"

@implementation CSTestHTMLBanner{
    NSString *bannerUrl;
    WKWebView *webView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        [self addSubview:webView];
        
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


- (void)setUrl:(NSString *)url{
    bannerUrl = url;
    
    //[[[self configuration] preferences] setJavaScriptEnabled:YES];
    
    
    UITapGestureRecognizer *webViewTappedRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
    webViewTappedRecognizer.numberOfTapsRequired = 1;
    webViewTappedRecognizer.delegate = self;
    NSLog(@"Web View Tapped Delegate: %@", webViewTappedRecognizer.delegate);
    [webView addGestureRecognizer:webViewTappedRecognizer];
    
    
}

- (void)tapViewAction:(UITapGestureRecognizer *)sender
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
