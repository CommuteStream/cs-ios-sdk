//
//  CSCustomBanner.h
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADCustomEventBanner.h"
#import "GADCustomEventBannerDelegate.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface CSCustomBanner : NSObject <GADCustomEventBanner, GADBannerViewDelegate, UIGestureRecognizerDelegate> {
    GADBannerView *bannerView_;
}
-(void)buildWebView:(NSMutableDictionary*)dict;
+ (NSString *)getSha;
+ (NSString *)getMacSha:(NSString *)deviceAddress;
//static char* getMacAddress(char* macAddress, char* ifName);
@end