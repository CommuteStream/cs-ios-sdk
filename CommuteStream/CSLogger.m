//
//  CSLogger.m
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import "CSLogger.h"

// Default setting is CommuteStreamLogLevelNone.
static CommuteStreamLogLevel logLevel;

@implementation CSLogger

+ (void)setLogLevel:(CommuteStreamLogLevel)level
{
    NSArray *levelNames = @[
                            @"none",
                            @"error",
                            @"warning",
                            @"info",
                            @"debug",
                            ];
    
    NSString *levelName = levelNames[level];
    NSLog(@"CommuteStream Logger: log level set to %@", levelName);
    logLevel = level;
}

+ (void)error:(NSString *)tag withMessage:(NSString *)message
{
    if (logLevel >= CommuteStreamLogLevelError) {
        NSLog(@"%@: (E) %@", tag, message);
    }
}

+ (void)warning:(NSString *)tag withMessage:(NSString *)message
{
    if (logLevel >= CommuteStreamLogLevelWarning) {
        NSLog(@"%@: (W) %@", tag, message);
    }
}

+ (void)info:(NSString *)tag withMessage:(NSString *)message
{
    if (logLevel >= CommuteStreamLogLevelInfo) {
        NSLog(@"%@: (I) %@", tag, message);
    }
}

+ (void)debug:(NSString *)tag withMessage:(NSString *)message
{
    if (logLevel >= CommuteStreamLogLevelDebug) {
        NSLog(@"%@: (D) %@", tag, message);
    }
}

@end

