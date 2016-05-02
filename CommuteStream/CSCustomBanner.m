//
//  CSCustomBanner.m
//  CommuteStream
//
//  Created by David Rogers on 5/3/14.
//  Copyright (c) 2014 CommuteStream. All rights reserved.
//


#import "CSCustomBanner.h"
#import "CSNetworkEngine.h"
#import "CommuteStream.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#import <AdSupport/ASIdentifierManager.h>

#define SDK_VERSION @"0.2.3"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define IFT_ETHER 0x6
#pragma mark -



static char* getMacAddress(char* macAddress, char* ifName) {
    
    int  success;
    struct ifaddrs * addrs;
    struct ifaddrs * cursor;
    const struct sockaddr_dl * dlAddr;
    const unsigned char* base;
    int i;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != 0) {
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp(ifName,  cursor->ifa_name)==0 ) {
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                strcpy(macAddress, "");
                for (i = 0; i < dlAddr->sdl_alen; i++) {
                    if (i != 0) {
                        strcat(macAddress, ":");
                    }
                    char partialAddr[3];
                    sprintf(partialAddr, "%02X", base[i]);
                    strcat(macAddress, partialAddr);
                    
                }
            }
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    return macAddress;
}

@implementation CSCustomBanner

// Will be set by the AdMob SDK.
@synthesize delegate, csNetworkEngine;

- (void)dealloc {
    bannerView_.delegate = nil;
}

#pragma mark -
#pragma mark GADCustomEventBanner

char macAddress[32];
char ifName[3] = "en0";


GADBannerView *testView;
UIWebView *webView;
NSString *appVersion;
NSString *appName;
CGSize myAdSize;
NSString *bannerUrl;


- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)customEventRequest  {

    
    NSLog(@"CS_SDK: AdMob requesting ad.");
    
    
    if (![[CommuteStream open] isInitialized]) {
        NSLog(@"CS_SDK: Retrieving Info.");
        
        appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        appName = [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleName"];
        
        [[CommuteStream open] setAdUnitUUID:serverParameter];
        [[CommuteStream open] setAppVer:appVersion];
        [[CommuteStream open] setSdkVer:SDK_VERSION];
        [[CommuteStream open] setSdkName:@"com.commutestreamsdk"];
        [[CommuteStream open] setAppName:appName];
        
        
        
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            
            [CSCustomBanner getIdfa];
        }else{
            NSString *deviceMacAddress = [[NSString alloc] initWithUTF8String:getMacAddress(macAddress, ifName)];
            [CSCustomBanner getMacSha:deviceMacAddress];
            
        }
        
        [[CommuteStream open] setIsInitialized:YES];
    }
    
    //get banner width and height
    myAdSize = CGSizeFromGADAdSize(adSize);
    NSLog(@"Banner %f width, %f height", adSize.size.width, adSize.size.height);
    
    //Store Banner Width and height and skip_fetch false
    [[CommuteStream open] setBannerWidth:[NSString stringWithFormat:@"%d", (int) myAdSize.width]];
    [[CommuteStream open] setBannerHeight:[NSString stringWithFormat:@"%d", (int) myAdSize.height]];
    [[[CommuteStream open] httpParams] setObject:@"false" forKey:@"skip_fetch"];
    
    if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        
        NSLog(@"Advertising tracking disabled.");
        [[CommuteStream open] setIOSLimitAdTracking:@"true"];
    }else {
        NSLog(@"Advertising tracking enabled.");
    }
    
    NSString *appHostUrl = @"api.commutestream.com";
    csNetworkEngine = [[CSNetworkEngine alloc] initWithHostName:appHostUrl];
    int portNumber = 3000;
    [csNetworkEngine setPortNumber: portNumber];
    
    
    __weak MKNetworkOperation *request = [csNetworkEngine getBanner:[[CommuteStream open] httpParams]];
    
    
    
    [request setCompletionBlock:^{
        
        [[CommuteStream open] reportSuccessfulGet];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)request.responseJSON];
        
        if ([[dict objectForKey:@"item_returned"]boolValue] == YES) {
            [self performSelectorOnMainThread:@selector(buildWebView:) withObject:dict waitUntilDone:NO];
        }else{
            NSLog(@"CS_SDK: Ad request unfulfilled, deferring to AdMob");
            [self.delegate customEventBanner:self didFailAd:request.error];
        }
    }];
}

