//
//  WETodayOrderListViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WETodayOrderListViewController.h"
#import "WENetUtil.h"
#import "WEModelGetOrderListToday.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"
#import "WETodayOrderTableViewCell.h"
#import "WEOrderFilterView.h"
#import "WEOrderStatus.h"
#import "WEOrderDetailViewController.h"
#import "MJRefresh.h"

#define HEADER_HEIGHT 35

@interface WETodayOrderListViewController ()
{
    UIView *_topView;
    MASConstraint *_topHeightConstraint;
    
    UITableView *_tableView;
    WEModelGetOrderListToday *_model;
    WEOrderFilterView *_filterView;
    
    UILabel *_tip1;
    
    int _checkIndex1;
    int _checkIndex2;
    int _checkIndex3;
}
@end

@implementation WETodayOrderListViewController

- (void)viewDidLoad {
    _checkIndex1 = -1;
    _checkIndex2 = -1;
    _checkIndex3 = 0;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    if (_type == TodayOrderListViewController_Today) {
        self.title = @"今日订单";
    } else if (_type == TodayOrderListViewController_Tomorrow) {
        self.title = @"明日订单";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *superView = self.view;
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor clearColor];
    [superView addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(superView.top);
        _topHeightConstraint = make.height.equalTo(HEADER_HEIGHT);
    }];
    _topView = topView;
    
    UIButton *header = [UIButton new];
    header.backgroundColor = UICOLOR(221, 221, 221);
    [header addTarget:self action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:header];
    [header makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(topView.top);
        make.height.equalTo(HEADER_HEIGHT);
    }];
    
    
    UILabel *tip = [UILabel new];
    tip.textColor = [UIColor blackColor];
    tip.font = [UIFont boldSystemFontOfSize:14];
    tip.textAlignment = NSTextAlignmentLeft;
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 1;
    [superView addSubview:tip];
    [tip sizeToFit];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.centerY);
        make.left.equalTo(header.left).offset(15);
    }];
    tip.text = @"+ 过滤订单";
    
    UILabel *tip1 = [UILabel new];
    tip1.textColor = [UIColor whiteColor];
    tip1.textAlignment = NSTextAlignmentRight;
    tip1.font = [UIFont boldSystemFontOfSize:14];
    tip1.backgroundColor = [UIColor clearColor];
    tip1.numberOfLines = 1;
    [superView addSubview:tip1];
    [tip1 sizeToFit];
    [tip1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.centerY);
        make.right.equalTo(header.right).offset(-20);
    }];
    tip1.text = @"点击设置过滤条件";
    _tip1 = tip1;
    
    _filterView = [WEOrderFilterView new];
    [superView addSubview:_filterView];
    [_filterView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(topView.bottom);
        make.right.equalTo(superView.right);
    }];
    _filterView.hidden = YES;
    _filterView.check1 = -1;
    _filterView.check2 = -1;
    _filterView.check3 = 0;
    _filterView.filterDelegate = self;
    
//    UIButton *button = [UIButton new];
//    [button setTitle:@"确定" forState:UIControlStateNormal];
//    [button setTitleColor:UICOLOR(0, 0, 0) forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    [button addTarget:self action:@selector(okButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [superView addSubview:button];
//    [button sizeToFit];
//    [button makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(header.centerY);
//        make.right.equalTo(header.right).offset(-20);
//    }];
//    _okButton = button;
//    _okButton.hidden = YES;
//    
//    button = [UIButton new];
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    [button setTitleColor:UICOLOR(0, 0, 0) forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    [superView addSubview:button];
//    [button sizeToFit];
//    [button makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(header.centerY);
//        make.right.equalTo(_okButton.left).offset(-30);
//    }];
//    _cancelButton = button;
//    _cancelButton.hidden = YES;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WETodayOrderTableViewCell class] forCellReuseIdentifier:@"WETodayOrderTableViewCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.bottom).offset(20);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];


}

- (void)loadDataIfNeeded
{
    if (!_model) {
        [self loadData];
    } else {
        [self loadDataSilent];
    }
}


