//
//  CSAdFactory.h
//  CommuteStream
//
//  Created by David Rogers on 10/20/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern NSString * const gotFilePathNotification;

@interface CSAdFactory : NSObject {
    
}

+ (CSAdFactory *) factoryWithAdType:(NSString *)adType;

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary;

@end
