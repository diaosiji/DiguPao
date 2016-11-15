//
//  XRAnnotation.h
//  CoreLocation-master
//
//  Created by xuran on 16/4/21.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface XRAnnotation : NSObject<MKAnnotation>
@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

// 添加一个自定义属性
@property (copy, nonatomic) NSString * icon;
@end
