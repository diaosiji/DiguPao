//
//  MapView.m
//  CoreLocation-master
//
//  Created by xuran on 16/4/21.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 *  MapKit
 **/

#import "MapView.h"
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "XRAnnotation.h"

@interface MapView ()<MKMapViewDelegate>
@property (strong, nonatomic) MKMapView * mapView;
@end

@implementation MapView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsScale = YES;
        _mapView.showsCompass = YES;
        _mapView.showsBuildings = YES;
        _mapView.showsUserLocation = YES;
        _mapView.scrollEnabled = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        [self addSubview:_mapView];
    }
    
    return self;
}

// 添加大头针
- (void)addCustomAnnotation:(id<MKAnnotation>)annotation
{
    if (_mapView) {
        [_mapView addAnnotation:annotation];
    }
}

- (void)callBackUserLocation
{
    CLLocationCoordinate2D center = _mapView.userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [_mapView setRegion:region animated:YES];
}

- (void)gotoLocation: (CLLocation *)location
{
    CLLocationCoordinate2D center = location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [_mapView setRegion:region animated:YES];
}

/**
 *  创建地图街景
 **/
- (void)createMapCameraWithCenter:(CLLocationCoordinate2D)center
{
    // 创建3D视角
    MKMapCamera * camera = [MKMapCamera cameraLookingAtCenterCoordinate:center fromEyeCoordinate:CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001) eyeAltitude:1.0];
    _mapView.camera = camera;
}

/**
 *  调用系统App进行导航
 **/
- (void)beginNavigationWithBeginPlaceMark:(CLPlacemark *)beginPlaceMark endPlaceMark:(CLPlacemark *)endPlaceMark
{
    // 起点
    MKPlacemark * mPlaceMark1 = [[MKPlacemark alloc] initWithPlacemark:beginPlaceMark];
    MKMapItem * item1 = [[MKMapItem alloc] initWithPlacemark:mPlaceMark1];
    
    // 终点
    MKPlacemark * mPlaceMark2 = [[MKPlacemark alloc] initWithPlacemark:endPlaceMark];
    MKMapItem * item2 = [[MKMapItem alloc] initWithPlacemark:mPlaceMark2];
    
    // 调起系统App
    NSDictionary * launchParams = @{
                                    // 设置导航参数
                                    MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                    // 设置地图类型
                                    MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                    MKLaunchOptionsShowsTrafficKey : @(YES) // 是否显示交通
                                    };
    // 调用系统地图进行导航
    [MKMapItem openMapsWithItems:@[item1, item2] launchOptions:launchParams];
}

/**
 *  地图截图
 **/
- (void)mapSnapShot
{
    // 截图附加选项
    MKMapSnapshotOptions * options = [[MKMapSnapshotOptions alloc] init];
    options.region = _mapView.region; // 设置截图区域 （地图上的区域）
    options.size = _mapView.frame.size; // 设置截图大小
    options.scale = [UIScreen mainScreen].scale;
    
    MKMapSnapshotter * snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapShotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (!error) {
            UIImageWriteToSavedPhotosAlbum(snapshot.image, self, @selector(image:saveWithError:contextInfo:), nil);
        }else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)image: (UIImage *)image saveWithError: (NSError *)error contextInfo: (void *)contextInfo
{
    if (!error) {
        [[[UIAlertView alloc] initWithTitle:@"截图已经保存到相册" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else {
        NSLog(@"error: %@", error.localizedDescription);
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [[LocationManager sharedLocationManager] reverseGeocoderWithLocation:userLocation.location complation:^(CLPlacemark *placeMark, NSError *error) {
        if (!error) {
            userLocation.title = placeMark.locality;
            userLocation.subtitle = placeMark.name;
            CLLocationCoordinate2D coord = [userLocation coordinate];
            NSLog(@"经度:%f,纬度:%f",coord.latitude,coord.longitude);
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setDouble:coord.latitude forKey:@"latitude"];
            [user setDouble:coord.longitude forKey:@"longtitude"];
            
            [user synchronize];
        }else {
            userLocation.title = @"";
        }
    }];
    
}

// 返回大头针模型
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[XRAnnotation class]]) return nil; // 显示系统默认大头针
    
    static NSString * AnnotationViewIdentifier = @"AnnotationIdentifier";
    MKAnnotationView * annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewIdentifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(0, 0);
    }
    
    // 设置annotation
    if (!annotationView.annotation) {
        annotationView.annotation = annotation;
    }
    
    // 设置图片
    XRAnnotation * xrAnnotation = (XRAnnotation *)annotation;
    annotationView.image = [UIImage imageNamed:xrAnnotation.icon];
    //annotationView.canShowCallout = NO;
    return annotationView; // 返回自定义大头针
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"map加载完成");
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"停止定位用户的信息");
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
    NSLog(@"%d", views.count);
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"map加载失败");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"点击了大头针");
    view.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];

}



@end
