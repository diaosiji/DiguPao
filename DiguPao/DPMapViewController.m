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
#import "AFOAuth2Manager.h"
#import "DPStatus.h"
#import "DPUser.h"
#import "MJExtension.h"

@interface DPMapViewController () 
{
    MapView * map;
    LocationManager * manager;
    NSMutableDictionary *oldAnnotations;
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
    
    oldAnnotations = [NSMutableDictionary dictionary];
    
    [self loadAroundStatus];
    // 添加大头针
    /*
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
     */
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
    
    [self loadAroundStatus];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadAroundStatus {
    NSLog(@"around");
    
    // 获取含accessToken的凭证对象
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 获取地理位置
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    double latitudeDouble = [user doubleForKey:@"latitude"];
    double longtitudeDouble = [user doubleForKey:@"longtitude"];
    NSString *latitude = [NSString stringWithFormat:@"%f", latitudeDouble];
    NSString *longitude = [NSString stringWithFormat:@"%f", longtitudeDouble];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    params[@"latitude"] = latitude;
    params[@"longitude"]= longitude;
    NSLog(@"around params: %@", params);
    
    [manager GET:@"/api/v1/paopaos/location" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        
        NSArray *newStatus = [DPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        NSLog(@"附近API测试成功");
        NSMutableDictionary *newAnnotations = [NSMutableDictionary dictionary];
        
        
        for (DPStatus *status in newStatus) {
            // 添加大头针
            XRAnnotation * annotation1 = [[XRAnnotation alloc] init];
            annotation1.idstr = status.idstr;
            annotation1.title = status.user.name;
            annotation1.subtitle = status.text;
            double latitude = [status.latitude doubleValue];
            double longitude = [status.longitude doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                //判断是不是属于国内范围
            CLLocationCoordinate2D coordinate = [location coordinate];
            annotation1.coordinate = coordinate;
            annotation1.icon = @"map1";
            
            
            
            if ([oldAnnotations objectForKey:status.idstr] != nil) {
                [newAnnotations setObject:[oldAnnotations objectForKey:status.idstr] forKey:status.idstr];
            } else {
                [newAnnotations setObject:annotation1 forKey:status.idstr];
                [map addCustomAnnotation:annotation1];
            }
        }
        for (XRAnnotation *annotation in oldAnnotations.allValues) {
            if ([newAnnotations objectForKey:annotation.idstr] == nil) {
                [map removeAnnotation:annotation];
            }
        }
            
        oldAnnotations = newAnnotations;
            
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"附近API测试失败: %@", error);
    }];
    
}

@end
