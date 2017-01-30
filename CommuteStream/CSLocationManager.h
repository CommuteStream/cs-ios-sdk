//
//  CSLocationManager.h
//  CommuteStream
//
//  Created by David Rogers on 1/27/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface CSLocationManager : NSObject

/**
 * Returns the shared instance of the `MPGeolocationProvider` class.
 *
 * @return The shared instance of the `MPGeolocationProvider` class.
 */
+ (instancetype)sharedProvider;

/**
 * The most recent location determined by the location provider.
 */
@property (nonatomic, readonly) CLLocation *lastKnownLocation;

/**
 * Determines whether the location provider should attempt to listen for location updates. The
 * default value is YES.
 */
@property (nonatomic, assign) BOOL locationUpdatesEnabled;



@end
