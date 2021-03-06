//
//  CSAdFactory.m
//  CommuteStream
//
//  Created by David Rogers on 10/20/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSAdFactory.h"
#import "CSBasicBannerAdFactory.h"
#import "CSHTMLBannerFactory.h"

NSString * const BASIC_BANNER_AD = @"basic_banner_ad";
NSString * const HTML_BANNER = @"html";

@implementation CSAdFactory

+ (CSAdFactory *) factoryWithAdType:(NSString *)adType {
    
    if([adType isEqualToString:BASIC_BANNER_AD]){
        return [[CSBasicBannerAdFactory alloc] init];
    }else if([adType isEqualToString:HTML_BANNER]){
        return [[CSHTMLBannerFactory alloc] init];
    }else{
        return [[CSHTMLBannerFactory alloc] init];
    }

}

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary {
    return nil;
}

@end
