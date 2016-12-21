//
//  MapView.h
//  CoreLocation-master
//
//  Created by xuran on 16/4/21.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : UIView
- (void)addCustomAnnotation: (id <MKAnnotation>)annotation;
- (void)callBackUserLocation;
- (void)gotoLocation: (CLLocation *)location;
- (void)createMapCameraWithCenter: (CLLocationCoordinate2D)center;
- (void)beginNavigationWithBeginPlaceMark: (CLPlacemark *)beginPlaceMark endPlaceMark: (CLPlacemark *)endPlaceMark;
- (void)mapSnapShot;
- (void)removeAnnotation:(id <MKAnnotation>)annotation;
@end
