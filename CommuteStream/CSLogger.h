//
//  CSLogger.h
//  CommuteStream
//
//  Created by David Rogers on 10/12/16.
//  Copyright © 2016 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CommuteStreamLogLevelNone,
    CommuteStreamLogLevelError,
    CommuteStreamLogLevelWarning,
    CommuteStreamLogLevelInfo,
    CommuteStreamLogLevelDebug,
} CommuteStreamLogLevel;

// A simple logger enable you to see different levels of logging.
// Use logLevel as a filter to see the messages for the specific level.
//
@interface CSLogger : NSObject

// Method to filter logging with the level passed as the paramter
+ (void)setLogLevel:(CommuteStreamLogLevel)logLevel;

+ (void)error:(NSString *)tag withMessage:(NSString *)message;
+ (void)warning:(NSString *)tag withMessage:(NSString *)message;
+ (void)info:(NSString *)tag withMessage:(NSString *)message;
+ (void)debug:(NSString *)tag withMessage:(NSString *)message;

@end
