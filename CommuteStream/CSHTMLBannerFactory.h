//
//  CSTestHTMLBannerFactory.h
//  CommuteStream
//
//  Created by David Rogers on 10/24/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSAdFactory.h"

@interface CSHTMLBannerFactory : CSAdFactory<UIWebViewDelegate> {
    
}

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary;

@end
