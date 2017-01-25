//
//  CSMoPubCustomEvent.m
//  SDK-MoPub-Test-App-iOS
//
//  Created by David Rogers on 1/20/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import "CSMoPubCustomEvent.h"


@implementation CSMoPubCustomEvent

-(void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info{
    
    
    NSLog(@"CS_SDK: MoPub Requesting CS Ad.");
    
    
    if (![[CommuteStream open] isInitialized]) {
        NSLog(@"CS_SDK: Retrieving Info.");
        
        [[CommuteStream open] setAdUnitUUID: [info objectForKey:@"cs_ad_unit_uuid"]];
        [[CommuteStream open] setIsInitialized:YES];
    }
    
    NSLog(@"CS_SDK: Banner width = %f, Banner height = %f", size.width, size.height);
    //Store Banner Width and height and skip_fetch false
    [[CommuteStream open] setBannerWidth:[NSString stringWithFormat:@"%d", (int) size.width]];
    [[CommuteStream open] setBannerHeight:[NSString stringWithFormat:@"%d", (int) size.height]];
    [[[CommuteStream open] httpParams] setObject:@"false" forKey:@"skip_fetch"];
    
    
    [[CommuteStream open] getAd:self];
    
    
    
}

- (void)didReceiveAdWithView:(UIView *)adView {
    [self.delegate bannerCustomEvent:self didLoadAd:adView];
}

- (void)didFailAdWithError:(NSError *)error {
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

-(void) bannerCustomEvent:(MPBannerCustomEvent *)event didLoadAd:(UIView *)ad {
    [self.delegate bannerCustomEvent:event didLoadAd:ad];
}

-(void)bannerCustomEventWillLeaveApplication:(MPBannerCustomEvent *)event {
    
}

-(void)bannerCustomEventDidFinishAction:(MPBannerCustomEvent *)event{
    
}

- (void)bannerCustomEvent:(MPBannerCustomEvent *)event didFailToLoadAdWithError:(NSError *)error {
    [self.delegate bannerCustomEvent:event didFailToLoadAdWithError:error];
}


@end
