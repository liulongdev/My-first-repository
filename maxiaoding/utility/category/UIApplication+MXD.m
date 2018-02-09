//
//  UIApplication+MXD.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/9.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "UIApplication+MXD.h"
#import <objc/runtime.h>

typedef void (^MXDLocationSuccessCallback)(void);
typedef void (^MXDLocationFailureCallback)(void);

static char MXDPermissionsLocationManagerPropertyKey;
static char MXDPermissionsLocationBlockSuccessPropertyKey;
static char MXDPermissionsLocationBlockFailurePropertyKey;

@interface UIApplication () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *mxd_permissionsLocationManager;
@property (nonatomic, copy) MXDLocationSuccessCallback mxd_locationSuccessCallbackProperty;
@property (nonatomic, copy) MXDLocationFailureCallback mxd_locationFailureCallbackProperty;
@end

@implementation UIApplication (MXD)

- (void)mxd_requestAccessToLocationWithSuccess:(void (^)(void))accessGranted andFailure:(void (^)(void))accessDenied
{
    self.mxd_permissionsLocationManager = [[CLLocationManager alloc] init];
    self.mxd_permissionsLocationManager.delegate = self;
    if (IS_IOSORLATER(8.0))
        [self.mxd_permissionsLocationManager requestWhenInUseAuthorization];
    
    self.mxd_locationSuccessCallbackProperty = accessGranted;
    self.mxd_locationFailureCallbackProperty = accessDenied;
    [self.mxd_permissionsLocationManager startUpdatingLocation];
}

#pragma mark - Location manager injection
-(CLLocationManager *)mxd_permissionsLocationManager {
    return objc_getAssociatedObject(self, &MXDPermissionsLocationManagerPropertyKey);
}

-(void)setMxd_permissionsLocationManager:(CLLocationManager *)manager {
    objc_setAssociatedObject(self, &MXDPermissionsLocationManagerPropertyKey, manager, OBJC_ASSOCIATION_RETAIN);
}

-(MXDLocationSuccessCallback)mxd_locationSuccessCallbackProperty {
    return objc_getAssociatedObject(self, &MXDPermissionsLocationBlockSuccessPropertyKey);
}

-(void)setMxd_locationSuccessCallbackProperty:(MXDLocationSuccessCallback)locationCallbackProperty {
    objc_setAssociatedObject(self, &MXDPermissionsLocationBlockSuccessPropertyKey, locationCallbackProperty, OBJC_ASSOCIATION_COPY);
}

-(MXDLocationFailureCallback)mxd_locationFailureCallbackProperty {
    return objc_getAssociatedObject(self, &MXDPermissionsLocationBlockFailurePropertyKey);
}

-(void)setMxd_locationFailureCallbackProperty:(MXDLocationFailureCallback)locationFailureCallbackProperty {
    objc_setAssociatedObject(self, &MXDPermissionsLocationBlockFailurePropertyKey, locationFailureCallbackProperty, OBJC_ASSOCIATION_COPY);
}


#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mxd_locationSuccessCallbackProperty();
        [self.mxd_permissionsLocationManager stopUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        self.mxd_locationFailureCallbackProperty();
        [self.mxd_permissionsLocationManager stopUpdatingLocation];
    }
#else
    if (IS_IOSORLATER(8.0)) {
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            self.mxd_locationSuccessCallbackProperty();
            [self.mxd_permissionsLocationManager stopUpdatingLocation];
        }else if (status != kCLAuthorizationStatusNotDetermined) {
            self.mxd_locationFailureCallbackProperty();
            [self.mxd_permissionsLocationManager stopUpdatingLocation];
        }
    }
    else
    {
        if (status == kCLAuthorizationStatusAuthorized) {
            self.mxd_locationSuccessCallbackProperty();
        }else if (status != kCLAuthorizationStatusNotDetermined) {
            self.mxd_locationFailureCallbackProperty();
        }
    }
#endif
}

@end
