//
//  CSMRAIDViewFactory.h
//  CommuteStream
//
//  Created by David Rogers on 10/25/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSAdFactory.h"

@interface CSMRAIDViewFactory : CSAdFactory

- (UIView *)adViewFromDictionary:(NSMutableDictionary*)dictionary;

@end
