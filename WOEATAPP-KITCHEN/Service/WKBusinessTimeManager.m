//
//  WKBusinessTimeManager.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKBusinessTimeManager.h"
#import "WKBusinessDayTime.h"

static NSMutableArray *businessTimeArray = nil;

@interface WKBusinessDayTime ()

//@property (nonatomic, strong) NSMutableArray * businessTimeArray;

@end

@implementation WKBusinessTimeManager


+ (WKBusinessTimeManager *)sharedManager
{
    static WKBusinessTimeManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        businessTimeArray = [NSMutableArray array];
        [self initDataArray];
    });
    return sharedManager;
}

+ (void)initDataArray
{
    NSArray *weekDayArray = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    for (NSInteger i = 0; i < 7; i++) {
        WKBusinessDayTime *businessTime = [[WKBusinessDayTime alloc] init];
        businessTime.weekday = weekDayArray[i];
        [businessTimeArray addObject:businessTime];
    }
}

- (NSMutableArray *)getBussinessTime{
    return businessTimeArray;
}

- (void)fetchBussinessTime{
    NSInteger KitchenId = [[WKKeyChain load:[NSString stringWithFormat:@"%@_KitchenId",kAPPSecurityStoreKey]] integerValue];
    NSDictionary *param = @{@"KitchenId":@(KitchenId)};
    [[WKNetworkManager sharedAuthManager] GET:@"v1/Kitchen/GetBusinessHours" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *resultArray = (NSArray *)responseObject[@"BusinessHourList"];
                if (!resultArray || [resultArray isKindOfClass:[NSNull class]]) {
                    if ([responseObject[@"ResponseCode"] isEqualToString:@"400"]) {
                        [WKKeyChain deleteUserInfo:kAPPSecurityStoreKey];
                    }
                    return;
                }
                for (NSInteger i = 0; i < resultArray.count; i++) {
                    NSDictionary *dic = resultArray[i];
                    WKBusinessDayTime *time = [self findBusinessTimeByWeekday:dic[@"Weekday"]];
                    if (time.firstBeginTime == 0) {
                        time.firstTimeId = [dic[@"Id"] integerValue];
                        time.firstBeginTime = [dic[@"TimeFromHour"] integerValue] * 60 + [dic[@"TimeFromMinute"] integerValue];
                        time.firstEndTime = [dic[@"TimeToHour"] integerValue] * 60 + [dic[@"TimeToMinute"] integerValue];
                    }else{
                        time.secondTimeId = [dic[@"Id"] integerValue];
                        time.secondBeginTime = [dic[@"TimeFromHour"] integerValue] * 60 + [dic[@"TimeFromMinute"] integerValue];
                        time.secondEndTime = [dic[@"TimeToHour"] integerValue] * 60 + [dic[@"TimeToMinute"] integerValue];
                    }
                }
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];
}

- (WKBusinessDayTime *)findBusinessTimeByWeekday:(NSString *)weekday
{
    __block WKBusinessDayTime *time;
    [businessTimeArray enumerateObjectsUsingBlock:^(WKBusinessDayTime *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.weekday isEqualToString:weekday]) {
            time = obj;
            *stop = YES;
        }
    }];
    return time;
}



@end
