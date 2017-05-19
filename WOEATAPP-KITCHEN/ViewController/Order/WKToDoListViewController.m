//
//  WKToDoListViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/20.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKToDoListViewController.h"
#import "WKOrderType0TableViewCell.h"
#import "WKOrderType1TableViewCell.h"
#import "WKOrderType2TableViewCell.h"
#import "WKOrderTableHeaderView.h"
#import "WKOrderFilterTableViewCell.h"

#import "OrderModel.h"
#import "WKPagesViewController.h"
#import "WKPageContentViewController.h"
#import "NSDate+Time.h"
#import "WKBusinessDayTime.h"

static NSInteger requestCount;
@interface WKToDoListViewController ()<MultiplePagesViewControllerDelegate>{
    
    NSInteger todayFirstId;
    NSInteger todaySecondId;
    NSInteger tomorrowFirstId;
    NSInteger tomorrowSecondId;
    WKBusinessDayTime *todayTime;
    WKBusinessDayTime *tomorrowTime;
    BOOL isSuccess;
}
@property (strong, nonatomic) WKPagesViewController *multiplePagesViewController;
@property (strong, nonatomic) NSArray *itemList;
@property (strong, nonatomic) NSMutableArray *bussinessTimeList;

@end

@implementation WKToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.multiplePagesViewController.view];
    [self addChildViewController:self.multiplePagesViewController];
    _bussinessTimeList = [[NSMutableArray alloc]init];
    _itemList = [NSArray new];
    [self getBusinessTime];
    [self addDefaultPageViewControllers];
    requestCount = 0;
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

-(void)getBusinessTime{
    [_bussinessTimeList removeAllObjects];
    NSMutableArray *array = [[WKBusinessTimeManager sharedManager] getBussinessTime];
    NSString *today = [NSDate weekdayStringFromDate:[NSDate date]];
    NSString *tomorrow = [NSDate weekdayStringFromDate:[NSDate dateTomorrow]];

    
    for (WKBusinessDayTime *dayTime in array) {
        if (dayTime.weekday && [dayTime.weekday isEqualToString:today]) {
            todayTime = dayTime;
            todayFirstId = dayTime.firstTimeId;
            todaySecondId = dayTime.secondTimeId;
            if (todayFirstId != 0) {
                [_bussinessTimeList addObject:@(todayFirstId)];
                isSuccess = YES;

            }else{
                [_bussinessTimeList addObject:@(0)];

            }
            if (todaySecondId != 0) {
                [_bussinessTimeList addObject:@(todaySecondId)];
                isSuccess = YES;

            }else{
                [_bussinessTimeList addObject:@(0)];
            }
        }
        if (dayTime.weekday && [dayTime.weekday isEqualToString:tomorrow]) {
            tomorrowTime = dayTime;
            tomorrowFirstId = dayTime.firstTimeId;
            tomorrowSecondId = dayTime.secondTimeId;
            if (todayFirstId != 0) {
                [_bussinessTimeList addObject:@(tomorrowFirstId)];
                isSuccess = YES;

            }else{
                [_bussinessTimeList addObject:@(0)];
 
            }
            if (todaySecondId != 0) {
                [_bussinessTimeList addObject:@(tomorrowSecondId)];
                isSuccess = YES;

            }else{
                [_bussinessTimeList addObject:@(0)];

            }
        }
    }
    //重试机制 5次重试机会
    if (!isSuccess && requestCount < 5) {
        requestCount ++ ;
        __weak typeof (self) weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf getBusinessTime];
            [weakSelf addDefaultPageViewControllers];
        });
        return;
    }
}


- (void)addDefaultPageViewControllers {
    NSInteger vcCount = _bussinessTimeList.count;
    for (NSInteger i = 0; i < vcCount; i++) {
        
        WKPageContentViewController *vc = [[WKPageContentViewController alloc] init];
        switch (i) {
            case 0:
                if (todayTime.firstTimeId == 0) {
                    continue;
                }
                vc.dayTimeId = todayTime.firstTimeId;
                vc.pageTitle = [NSString stringWithFormat:@"今日营业时间1   %@ - %@",[self timeToString:todayTime.firstBeginTime],[self timeToString:todayTime.firstEndTime]];
                break;
            case 1:
                if (todayTime.secondTimeId == 0) {
                    continue;
                }
                vc.dayTimeId = todayTime.secondTimeId;
                vc.pageTitle = [NSString stringWithFormat:@"今日营业时间2   %@ - %@",[self timeToString:todayTime.secondBeginTime],[self timeToString:todayTime.secondEndTime]];
                break;
            case 2:
                if (tomorrowTime.firstTimeId == 0) {
                    continue;
                }
                vc.dayTimeId = tomorrowTime.firstTimeId;
                vc.pageTitle = [NSString stringWithFormat:@"明日营业时间2   %@ - %@",[self timeToString:tomorrowTime.firstBeginTime],[self timeToString:tomorrowTime.firstEndTime]];
                break;
            case 3:
                if (tomorrowTime.secondTimeId == 0) {
                    continue;
                }
                vc.dayTimeId = tomorrowTime.secondTimeId;
                vc.pageTitle = [NSString stringWithFormat:@"明日营业时间2   %@ - %@",[self timeToString:tomorrowTime.secondBeginTime],[self timeToString:tomorrowTime.secondEndTime]];
                break;
                
            default:
                break;
        }
        [self.multiplePagesViewController addViewController:vc];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.multiplePagesViewController.view.frame = self.view.bounds;
}

#pragma mark - <MultiplePagesViewControllerDelegate>

- (void)pageChangedTo:(NSInteger)pageIndex {
    // do something when page changed in MultiplePagesViewController
}


#pragma mark - getters and setters
- (WKPagesViewController*)multiplePagesViewController {
    if (!_multiplePagesViewController) {
        _multiplePagesViewController = [[WKPagesViewController alloc] init];
        _multiplePagesViewController.view.frame = self.view.frame;
        _multiplePagesViewController.delegate = self;
    }
    
    return _multiplePagesViewController;
}

- (NSString *)timeToString:(NSInteger)time
{
    return  [NSString stringWithFormat:@"%.2d:%.2d",(int)(time/ 60), (int)(time% 60) ];
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
