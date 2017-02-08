//
//  CSGestureRecognizer.m
//  CommuteStream
//
//  Created by David Rogers on 11/7/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CSGestureRecognizer

// Currently, we treat any touch as evidence of user interaction
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}


@end
