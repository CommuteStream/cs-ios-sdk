#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CSClient.h"

extern NSString * const gotFilePathNotification;

@protocol CSAdViewFactory
- (UIView *) buildAdViewFromBannerResponse:(CSBannerResponse *)bannerRespones;
@end


@interface CSAdFactory : NSObject {
    
}

+ (id<CSAdViewFactory>) factoryWithAdType:(NSString *)adType;

- (id<CSAdViewFactory>)adViewFromBannerResponse:(CSBannerResponse*)bannerResponse;

@end
