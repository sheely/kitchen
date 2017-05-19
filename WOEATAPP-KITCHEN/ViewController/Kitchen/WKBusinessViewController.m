//
//  WKBusinessViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/24.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKBusinessViewController.h"
#import "WKBusinessTimeCell.h"
#import "WKBusinessDayTime.h"
#import "X1DatePickerView.h"
#import "WENetUtil.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"
#import "MBProgressHUD.h"
#import "WEModelCommon.h"

@interface WKBusinessViewController ()<UITableViewDataSource,UITableViewDelegate,X1DatePickerViewDelegate,WKBusinessTimeCellDelegate>

@property (nonatomic, strong) UITableView *businessTableView;
@property (nonatomic, strong) NSMutableArray *businessTimeArray;
@property (nonatomic, strong) X1DatePickerView *timePicker;
@property (nonatomic, strong) WKBusinessDayTime *curEditTime;//当前编辑的某天
@property (nonatomic, assign) NSInteger curTag;//当前编辑某一天的第几个时间段

@end

@implementation WKBusinessViewController

- (void)loadView
{
    [super loadView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"营业时间";

    [self.view addSubview:self.businessTableView];
    [self.view addSubview:self.timePicker];

    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveBusinessTime:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    _businessTimeArray = [NSMutableArray array];
    [self initArray];
}

- (void)initArray
{
    [_businessTimeArray removeAllObjects];
    NSArray *weekDayArray = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    NSArray *weekDayArrayDisplay = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    for (NSInteger i = 0; i < 7; i++) {
        WKBusinessDayTime *businessTime = [[WKBusinessDayTime alloc] init];
        businessTime.weekday = weekDayArray[i];
        businessTime.weekdayDisplay = weekDayArrayDisplay[i];
        [_businessTimeArray addObject:businessTime];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _businessTimeArray = [[WKBusinessTimeManager sharedManager] getBussinessTime];
//    [self.businessTableView reloadData];
    [self loadBusinessTime];
}

- (WKBusinessDayTime *)findBusinessTimeByWeekday:(NSString *)weekday
{
    __block WKBusinessDayTime *time;
    [_businessTimeArray enumerateObjectsUsingBlock:^(WKBusinessDayTime *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.weekday isEqualToString:weekday]) {
            time = obj;
            *stop = YES;
        }
    }];
    return time;
}

- (BOOL)isTimeIsValid:(WKBusinessDayTime *)time tag:(int)tag
{
    if (tag == 0 || tag == 1) {
        if (time.firstBeginTime==0 && time.firstEndTime==0) {
            return NO;
        }
    }
    if (tag == 2 || tag == 3) {
        if (time.secondBeginTime==0 && time.secondEndTime==0) {
            return NO;
        }
    }
    return YES;
}

- (void)loadBusinessTime
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取营业时间，请稍后...";
    [hud show:YES];
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    [WENetUtil GetBusinessHoursWithKitchenId:model.Kitchen.Id
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         [hud hide:YES afterDelay:0];
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             NSArray *resultArray = (NSArray *)responseObject[@"BusinessHourList"];
                                             if (!resultArray || [resultArray isKindOfClass:[NSNull class]]) {
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
                                             [_businessTableView reloadData];
                                         }
                                         
                                         
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                         hud.labelText = errorMsg;
                                         [hud hide:YES afterDelay:1.5];
                                     }];
    
}


- (UITableView *)businessTableView
{
    if (_businessTableView == nil) {
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _businessTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY) style:UITableViewStylePlain];
        _businessTableView.dataSource = self;
        _businessTableView.delegate = self;
        _businessTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _businessTableView.separatorColor = [UIColor colorWithHexString:@"#F7D598" andAlpha:1.0];
        _businessTableView.tableFooterView = [[UIView alloc] init];
        if ([_businessTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_businessTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _businessTableView;
}

- (X1DatePickerView *)timePicker
{
    if (_timePicker == nil) {
        _timePicker = [[X1DatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 0, 260)];
        _timePicker.pickerMode = UIDatePickerModeTime;
        _timePicker.delegate = self;
    }
    return _timePicker;
}

- (UIView *)creatViewWithTitle:(NSString *)title
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7" andAlpha:1.0];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width - 40, 30)];
    labTitle.text = title;
    labTitle.textColor = [UIColor blackColor];
    [backView addSubview:labTitle];
    return backView;
}


