//
//  DPMapViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPMapViewController.h"
#import <MapKit/MapKit.h>

@interface DPMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *myMapView;

@end

@implementation DPMapViewController

- (MKMapView *)myMapView{
    if (!_myMapView) {
        _myMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _myMapView.mapType = MKMapTypeHybrid;
        _myMapView.delegate = self;
        _myMapView.showsUserLocation = YES;//显示自己
        
        _myMapView.zoomEnabled = YES;
        [self.view addSubview:_myMapView];
    }
    return _myMapView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self myMapView];
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
