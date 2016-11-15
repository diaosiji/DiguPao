//
//  DPMapViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
