//
//  LocationManager.m
//  CoreLocation-master
//
//  Created by xuran on 16/4/20.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 *  CoreLocation
 **/

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LocationManager ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager * locationMgr; // 定位管理
@end

@implementation LocationManager

- (instancetype)init
{
    if (self = [super init]) {
        
        // 创建CLLocationManager
        _locationMgr = [[CLLocationManager alloc] init];
        _locationMgr.delegate = self;
        [self initialLocationManager];
    }
    
    return self;
}

+ (instancetype)sharedLocationManager
{
    static LocationManager * manager = nil;
    static dispatch_once_t onceToken = 0l;
    
    dispatch_once(&onceToken, ^{
        if (nil == manager) {
            manager = [[LocationManager alloc] init];
        }
    });
    
    return manager;
}

// 初始化定位管理
- (void)initialLocationManager
{
    _locationMgr.distanceFilter = 1; // 每隔50m调用一次
    _locationMgr.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精度
    
    if ([_locationMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationMgr requestAlwaysAuthorization];
    }
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0) {
        _locationMgr.allowsBackgroundLocationUpdates = YES;
    }
}

// 开启定位
- (void)openUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationMgr startUpdatingLocation];
    }
}

// 监听进出某个区域
- (void)monitoringForRegion: (CLRegion *)region
{
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationMgr startMonitoringForRegion:region];
    }
}

// 监听设备方向
- (void)updatingHeading
{
    [_locationMgr startUpdatingHeading];
}

// 关闭定位
- (void)closeUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationMgr stopUpdatingLocation];
    }
}

// 地理位置编码
- (void)geocoderWithAddress: (NSString *)address complation: (void (^)(CLPlacemark * placeMark, NSError * error))complationBlock
{
    if (address && address.length > 0) {
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                // 编码成功
                CLPlacemark * placeMark = [placemarks firstObject];
                NSLog(@"----%@", placeMark.name);
                complationBlock(placeMark, nil);
            }else {
                // 编码失败
                complationBlock(nil, error);
            }
        }];
    }
}

// 地理位置反编码
- (void)reverseGeocoderWithLocation: (CLLocation *)location complation: (void (^)(CLPlacemark * placeMark, NSError * error))complationBlock
{
    // 反编码
    if (location) {
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (!error) {
                // 反编码成功
                CLPlacemark * placeMark = [placemarks firstObject];
                
                complationBlock(placeMark, nil);
            }else {
                complationBlock(nil, error);
            }
        }];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"暂停定位");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"重新开启定位");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    /*
        coordinate: 经纬度
        altitude:   海拔
        course:     航向
        speed:      速度 m/s
     */
    
    CLLocation * location = (CLLocation *)[locations lastObject];
    self.userLocation = location;
    
    /*
        当前用户的行走方向，偏离角度，移动距离
     */
    
    NSString * directionString = nil;
    
    int direction = location.course / 90;
    
    switch (direction) {
        case 0:
            directionString = @"北偏东";
            break;
        case 1:
            directionString = @"东偏南";
            break;
        case 2:
            directionString = @"南偏西";
            break;
        case 3:
            directionString = @"西偏北";
            break;
        default:
            break;
    }
    
    // 偏向角度
    int angle = 0;
    angle = (int)location.course % 90;
    
    // 正方向
    if (angle == 0) {
        NSRange range = NSMakeRange(0, 1);
        directionString = [NSString stringWithFormat:@"正%@", [directionString substringWithRange:range]];
    }
    
    __weak __typeof(self) weakSelf = self;
    //NSLog(@"latatude: %lf, longitatude: %lf 方向： %@", location.coordinate.latitude, location.coordinate.longitude, directionString);
    
    
    
    //NSLog(@"speed: %lf", location.speed);
    [self reverseGeocoderWithLocation:location complation:^(CLPlacemark *placeMark, NSError *error) {
        if (!error) {
            weakSelf.userPlaceMark = placeMark;
            NSString * name = placeMark.name;
            
            //NSLog(@"%@", placeMark.addressDictionary);
            //NSLog(@"地址：%@", name);
            //NSLog(@"国家： %@ - 省： %@ - 市： %@ - 街道：%@ - 号：%@", placeMark.country, placeMark.administrativeArea, placeMark.locality, placeMark.thoroughfare, placeMark.subThoroughfare);
        }else {
            NSLog(@"反编码失败： %@", error.description);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败：%@", error.description);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    // 进入到某个区域
    NSLog(@"进入区域: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    // 离开某个区域
    NSLog(@"离开区域: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // 在某个区域的状态
    switch (state) {
        case CLRegionStateUnknown:
            NSLog(@"未知状态");
            break;
        case CLRegionStateInside:
        {
            NSLog(@"在范围内");
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:[NSString stringWithFormat:@"您已经进入‘%@’监控区", region.identifier] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"知道啦", nil];
            [alert show];
        }
            break;
        case CLRegionStateOutside:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:[NSString stringWithFormat:@"您已经离开‘%@’监控区", region.identifier] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"知道啦", nil];
            [alert show];
        }
            NSLog(@"离开");
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    /*
        magneticHeading: 磁北角度
        trueHeading:     真北角度
     */
    CGFloat angle = newHeading.magneticHeading / 180.0 * M_PI;
    // 指南针
    [UIView animateWithDuration:025 animations:^{
        UIView * copView = [[UIView alloc] init];
        copView.transform = CGAffineTransformMakeRotation(-angle);
    }];
}

// 授权状态发生改变时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusDenied: // 定位关闭时，或者授权为never时调用
            
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位开启，但被拒");
            }else {
                NSLog(@"定位关闭，不可用");
            }
            
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"访问受限");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还未决定");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"获得前后台定位授权");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"获得前台定位授权");
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"开始监听 region: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{

}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"error: %@", error.description);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"监听出错 error: %@", error.description);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    
}


@end




