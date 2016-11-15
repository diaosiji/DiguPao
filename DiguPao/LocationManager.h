//
//  LocationManager.h
//  CoreLocation-master
//
//  Created by xuran on 16/4/20.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocation * userLocation;
@property (strong, nonatomic) CLPlacemark * userPlaceMark;

+ (instancetype)sharedLocationManager;
- (void)openUpdatingLocation;
- (void)closeUpdatingLocation;
- (void)updatingHeading;
- (void)monitoringForRegion: (CLRegion *)region;
- (void)geocoderWithAddress: (NSString *)address complation: (void (^)(CLPlacemark * placeMark, NSError * error))complationBlock;
- (void)reverseGeocoderWithLocation: (CLLocation *)location complation: (void (^)(CLPlacemark * placeMark, NSError * error))complationBlock;
@end
