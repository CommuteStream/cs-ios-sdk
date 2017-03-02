//
//  CSTestHTMLBanner.h
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CSNetworkEngine.h"






@interface CSHTMLBanner : UIView<UIGestureRecognizerDelegate, UIWebViewDelegate>

 - (void)setUrl:(NSString *)url;
- (void)removeScrollAndBounce;
 - (void)loadHTML:(NSString *)htmlString;
- (void)loadURLRequest:(NSURLRequest *)request;
- (id)initWithAdUnitFrame:(CGRect)adFrame andCreativeFrame:(CGRect)creativeFrame;
- (void)setClickURL:(NSString *)urlString;

@property (nonatomic, strong) CSNetworkEngine *csNetworkEngine;

@end