- (void)loadData
{
    NSArray *statusArray = @[WEOrderStatus_NEW,
                             WEOrderStatus_ACCEPTED,
                             WEOrderStatus_COMPLETED,
                             WEOrderStatus_REFUNDING];
    NSArray *deliverArray = @[@"PICKUP",
                             @"DELIVER"];
    NSArray *sortArray = @[@"TIME_ORDERED",
                              @"TIME_REQUESTED"];
    NSString *status = @"";
    NSString *deliver = @"";
    NSString *sort = @"";
    if (_checkIndex1>=0 && _checkIndex1<statusArray.count) {
        status = statusArray[_checkIndex1];
    }
    if (_checkIndex2>=0 && _checkIndex2<deliverArray.count) {
        deliver = deliverArray[_checkIndex2];
    }
    if (_checkIndex3>=0 && _checkIndex3<sortArray.count) {
        sort = sortArray[_checkIndex3];
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取订单，请稍后...";
    [hud show:YES];
    
    if (_type == TodayOrderListViewController_Today) {
        [WENetUtil GetOrderListTodayWithOrderStatus:status
                                     DispatchMethod:deliver
                                            OrderBy:sort
                                           OrderDir:@""
                                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                                JSONModelError* error = nil;
                                                NSDictionary *dict = (NSDictionary *)responseObject;
                                                WEModelGetOrderListToday *model = [[WEModelGetOrderListToday alloc] initWithDictionary:dict error:&error];
                                                if (error) {
                                                    NSLog(@"error %@, model %p", error, model);
                                                }
                                                if (!model.IsSuccessful) {
                                                    hud.labelText = model.ResponseMessage;
                                                    [hud hide:YES afterDelay:1.5];
                                                     [_tableView.mj_header endRefreshing];
                                                    return;
                                                }
                                                _model = model;
                                                [_tableView reloadData];
                                                [hud hide:YES afterDelay:0];
                                                 [_tableView.mj_header endRefreshing];
                                                
                                            } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                NSLog(@"failure %@", errorMsg);
                                                hud.labelText = errorMsg;
                                                [hud hide:YES afterDelay:1.5];
                                                 [_tableView.mj_header endRefreshing];
                                            }];
    
    } else if (_type == TodayOrderListViewController_Tomorrow) {
        [WENetUtil GetOrderListTomorrowWithOrderStatus:status
                                     DispatchMethod:deliver
                                            OrderBy:sort
                                           OrderDir:@""
                                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                                JSONModelError* error = nil;
                                                NSDictionary *dict = (NSDictionary *)responseObject;
                                                WEModelGetOrderListToday *model = [[WEModelGetOrderListToday alloc] initWithDictionary:dict error:&error];
                                                if (error) {
                                                    NSLog(@"error %@, model %p", error, model);
                                                }
                                                if (!model.IsSuccessful) {
                                                    hud.labelText = model.ResponseMessage;
                                                    [hud hide:YES afterDelay:1.5];
                                                     [_tableView.mj_header endRefreshing];
                                                    return;
                                                }
                                                _model = model;
                                                [_tableView reloadData];
                                                [hud hide:YES afterDelay:0];
                                                 [_tableView.mj_header endRefreshing];
                                                
                                            } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                NSLog(@"failure %@", errorMsg);
                                                hud.labelText = errorMsg;
                                                [hud hide:YES afterDelay:1.5];
                                                 [_tableView.mj_header endRefreshing];
                                            }];

        
    }
   
}

