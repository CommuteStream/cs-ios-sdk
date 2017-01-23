//
//  NSURL+CSURL.h
//  CommuteStream
//
//  Created by David Rogers on 1/17/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CSURL)

- (BOOL)hasTelephoneScheme;
- (BOOL)hasTelephonePromptScheme;
- (BOOL)isSafeForLoadingWithoutUserAction;

@end
