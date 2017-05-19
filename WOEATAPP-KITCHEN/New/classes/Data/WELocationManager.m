//
//  WELocationManager.m
//  woeat
//
//  Created by liubin on 17/1/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WELocationManager.h"
#import "WEOpenCity.h"
 #import <CoreLocation/CoreLocation.h>

@interface WELocationManager()<CLLocationManagerDelegate>
{
    
}
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation WELocationManager

+ (instancetype)sharedInstance
{
    static WELocationManager *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    return self;
}

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
    }
    else
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"无法获取您的位置" message:@"请进入手机设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        return;
        
    }
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    NSLog(@"location error %@", error);
}


- (double)getCurrentLatitude
{
    WEOpenCity *openCity = [WEOpenCity sharedInstance];
    double latitude = [openCity getSelectLatitude];
    if (latitude) {
        return latitude;
    } else {
        return TEST_Latitude.doubleValue;
    }
}

- (double)getCurrentLongitude
{
    WEOpenCity *openCity = [WEOpenCity sharedInstance];
    double longitude = [openCity getSelectLongitude];
    if (longitude) {
        return longitude;
    } else {
        return TEST_Longitude.doubleValue;
    }
}


@end