- (void)loadDataSilent
{
    if (!_model) {
        return;
    }
    
    NSArray *statusArray = @[WEOrderStatus_NEW,
                             WEOrderStatus_ACCEPTED,
                             WEOrderStatus_COMPLETED,
                             WEOrderStatus_REFUNDING];
    NSArray *deliverArray = @[@"PICKUP",
                              @"DELIVER"];
    NSArray *sortArray = @[@"TIME_ORDERED",
                           @"TIME_REQUESTED"];
    NSString *status = @"";
    NSString *deliver = @"";
    NSString *sort = @"";
    if (_checkIndex1>=0 && _checkIndex1<statusArray.count) {
        status = statusArray[_checkIndex1];
    }
    if (_checkIndex2>=0 && _checkIndex2<deliverArray.count) {
        deliver = deliverArray[_checkIndex2];
    }
    if (_checkIndex3>=0 && _checkIndex3<sortArray.count) {
        sort = sortArray[_checkIndex3];
    }
    
    if (_type == TodayOrderListViewController_Today) {
        [WENetUtil GetOrderListTodayWithOrderStatus:status
                                     DispatchMethod:deliver
                                            OrderBy:sort
                                           OrderDir:@""
                                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                                JSONModelError* error = nil;
                                                NSDictionary *dict = (NSDictionary *)responseObject;
                                                WEModelGetOrderListToday *model = [[WEModelGetOrderListToday alloc] initWithDictionary:dict error:&error];
                                                if (error) {
                                                    NSLog(@"error %@, model %p", error, model);
                                                }
                                                if (!model.IsSuccessful) {
                                                    return;
                                                }
                                                _model = model;
                                                [_tableView reloadData];
                                                
                                            } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                NSLog(@"failure %@", errorMsg);
                                            }];
        
    } else if (_type == TodayOrderListViewController_Tomorrow) {
        [WENetUtil GetOrderListTomorrowWithOrderStatus:status
                                        DispatchMethod:deliver
                                               OrderBy:sort
                                              OrderDir:@""
                                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                                   JSONModelError* error = nil;
                                                   NSDictionary *dict = (NSDictionary *)responseObject;
                                                   WEModelGetOrderListToday *model = [[WEModelGetOrderListToday alloc] initWithDictionary:dict error:&error];
                                                   if (error) {
                                                       NSLog(@"error %@, model %p", error, model);
                                                   }
                                                   if (!model.IsSuccessful) {
                                                        return;
                                                   }
                                                   _model = model;
                                                   [_tableView reloadData];
                                               } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                   NSLog(@"failure %@", errorMsg);
                                               }];
        
    }
}


- (id)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    return [_model.OrderList objectAtIndex:indexPath.row];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row = _model.OrderList.count;
    return row;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WETodayOrderTableViewCell";
    WETodayOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WETodayOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    id model = [self getModelAtIndexPath:indexPath];
    [cell setData:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEModelGetOrderListTodayOrderList * model = [self getModelAtIndexPath:indexPath];
    
    WEOrderDetailViewController *c = [WEOrderDetailViewController new];
    c.orderId = model.Id;
    c.parentController = self;
    [self.navigationController pushViewController:c animated:YES];

}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    float height = 20;
//    if (!_filterView.hidden) {
//        height = [_filterView getHeight];
//    }
//    return height;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (_filterView.hidden) {
//        UIView *empty = [UIView new];
//        empty.backgroundColor = [UIColor clearColor];
//        return empty;
//        
//    } else {
//        return _filterView;
//    }
//    
//}

- (void)headerTapped:(UIButton *)button
{
    if (_filterView.hidden) {
        _filterView.hidden = NO;
        _filterView.check1 = _checkIndex1;
        _filterView.check2 = _checkIndex2;
        _filterView.check3 = _checkIndex3;
        _filterView.hidden = NO;
        _tip1.text = @"点击取消过滤条件";
        _topHeightConstraint.equalTo(HEADER_HEIGHT + _filterView.getHeight);
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];

    } else {
        _tip1.text = @"点击设置过滤条件";
        _topHeightConstraint.equalTo(HEADER_HEIGHT);
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _filterView.hidden = YES;
        }];
    }
}

- (void)okButtonTapped:(UIButton *)button
{
    _checkIndex1 = _filterView.check1;
    _checkIndex2 = _filterView.check2;
    _checkIndex3 = _filterView.check3;
    _tip1.text = @"点击设置过滤条件";
    [_tableView reloadData];
    [self loadData];
    _topHeightConstraint.equalTo(HEADER_HEIGHT);
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _filterView.hidden = YES;
    }];
}

//- (void)cancelButtonTapped:(UIButton *)button
//{
//    _filterView.hidden = YES;
//    _tip1.text = @"点击设置过滤条件";
//    [_tableView reloadData];
//    _topHeightConstraint.equalTo(HEADER_HEIGHT);
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        
//    }];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
