// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: csmessages.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class CSPDeviceID;
@class CSPStop;
@class CSPStopAd;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum CSPDeviceID_Type

typedef GPB_ENUM(CSPDeviceID_Type) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  CSPDeviceID_Type_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  CSPDeviceID_Type_Idfa = 0,
  CSPDeviceID_Type_Aaid = 1,
};

GPBEnumDescriptor *CSPDeviceID_Type_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL CSPDeviceID_Type_IsValidValue(int32_t value);

#pragma mark - CSPCsmessagesRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface CSPCsmessagesRoot : GPBRootObject
@end

#pragma mark - CSPStop

typedef GPB_ENUM(CSPStop_FieldNumber) {
  CSPStop_FieldNumber_AgencyId = 1,
  CSPStop_FieldNumber_RouteId = 2,
  CSPStop_FieldNumber_StopId = 3,
};

@interface CSPStop : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *agencyId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *routeId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *stopId;

@end

#pragma mark - CSPStopAd

typedef GPB_ENUM(CSPStopAd_FieldNumber) {
  CSPStopAd_FieldNumber_RequestId = 1,
  CSPStopAd_FieldNumber_Stop = 2,
  CSPStopAd_FieldNumber_Icon = 3,
  CSPStopAd_FieldNumber_Title = 4,
  CSPStopAd_FieldNumber_BackgroundColor = 5,
};

@interface CSPStopAd : GPBMessage

@property(nonatomic, readwrite) uint64_t requestId;

@property(nonatomic, readwrite, strong, null_resettable) CSPStop *stop;
/** Test to see if @c stop has been set. */
@property(nonatomic, readwrite) BOOL hasStop;

@property(nonatomic, readwrite, copy, null_resettable) NSData *icon;

@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

@property(nonatomic, readwrite, copy, null_resettable) NSString *backgroundColor;

@end

#pragma mark - CSPStopAdResponse

typedef GPB_ENUM(CSPStopAdResponse_FieldNumber) {
  CSPStopAdResponse_FieldNumber_StopAdsArray = 1,
};

@interface CSPStopAdResponse : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<CSPStopAd*> *stopAdsArray;
/** The number of items in @c stopAdsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger stopAdsArray_Count;

@end

#pragma mark - CSPDeviceID

typedef GPB_ENUM(CSPDeviceID_FieldNumber) {
  CSPDeviceID_FieldNumber_DeviceIdType = 1,
  CSPDeviceID_FieldNumber_DeviceId = 2,
};

@interface CSPDeviceID : GPBMessage

@property(nonatomic, readwrite) CSPDeviceID_Type deviceIdType;

@property(nonatomic, readwrite, copy, null_resettable) NSString *deviceId;

@end

/**
 * Fetches the raw value of a @c CSPDeviceID's @c deviceIdType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t CSPDeviceID_DeviceIdType_RawValue(CSPDeviceID *message);
/**
 * Sets the raw value of an @c CSPDeviceID's @c deviceIdType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetCSPDeviceID_DeviceIdType_RawValue(CSPDeviceID *message, int32_t value);

#pragma mark - CSPStopAdRequest

typedef GPB_ENUM(CSPStopAdRequest_FieldNumber) {
  CSPStopAdRequest_FieldNumber_AdUnit = 1,
  CSPStopAdRequest_FieldNumber_DeviceId = 2,
  CSPStopAdRequest_FieldNumber_Timezone = 3,
  CSPStopAdRequest_FieldNumber_StopsArray = 4,
};

@interface CSPStopAdRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *adUnit;

@property(nonatomic, readwrite, strong, null_resettable) CSPDeviceID *deviceId;
/** Test to see if @c deviceId has been set. */
@property(nonatomic, readwrite) BOOL hasDeviceId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *timezone;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<CSPStop*> *stopsArray;
/** The number of items in @c stopsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger stopsArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