-(void)buildWebView:(NSMutableDictionary*)dict {
    NSLog(@"CS_SDK: Generating UIWebView for ad display.");
    NSLog(@"Web View %f width, %f height", myAdSize.width, myAdSize.height);
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, myAdSize.width, myAdSize.height)];
    NSString *htmlString = [dict objectForKey:@"html"];
    bannerUrl = [dict objectForKey:@"url"];
    
    [webView loadHTMLString:htmlString baseURL:nil];
    
    [self.delegate customEventBanner:self didReceiveAd:webView];
    
    UITapGestureRecognizer *webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    webViewTapped.numberOfTapsRequired = 1;
    webViewTapped.delegate = self;
    [webView addGestureRecognizer:webViewTapped];
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    //NSLog(@"%@", bannerUrl);
    
    NSURL *url = [NSURL URLWithString:bannerUrl];
    [[UIApplication sharedApplication] openURL:url];
}


+ (NSString *)getIdfa {
#ifndef PRE_6
    Class asIDManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (asIDManagerClass) {
        NSString *adId = nil;
        
        SEL sharedManagerSel = NSSelectorFromString(@"sharedManager");
        if ([asIDManagerClass respondsToSelector:sharedManagerSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id adManager = [asIDManagerClass performSelector:sharedManagerSel];
            if (adManager) {
                SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
                
                if ([adManager respondsToSelector:advertisingIdentifierSelector]) {
                    
                    id uuid = [adManager performSelector:advertisingIdentifierSelector];
                    
                    if (!uuid) {
                        return nil;
                    }
                    
                    SEL uuidStringSelector = NSSelectorFromString(@"UUIDString");
                    if ([uuid respondsToSelector:uuidStringSelector]) {
                        adId = [uuid performSelector:uuidStringSelector];
#pragma clang diagnostic pop
                    }
                }
            }
        }
        
        if (!adId) {
            return nil;
        }
        
        //SHA1
        NSData *sha1_data = [adId dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(sha1_data.bytes, (CC_LONG)sha1_data.length, digest);
        NSMutableString* sha1 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
            [sha1 appendFormat:@"%02x", digest[i]];
        NSString *adIdSha = [NSString stringWithFormat:@"%@",sha1];
        
        [[CommuteStream open] setIdfaSha:adIdSha];
        [[CommuteStream open] setIdfa:adId];
        
        return adId;
    }
#endif
    
    return nil;
}

+ (NSString *) getMacSha:(NSString *) deviceAddress {
    
    //SHA1
    NSData *sha1_data = [deviceAddress dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(sha1_data.bytes, (CC_LONG)sha1_data.length, digest);
    NSMutableString* sha1 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [sha1 appendFormat:@"%02x", digest[i]];
    
    deviceAddress = [NSString stringWithFormat:@"%@",sha1];
    
    [[CommuteStream open] setMacAddrSha:deviceAddress];
    
    return deviceAddress;
}



#pragma mark -
#pragma mark GADBannerView Callbacks

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [self.delegate customEventBanner:self didReceiveAd:adView];
    
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
    
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    [self.delegate customEventBanner:self clickDidOccurInAd:adView];
    //[self.delegate customEventBannerWillPresentModal:self];
    
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    [self.delegate customEventBannerWillDismissModal:self];
    
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    [self.delegate customEventBannerDidDismissModal:self];
    
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    [self.delegate customEventBannerWillLeaveApplication:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
