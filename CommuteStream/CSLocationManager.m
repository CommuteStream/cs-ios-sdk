//
//  CSLocationManager.m
//  CommuteStream
//
//  Created by David Rogers on 1/27/17.
//  Copyright © 2017 CommuteStream. All rights reserved.
//

#import "CSLocationManager.h"
#import "CommuteStream.h"

const CLLocationDistance kCityBlockDistanceFilter = 100.0;

const NSTimeInterval kLocationUpdateDuration = 15.0;

const NSTimeInterval kLocationUpdateInterval = 10.0 * 60.0;

@interface CSLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, readwrite) CLLocation *lastKnownLocation;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL authorizedForLocationServices;
@property (nonatomic) NSDate *timeOfLastLocationUpdate;
@property (nonatomic) NSTimer *nextLocationUpdateTimer;
@property (nonatomic) NSTimer *locationUpdateDurationTimer;

@end


@implementation CSLocationManager


+ (instancetype)sharedProvider
{
    static CSLocationManager *sharedProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProvider = [[[self class] alloc] init];
    });
    return sharedProvider;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationUpdatesEnabled = YES;
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCityBlockDistanceFilter;
        
        // CLLocationManager's `location` property may already contain location data upon
        // initialization (for example, if the application uses significant location updates).
        CLLocation *existingLocation = _locationManager.location;
        if ([self locationHasValidCoordinates:existingLocation]) {
            _lastKnownLocation = existingLocation;
            NSLog(@"Found previous location information.");
        }
        
        
        // Avoid processing location updates when the application enters the background.
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [self stopAllCurrentOrScheduledLocationUpdates];
        }];
        
        // Re-activate location updates when the application comes back to the foreground.
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            if (_locationUpdatesEnabled) {
                [self resumeLocationUpdatesAfterBackgrounding];
            }
        }];
        
        [self startRecurringLocationUpdates];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

#pragma mark - Public

- (CLLocation *)lastKnownLocation
{
    if (!self.locationUpdatesEnabled) {
        return nil;
    }
    
    return _lastKnownLocation;
}

- (void)setLocationUpdatesEnabled:(BOOL)enabled
{
    _locationUpdatesEnabled = enabled;
    
    if (!_locationUpdatesEnabled) {
        [self stopAllCurrentOrScheduledLocationUpdates];
        self.lastKnownLocation = nil;
    } else if (![self.locationUpdateDurationTimer isValid] && ![self.nextLocationUpdateTimer isValid]) {
        [self startRecurringLocationUpdates];
    }
}

#pragma mark - Internal

- (void)setAuthorizedForLocationServices:(BOOL)authorizedForLocationServices
{
    _authorizedForLocationServices = authorizedForLocationServices;
    
    if (_authorizedForLocationServices && [CLLocationManager locationServicesEnabled]) {
        [self startRecurringLocationUpdates];
    } else {
        [self stopAllCurrentOrScheduledLocationUpdates];
        self.lastKnownLocation = nil;
    }
}

- (BOOL)isAuthorizedStatus:(CLAuthorizationStatus)status
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    return (status == kCLAuthorizationStatusAuthorizedAlways) || (status == kCLAuthorizationStatusAuthorizedWhenInUse);
#else
    return status == kCLAuthorizationStatusAuthorized;
#endif
}

/**
 * Tells the location provider to start periodically retrieving new location data.
 *
 * The location provider will activate its underlying location manager for a specified amount of
 * time, during which the provider may receive delegate callbacks about location updates. After this
 * duration, the provider will schedule a future update. These updates can be stopped via
 * -stopAllCurrentOrScheduledLocationUpdates.
 */
- (void)startRecurringLocationUpdates
{
    self.timeOfLastLocationUpdate = [NSDate date];
    
    if (![CLLocationManager locationServicesEnabled] || ![self isAuthorizedStatus:[CLLocationManager authorizationStatus]]) {
        NSLog(@"Will not start location updates: the application is not authorized "
                   @"for location services.");
        return;
    }
    
    if (!_locationUpdatesEnabled) {
        NSLog(@"Will not start location updates because they have been disabled.");
        return;
    }
    
    [self.locationManager startUpdatingLocation];
    
    [self.locationUpdateDurationTimer invalidate];
    self.locationUpdateDurationTimer = [NSTimer scheduledTimerWithTimeInterval:kLocationUpdateDuration target:self selector:@selector(currentLocationUpdateDidFinish) userInfo:nil repeats:NO];
}