- (void)loadSilent
{
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    [WENetUtil GetBusinessHoursWithKitchenId:model.Kitchen.Id
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             NSArray *resultArray = (NSArray *)responseObject[@"BusinessHourList"];
                                             if (!resultArray || [resultArray isKindOfClass:[NSNull class]]) {
                                                 MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                                 hud.labelText = @"重置失败";
                                                 [hud hide:YES afterDelay:1.0];
                                                 return;
                                             }
                                             [self initArray];
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
                                             [_businessTableView reloadData];
                                         }
                                         MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                         hud.labelText = @"重置成功";
                                         [hud hide:YES afterDelay:1.0];
                                         
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                         MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                         hud.labelText = @"重置失败";
                                         [hud hide:YES afterDelay:1.0];

                                     }];
    
}

- (void)allReset:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在重置营业时间，请稍后...";
    [hud show:YES];
    
    [WENetUtil ClearBusinessHoursWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        if ([[dict objectForKey:@"IsSuccessful"] integerValue] == 1) {
            [self loadSilent];
        } else {
            hud.labelText = @"重置失败";
            [hud hide:YES afterDelay:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];

    }];
}

- (UIButton *)creatResetButton
{
    UIButton *button = [UIButton new];
    [button setTitle:@"重置全部时间" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(allReset:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(screen_width - 120, 0, 100, 30);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}

#pragma mark- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"开店时间"]];
        [cell addSubview:[self creatResetButton]];
        
        UILabel *labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, screen_width - 40, 60)];
        labelDesc.text = @"设置时间为您可以进行做饭的时间。如8：00开始营业，用户最早就餐时间为8：45，22：00休息，用户最晚就餐时间为22：45";
        labelDesc.font = [UIFont systemFontOfSize:13];
        labelDesc.numberOfLines = 0;
        [cell addSubview:labelDesc];
        
    }else{
        WKBusinessDayTime *time = self.businessTimeArray[indexPath.row - 1];
        WKBusinessTimeCell *timeCell = [[WKBusinessTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeCell"];
        timeCell.delegate = self;
        [timeCell loadData:time];
        cell = timeCell;
    }
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 90;
            break;
        default:
            height = 82;
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)saveBusinessTime:(id)sender{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //NSInteger KitchenId = [[WKKeyChain load:[NSString stringWithFormat:@"%@_KitchenId",kAPPSecurityStoreKey]] integerValue];

    NSMutableArray *hourList = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i++) {
        WKBusinessDayTime *time = self.businessTimeArray[i];
        NSDictionary *dicBegin = @{@"Weekday":time.weekday,
                              @"TimeFromHour":@(time.firstBeginTime / 60),
                              @"TimeFromMinute":@(time.firstBeginTime % 60),
                              @"TimeToHour":@(time.firstEndTime / 60),
                              @"TimeToMinute":@(time.firstEndTime % 60)};
        [hourList addObject:dicBegin];
        
        NSDictionary *dicEnd = @{@"Weekday":time.weekday,
                              @"TimeFromHour":@(time.secondBeginTime / 60),
                              @"TimeFromMinute":@(time.secondBeginTime % 60),
                              @"TimeToHour":@(time.secondEndTime / 60),
                              @"TimeToMinute":@(time.secondEndTime % 60)};
        [hourList addObject:dicEnd];
    }
    
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    NSString *jsonList = [self arrayToJsonString:hourList];
   // [param setObject:@(KitchenId) forKey:@"KitchenId"];
    //[param setObject:jsonList forKey:@"BusinessHourList"];

    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在保存营业时间，请稍后...";
    [hud show:YES];
    [WENetUtil SetBusinessHoursWithKitchenId:model.Kitchen.Id
                            BusinessHourList:jsonList
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         NSDictionary *dict = (NSDictionary *)responseObject;
                                         JSONModelError* error = nil;
                                         WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                         if (error) {
                                             NSLog(@"error %@", error);
                                         }
                                         if (!res.IsSuccessful) {
                                             hud.labelText = res.ResponseMessage;
                                             [hud hide:YES afterDelay:1.5];
                                             return;
                                         }
                                         hud.labelText = @"保存成功";
                                         hud.delegate = self;
                                         [hud hide:YES afterDelay:1.0];
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                         hud.labelText = errorMsg;
                                         [hud hide:YES afterDelay:1.5];
                                     }];
    
