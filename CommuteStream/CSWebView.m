//
//  CSWebView.m
//  CommuteStream
//
//  Created by David Rogers on 10/27/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSWebView.h"

@implementation CSWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //[self setUserInteractionEnabled:NO];
        [self becomeFirstResponder];
        
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"has interacted");
    
    
}

@end
