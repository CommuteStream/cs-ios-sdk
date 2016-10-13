//
//  CSMRAIDParser.h
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSMRAIDView;

// A parser class which validates MRAID commands passed from the creative to the native methods.
// This takes a commandUrl of type "mraid://command?param1=val1&param2=val2&..." and return a
// dictionary of key/value pairs which include command name and all the parameters. It checks
// if the command itself is a valid MRAID command and also a simpler parameters validation.
@interface CSMRAIDParser : NSObject

- (NSDictionary *)parseCommandUrl:(NSString *)commandUrl;

@end
