//
//  CSBasicBannerAd.m
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSBasicBannerAd.h"

@implementation CSBasicBannerAd{
    NSString *basicBannerAdUrl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void)setUrl:(NSString *)url{
    basicBannerAdUrl = url;
    
    UITapGestureRecognizer *webViewTappedRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
    webViewTappedRecognizer.numberOfTapsRequired = 1;
    webViewTappedRecognizer.delegate = self;
    NSLog(@"Web View Tapped Delegate: %@", webViewTappedRecognizer.delegate);
    [self addGestureRecognizer:webViewTappedRecognizer];
    
    
    
}




- (void)tapViewAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%@", basicBannerAdUrl);
    
    NSURL *url = [NSURL URLWithString:basicBannerAdUrl];
    [[UIApplication sharedApplication] openURL:url];
    

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
