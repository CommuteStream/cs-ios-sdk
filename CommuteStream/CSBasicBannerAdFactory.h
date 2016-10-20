//
//  CSBasicBannerAdFactory.h
//  CommuteStream
//
//  Created by David Rogers on 10/20/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSAdFactory.h"

@interface CSBasicBannerAdFactory : CSAdFactory<UIGestureRecognizerDelegate> {
    
}

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary;

@end
