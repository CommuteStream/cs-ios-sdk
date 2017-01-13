//
//  CSAdFactory.m
//  CommuteStream
//
//  Created by David Rogers on 10/20/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSAdFactory.h"
#import "CSBasicBannerAdFactory.h"
#import "CSTestHTMLBannerFactory.h"
#import "CSMRAIDViewFactory.h"

NSString * const BASIC_BANNER_AD = @"basic_banner_ad";
NSString * const HTML_BANNER = @"html";
NSString * const MRAID_BANNER = @"mraid_banner";

@implementation CSAdFactory

+ (CSAdFactory *) factoryWithAdType:(NSString *)adType {
    
    if([adType isEqualToString:BASIC_BANNER_AD]){
        return [[CSBasicBannerAdFactory alloc] init];
    }else if([adType isEqualToString:HTML_BANNER]){
        return [[CSTestHTMLBannerFactory alloc] init];
    }else if([adType isEqualToString:MRAID_BANNER]){
        return [[CSMRAIDViewFactory alloc] init];
    }else{
        return nil;
    }

}

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary {
    return nil;
}

@end