- (void)currentLocationUpdateDidFinish
{
    NSLog(@"Stopping the current location update session and scheduling the next session.");
    [self.locationUpdateDurationTimer invalidate];
    [self.locationManager stopUpdatingLocation];
    
    [self scheduleNextLocationUpdateAfterDelay: kLocationUpdateInterval];
}

- (void)scheduleNextLocationUpdateAfterDelay:(NSTimeInterval)delay
{
    NSLog(@"Next user location update due in %.1f seconds.", delay);
    [self.nextLocationUpdateTimer invalidate];
    //self.nextLocationUpdateTimer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(startRecurringLocationUpdates) userInfo:nil repeats:NO];
    
    self.nextLocationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(startRecurringLocationUpdates) userInfo:nil repeats:NO];
    
}

- (void)stopAllCurrentOrScheduledLocationUpdates
{
    NSLog(@"Stopping any scheduled location updates.");
    [self.locationUpdateDurationTimer invalidate];
    [self.locationManager stopUpdatingLocation];
    
    [self.nextLocationUpdateTimer invalidate];
}

- (void)resumeLocationUpdatesAfterBackgrounding
{
    NSTimeInterval timeSinceLastUpdate = [[NSDate date] timeIntervalSinceDate:self.timeOfLastLocationUpdate];
    
    if (timeSinceLastUpdate >= kLocationUpdateInterval) {
        NSLog(@"Last known user location is stale. Updating location.");
        [self startRecurringLocationUpdates];
    } else if (timeSinceLastUpdate >= 0) {
        NSTimeInterval timeToNextUpdate = kLocationUpdateInterval - timeSinceLastUpdate;
        [self scheduleNextLocationUpdateAfterDelay:timeToNextUpdate];
    } else {
        [self scheduleNextLocationUpdateAfterDelay:kLocationUpdateInterval];
    }
}

#pragma mark - CLLocation Helpers

- (BOOL)isLocation:(CLLocation *)location betterThanLocation:(CLLocation *)otherLocation
{
    if (!otherLocation) {
        return YES;
    }
    
    // Nil locations and locations with invalid horizontal accuracy are worse than any location.
    if (![self locationHasValidCoordinates:location]) {
        return NO;
    }
    
    if ([self isLocation:location olderThanLocation:otherLocation]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)locationHasValidCoordinates:(CLLocation *)location
{
    return location && location.horizontalAccuracy > 0;
}

- (BOOL)isLocation:(CLLocation *)location olderThanLocation:(CLLocation *)otherLocation
{
    return [location.timestamp timeIntervalSinceDate:otherLocation.timestamp] < 0;
}

#pragma mark - <CLLocationManagerDelegate> (iOS 6.0+)

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Location authorization status changed to: %ld", (long)status);
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            self.authorizedForLocationServices = NO;
            break;
        case kCLAuthorizationStatusAuthorizedAlways: // same as kCLAuthorizationStatusAuthorized
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        case kCLAuthorizationStatusAuthorizedWhenInUse:
#endif
            self.authorizedForLocationServices = YES;
            break;
        default:
            self.authorizedForLocationServices = NO;
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Called didUpdateLocations: %@", locations);
    for (CLLocation *location in locations) {
        if ([self isLocation:location betterThanLocation:self.lastKnownLocation]) {
            self.lastKnownLocation = location;
            [[CommuteStream open] setLocation:location];
            NSLog(@"Updated last known user location: %@", location);
            
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        NSLog(@"Location manager failed: the user has denied access to location services.");
        [self stopAllCurrentOrScheduledLocationUpdates];
    } else if (error.code == kCLErrorLocationUnknown) {
        NSLog(@"Location manager could not obtain a location right now.");
    }
}

#pragma mark - <CLLocationManagerDelegate> (iOS < 6.0)

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ([self isLocation:newLocation betterThanLocation:self.lastKnownLocation]) {
        self.lastKnownLocation = newLocation;
        [[CommuteStream open] setLocation:newLocation];
        NSLog(@"Updated last known user location.");
    }
}

@end

