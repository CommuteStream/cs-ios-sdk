//
//  CSNativeAdIcon.m
//  CommuteStream
//
//  Created by David Rogers on 2/15/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import "CSNativeAdIcon.h"
#import "CommuteStream.h"

@implementation CSNativeAdIcon

@synthesize blockAction;

-(id)init
{
    self = [super init];
    if(self){
        
        
        
    }
    return self;
}

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        
        
    }
    
    return self;
}



-  (id)initWithFrame:(CGRect)aRect andTapHandler:(void(^)(void))callback
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
        
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
        [self setUserInteractionEnabled:YES];
        
        [self setBlockAction:callback];
        
    }
    
    return self;
}


- (void) invokeBlock:(id)sender {
    [self blockAction]();
}

-(void) tapViewAction:(UIGestureRecognizer *)sender{
    //id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
    //NSLog(@"rootVC = %@", rootVC);

    [self invokeBlock:sender];
    //UIView *view = [[UIView alloc] initWithFrame:bounds];
    //[view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
    //[[rootVC view] addSubview:view];
    
    
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