//    WS(ws);
//    [[WKNetworkManager sharedAuthManager] POST:@"v1/Kitchen/SetBusinessHours" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        [YRToastView showMessage:@"时间设置成功" inView:self.view];
////        [ws.navigationController popViewControllerAnimated:YES];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)arrayToJsonString:(NSMutableArray *)array
{
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}


- (void)tapToChooseTime:(WKBusinessDayTime *)businessTime tag:(NSInteger)tag
{
    self.curEditTime = businessTime;
    self.curTag = tag;
    NSInteger time = 0;
    if (tag == 0) {
        time = businessTime.firstBeginTime;
    }else if(tag == 1){
        time = businessTime.firstEndTime;
    }else if(tag == 2){
        time = businessTime.secondBeginTime;
    }else if(tag == 3){
        time = businessTime.secondEndTime;
    }
    
    if (![self isTimeIsValid:businessTime tag:tag]) {
        if (tag == 0) {
            time = 60 * 11;
        } else if (tag == 1) {
            time = 60 * 14;
        } else if (tag == 2) {
            time = 60 * 17;
        } else if (tag == 3) {
            time = 60 * 21;
        }
    } else {
        if (tag == 1 && businessTime.firstEndTime==0 && businessTime.firstBeginTime) {
            time = businessTime.firstBeginTime +  60*3;
            if (time >= 60*24) {
                time = 60 * 24-1;
            }
        }
        if (tag == 3 && businessTime.secondEndTime==0 && businessTime.secondBeginTime) {
            time = businessTime.secondBeginTime +  60*5;
            if (time >= 60*24) {
                time = 60 * 24-1;
            }
        }
    }
    
    NSString *strDate = [NSString stringWithFormat:@"%.2d:%.2d",(int)(time/ 60), (int)(time% 60) ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"]];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSDate *startDate = [dateFormatter dateFromString:strDate];
    [self.timePicker setPickerData:startDate];
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.timePicker.frame = CGRectMake(0, weakSelf.view.frame.size.height - 260, screen_width, 260);
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - datePicker delegate methods
- (void)saveSelectedDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"]];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    NSDateComponents *startcomponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.timePicker.frame = CGRectMake(0, weakSelf.view.frame.size.height, screen_width, 260);
    } completion:^(BOOL finished) {
    }];
    
    NSInteger time = [startcomponents hour] * 60 + [startcomponents minute];
    if (self.curTag == 0) {
        self.curEditTime.firstBeginTime = time;
    }else if (self.curTag == 1) {
        self.curEditTime.firstEndTime = time;
    }else if (self.curTag == 2) {
        self.curEditTime.secondBeginTime = time;
    }else if (self.curTag == 3) {
        self.curEditTime.secondEndTime = time;
    }
    
    [self.businessTableView reloadData];
}

- (void)cancelSelectedDate
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.timePicker.frame = CGRectMake(0, weakSelf.view.frame.size.height, screen_width, 260);
    } completion:^(BOOL finished) {
    }];
}

@end
