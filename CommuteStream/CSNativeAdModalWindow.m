//
//  CSNativeInterstitial.m
//  CommuteStream
//
//  Created by David Rogers on 2/17/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import "CSNativeAdModalWindow.h"
#import "CSNativeAdModal.h"

@implementation CSNativeAdModalWindow{
    UIView *modalWindowBkg;
    CSNativeAdModal *modalCard;
    UIButton *closeModalWindow;
}



- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      
        
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andStop:(NSDictionary *)stopObject{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        modalWindowBkg = [[UIView alloc] initWithFrame:self.bounds];
        
        [modalWindowBkg setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
        [modalWindowBkg setAlpha:0.0];
        [self addSubview:modalWindowBkg];
        [modalWindowBkg setUserInteractionEnabled:YES];
        
        CGRect modalCardRect = CGRectMake(self.bounds.size.width/2.0, 500.0, self.bounds.size.width - 80.0, 325.0);
        
        modalCard = [[CSNativeAdModal alloc] initWithFrame:modalCardRect andStop:stopObject];
        
        
        UIImage *buttonBkg = [UIImage imageNamed:@"close_interstitial_card.png"];
        CGRect closeInterstitialCardButtonRect = CGRectMake(self.bounds.size.width/2.0,(self.bounds.size.height - 130.0),80.0, 80.0);
        closeModalWindow = [UIButton buttonWithType:UIButtonTypeCustom];
        closeModalWindow.frame = closeInterstitialCardButtonRect;
        CGRect closeModalWindowFrame = [closeModalWindow frame];
        
        closeModalWindowFrame.origin.x = (closeModalWindow.frame.origin.x - closeModalWindow.frame.size.width/2);
        
        [closeModalWindow setFrame:closeModalWindowFrame];
        [closeModalWindow setAlpha:0.0];
        [closeModalWindow setBackgroundImage:buttonBkg forState:UIControlStateNormal];
        [closeModalWindow addTarget:self action:@selector(tapViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeModalWindow];
        [self addSubview:modalCard];
        
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             [closeModalWindow setAlpha:1.0];
                             [modalWindowBkg setAlpha:1.0];
                             [modalCard setAlpha:1.0];
                             [modalCard setFrame:CGRectMake(modalCard.frame.origin.x, 100.0, modalCard.frame.size.width, modalCard.frame.size.height)];
                             
                             
                         }
                         completion:^(BOOL finished){
                             
                             
                         }];
        
        
    }
    return self;
}

-(void) tapViewAction:(UIGestureRecognizer *)sender{
    
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         [closeModalWindow setAlpha:0.0];
                         [modalWindowBkg setAlpha:0.0];
                         [modalCard setAlpha:0.0];
                         [modalCard setFrame:CGRectMake(modalCard.frame.origin.x, 500.0, modalCard.frame.size.width, modalCard.frame.size.height)];
                         
                         
                     }
                     completion:^(BOOL finished){
                         [self setHidden:YES];
                         
                     }];
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
