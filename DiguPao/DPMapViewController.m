//
//  DPMapViewController.m
//  DiguPao
//
//  Created by Flood Sung on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPMapViewController.h"
#import "LocationManager.h"
#import "MapView.h"
#import "XRAnnotation.h"

@interface DPMapViewController () 
{
    MapView * map;
    LocationManager * manager;
}

@end

@implementation DPMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    map  = [[MapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:map];
    
    manager = [LocationManager sharedLocationManager];
    [manager openUpdatingLocation];
    
    [map callBackUserLocation];
    
    // 添加大头针
    XRAnnotation * annotation1 = [[XRAnnotation alloc] init];
    annotation1.title = @"不错呦";
    annotation1.subtitle = @"好啊";
    annotation1.coordinate = CLLocationCoordinate2DMake(28.2313, 112.9914);
    annotation1.icon = @"map1";
    [map addCustomAnnotation:annotation1];
    
    XRAnnotation * annotation2 = [[XRAnnotation alloc] init];
    annotation2.title = @"不错呦2";
    annotation2.subtitle = @"好啊2";
    annotation2.coordinate = CLLocationCoordinate2DMake(28.23141, 112.99331);
    annotation2.icon = @"map1";
    
    [map addCustomAnnotation:annotation2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"StartLoadingMap");
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"FinishLoadingMap");
}

- (void) mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"DidFailLoadingMap%@",error);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    double latitude = [user doubleForKey:@"latitude"];
    double longtitude = [user doubleForKey:@"longtitude"];
    
    NSLog(@"latitude:%f,longtitude:%f",latitude,longtitude);
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
