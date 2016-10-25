//
//  CSTestHTMLBanner.h
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface CSTestHTMLBanner : UIView<UIGestureRecognizerDelegate>

 - (void)setUrl:(NSString *)url;
 - (void)loadHTML:(NSString *)htmlString;

@end