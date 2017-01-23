//
//  NSURL+CSURL.m
//  CommuteStream
//
//  Created by David Rogers on 1/17/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import "NSURL+CSURL.h"

static NSString * const kTelephoneScheme = @"tel";
static NSString * const kTelephonePromptScheme = @"telprompt";

@implementation NSURL (CSURL)


- (BOOL)hasTelephoneScheme
{
    return [[[self scheme] lowercaseString] isEqualToString:kTelephoneScheme];
}

- (BOOL)hasTelephonePromptScheme
{
    return [[[self scheme] lowercaseString] isEqualToString:kTelephonePromptScheme];
}

- (BOOL)isSafeForLoadingWithoutUserAction
{
    return [[self scheme].lowercaseString isEqualToString:@"http"] ||
    [[self scheme].lowercaseString isEqualToString:@"https"] ||
    [[self scheme].lowercaseString isEqualToString:@"about"];
}

@end
