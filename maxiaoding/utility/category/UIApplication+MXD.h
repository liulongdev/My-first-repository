//
//  UIApplication+MXD.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/9.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, MXDPermissionAccess) {
    MXDPermissionAccessDenied, //User has rejected feature
    MXDPermissionAccessGranted, //User has accepted feature
    MXDPermissionAccessRestricted, //Blocked by parental controls or system settings
    MXDPermissionAccessUnknown, //Cannot be determined
    MXDPermissionAccessUnsupported, //Device doesn't support this - e.g Core Bluetooth
    MXDPermissionAccessMissingFramework, //Developer didn't import the required framework to the project
};

@interface UIApplication (MXD)

//-(MXDPermissionAccess)mxd_hasAccessToBluetoothLE;
//-(MXDPermissionAccess)mxd_hasAccessToCalendar;
//-(MXDPermissionAccess)mxd_hasAccessToContacts;
//-(MXDPermissionAccess)mxd_hasAccessToLocation;
//-(MXDPermissionAccess)mxd_hasAccessToPhotos;
//-(MXDPermissionAccess)mxd_hasAccessToReminders;

///Request permission with callback
//-(void)mxd_requestAccessToCalendarWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
//-(void)mxd_requestAccessToContactsWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
//-(void)mxd_requestAccessToMicrophoneWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
//-(void)mxd_requestAccessToPhotosWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
//-(void)mxd_requestAccessToRemindersWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;

//Instance methods
-(void)mxd_requestAccessToLocationWithSuccess:(void(^)(void))accessGranted andFailure:(void(^)(void))accessDenied;

//No failure callback available
//-(void)mxd_requestAccessToMotionWithSuccess:(void(^)())accessGranted;

@end
