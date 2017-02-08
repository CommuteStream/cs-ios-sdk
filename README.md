# CommuteStream iOS SDK

This SDK allows you to add CommuteStream ads to your app using MoPub or AdMob for mediation.

These instructions assume you have already followed the instructions at: [https://commutestream.com/sdkinstructions](https://commutestream.com/sdkinstructions).


## Requirements
Your app needs the follow in addition to any sub-requirements of MoPub or AdMob.

- iOS 8.0 and up
- (For MoPub) MoPub SDK 4.11.1 and up
- (For AdMob) Latest Google Mobile Ads SDK

## Downloading
Clone the repository or download the appropriate zip file:

**GitHub:**
[https://github.com/CommuteStream/cs-ios-sdk](https://github.com/CommuteStream/cs-ios-sdk).

**AdMob:**
[CommuteStreamAdMob-iOS-0.8.0.zip](https://s3.amazonaws.com/download.commutestream.com/CommuteStreamAdMob-iOS-0.8.0.zip).

**MoPub:**
[CommuteStreamMoPub-iOS-0.8.0.zip](https://s3.amazonaws.com/download.commutestream.com/CommuteStreamMoPub-iOS-0.8.0.zip).

   
## Adding the SDK
First, follow either the AdMob or MoPub mediation setup instructions found at [https://commutestream.com/sdkinstructions](https://commutestream.com/sdkinstructions), then follow the instructions for either AdMob or MoPub:

**For AdMob:**

1. Drag the
`CommuteStream-Admob-SDK.framework` file into your Xcode project.


2. In your project's Build Settings, add `-ObjC` to `Other Linker Flags`.


3. Add `#import <CommuteStreamAdMob/CommuteStream.h>` to the top of each ViewController that requests ads.

**For MoPub:**

1. Drag the
`CommuteStream-MoPub-SDK.framework` file into your Xcode project.


2. In your project's Build Settings, add `-ObjC` to `Other Linker Flags`.


3. Add `#import <CommuteStreamMoPub/CommuteStream.h>` to the top of each ViewController that requests ads.



## Test Banners
Test banners are a great way to make sure things are working as they should be. There are two ways to force test banners to show up in your app:

1. Programmatically with the following code called prior to the ad request

	**Objective-C**
	```
	[[CommuteStream] open] setTesting]
	```

	**Swift**
	```
	CommuteStream.open().setTesting()
	```
2. Test banners can also be set on a per-device basis through the CommuteStream web interface.
	1. Log into your CommuteStream publisher account
	2. Click the "Apps" tab, then select "Test Devices".
	3. Review the instructions on the page, then add a new test device by clicking 		the "New Test Device" button and entering the required information.

**Important:** Your mediations settings must be setup correctly in order to see CS test banners. See [https://commutestream.com/sdkinstructions](https://commutestream.com/sdkinstructions) for more details. Also, be sure Admob or MoPub is not in testing mode itself, as this will prevent CS test banners from showing up.

## Recommended Usage
Our ability to deliver quality and meaningful deals, events, and advertising, hinges on your implementation of the below methods. Hence, we pay you based on your implementation of these methods. In order to receive the maximum revenue possible, you will need to implement all of the following methods (as applicable to your app) and follow the requirements for each.

We start off paying all of our developers the maximum revenue (currently $4 per 1000 impressions). After a few weeks we will conduct a review of the data being provided by your app and adjust your revenue rate based on how closely you follow the SDK requirements. Note that some of these methods may not apply to all apps.

**IMPORTANT:** Be sure to import the CommuteStream SDK into all your class files that will call the below methods. Use route ID, and stop ID as defined by that agency’s GTFS data and use the agency ID from the Agency ID table in the section below. We understand that in some cases the stop ID and route ID may not be applicable, in which case you can set these to null. Please refer to our  [Best Practices doc](https://commutestream.com/bestpractices) for further information.

### User Locations
If your app uses location data (e.g. to provide a list of nearby stops), the following method must be made every time device location data is obtained by your app code.

**Objective-C**
```
[[CommuteStream open] setLocation:(CLLocation*)location];
```
**Swift**
```
CommuteStream.open().setLocation(location)
```

### Display of Transit Info
The following methods are to be made every time each of the following types of transit information are displayed to the user. These methods should be made multiple times in succession if multiple pieces of information are displayed to the user at the same time. For example if one view shows the arrival times for three different stops, the trackingDisplayed method should be made three times.

#### Arrival Time/Tracking Info:
**Objective-C**
```
[[CommuteStream open] trackingDisplayed:(NSString *)agency routeID:(NSString *)route stopID:(NSString *)stop];
```

**Swift**
```
CommuteStream.open().trackingDisplayed(agency, routeID, stopID)
```



#### Agency Alert Info:
**Objective-C**

```
[[CommuteStream open] alertDisplayed:(NSString *)agency routeID:(NSString *)route stopID:(NSString *)stop];
```
**Swift**
```
CommuteStream.open().alertDisplayed(agency, routeID, stopID)
```

#### Map Info (Geographic Data):
**Objective-C**
```
[[CommuteStream open] mapDisplayed:(NSString *)agency routeID:(NSString *)route stopID:(NSString *)stop];
```
**Swift**
```
CommuteStream.open().mapDisplayed(agency, routeID, stopID)
```

### User Actions
The following methods are to be made every time the user peforms one of the following actions:

#### "Bookmarks" or "Favorities" a Transit Stop:
**Objective-C**
```
[[CommuteStream open] favoriteAdded:(NSString *)agency routeID:(NSString *)route stopID:(NSString *)stop];
```
**Swift**
```
CommuteStream.open().favoriteAdded(agency, routeID, stopID)
```

#### Selects Stop As The Starting Point Of a Trip:
**Objective-C**
```
[[CommuteStream open] tripPlanningPointA:(NSString *)agency routeID:(NSString *)route stopID:(NSString *)stop];
```
**Swift**
```
CommuteStream.open().tripPlanningPointA(agency, routeID, stopID)
```

#### Selects Stop As The Final Destination Of a Trip:
**Objective-C**
```
[[CommuteStream open] tripPlanningPointB:(NSString *)agency routeID:(NSString *)route stopID:(NSString *)stop];
```
**Swift**
```
CommuteStream.open().tripPlanningPointB(agency, routeID, stopID)
```

### Location
Previous versions of the CommuteStream SDK required calls to `CommuteStream.setLocation(Location location);` -- this is no longer needed. The SDK now obtains location info automatically in apps that utilize location services. If your app does not use location services, or the user has not granted location permissions, location data will not be collected.

## Agency IDs
The following ids are to be used in the various method calls above where "agency_id" is required. We are adding new markets reguarly; the current list is availible [here](https://commutestream.com/markets).

| Description   | Agency ID / CS ID  |
| ------------- | -----|
| Chicago CTA | cta |
| Chicago Metra | METRA |
| Chicago PACE | PACE |
| Boston MBTA | MBTA |
| Pittsburgh PAAC | PAAC |
| Minneapolis / St. Paul Area | MINNEAPOLIS |
| Washington DC Area | DC |
| Los Angeles County | LA |
| Philadelphia - SEPTA Bus | SEPTABUS |
| Philadelphia - SEPTA Rail | SEPTARAIL |
| Seattle Area (King County Metro) | SEATTLE |
| Miami-Dade County Metro | MIAMI |
| Portland - TriMet | TRIMET |
| Salt Lake City Area - UTA | UTA |
| Utah - Cache Valley Transit District | CVTD |
| NYC - MTA Subway | MTA_SUBWAY |
| NYC - MTA Bus | MTA_BUS |
| NYC - MTA Metro North | MTA_METRO_NORTH |
| NYC - MTA Long Island Railroad | MTA_LONG_ISLAND |
| New Jersey - NJ Transit Rail | NJT_RAIL |
| New Jersey - NJ Transit Bus | NJT_BUS |
| San Diego - Metropolitan Transit System | MTS |
| San Francisco - SFMTA | SFMTA |
| San Francisco - Bay Area Rapid Transit | BART |
| San Francisco - AC Transit | AC |
| Baltimore - Maryland Transit Administration | MARYLAND |
| Las Vegas - RTC | RTC |
| Tampa - Hillsborough Area Regional Transit | HART |
| London - Transport for London | TFL |
| Toronto - Toronto Transit Commission | TTC |


## Logging

Log messages from the CommuteStream SDK are sent to Console under the "CS_SDK" tag.