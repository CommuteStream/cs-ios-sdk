//
//  CSNativeInterstitial.m
//  CommuteStream
//
//  Created by David Rogers on 2/17/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import "CSNativeInterstitial.h"

@implementation CSNativeInterstitial


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"initialized");
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
        
        tapRecognizer.delegate = self;
        
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [backgroundView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]];
        [self addSubview:backgroundView];
        [backgroundView addGestureRecognizer:tapRecognizer];
        [backgroundView setUserInteractionEnabled:YES];

        
    }
    return self;
}

-(void) tapViewAction:(UIGestureRecognizer *)sender{
    
    [self setHidden:YES];
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
