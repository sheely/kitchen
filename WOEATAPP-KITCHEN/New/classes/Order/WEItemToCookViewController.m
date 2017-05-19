//
//  WEItemToCookViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEItemToCookViewController.h"
#import "WEUtil.h"
#import "WEItemToCookTableViewCell.h"
#import "WENetUtil.h"
#import "WEModelGetItemToCookList.h"
#import "MJRefresh.h"
#import "WEOrderDetailViewController.h"
#import "WEModelGetItemToCookPerOrderList.h"

@interface WEItemToCookViewController ()
{
    UIButton *_todayButton;
    UIButton *_tomorrowbutton;
    UITableView *_tableView;
    BOOL _isToday;
    WEModelGetItemToCookList *_modelToday;
    WEModelGetItemToCookList *_modelTommorrow;
    
    NSMutableArray<NSNumber *> *_todayIsExpand;
    NSMutableArray<WEModelGetItemToCookPerOrderList *> *_todayPreOrderArray;
    
    NSMutableArray<NSNumber *> *_tomorrowIsExpand;
    NSMutableArray<WEModelGetItemToCookPerOrderList *> *_tomorrowPreOrderArray;
}
@end

@implementation WEItemToCookViewController

- (void)viewDidLoad {
    _isToday = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"要做的菜";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = UICOLOR(238, 238, 238);
    [superView addSubview:leftView];
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.width.equalTo([WEUtil getScreenWidth]/4.0);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];

    superView = leftView;
    
    UIButton *button = [UIButton new];
    [button setTitle:@"今日" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top).offset(15);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo(50);
    }];
    _todayButton = button;
    
    button = [UIButton new];
    [button setTitle:@"明日" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_todayButton.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo(_todayButton.height);
    }];
    _tomorrowbutton = button;

    UIView *line = [UIView new];
    line.backgroundColor = [UIColor whiteColor];
    [superView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tomorrowbutton.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo(1);
    }];
    
    superView = self.view;
    UITableView *tableView = [UITableView new];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WEItemToCookTableViewCell class] forCellReuseIdentifier:@"WEItemToCookTableViewCell"];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_todayButton.top);
        make.left.equalTo(leftView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}


- (void)loadDataIfNeeded
{
    if (_isToday) {
        if (!_modelToday) {
            [self loadData];
        } else {
            [self loadDataSilent];
        }
    } else {
        if (!_modelTommorrow) {
            [self loadData];
        } else {
            [self loadDataSilent];
        }
    }
}

- (void)clearData
{
    if (_isToday) {
        _modelToday = nil;
        _todayIsExpand = nil;
        _todayPreOrderArray = nil;
        
    } else {
        _modelTommorrow = nil;
        _tomorrowIsExpand = nil;
        _tomorrowPreOrderArray = nil;
    }
}

- (void)initPreorderData
{
    if (_isToday) {
        _todayIsExpand = [[NSMutableArray alloc] initWithCapacity:_modelToday.ItemToCookList.count];
        for(int i=0; i<_modelToday.ItemToCookList.count; i++) {
            [_todayIsExpand addObject:@(NO)];
        }
        
        _todayPreOrderArray = [[NSMutableArray alloc] initWithCapacity:_modelToday.ItemToCookList.count];
        for(int i=0; i<_modelToday.ItemToCookList.count; i++) {
            [_todayPreOrderArray addObject:[NSNull null]];
        }
        
    } else {
        _tomorrowIsExpand = [[NSMutableArray alloc] initWithCapacity:_modelTommorrow.ItemToCookList.count];
        for(int i=0; i<_modelTommorrow.ItemToCookList.count; i++) {
            [_tomorrowIsExpand addObject:@(NO)];
        }
        
        _tomorrowPreOrderArray = [[NSMutableArray alloc] initWithCapacity:_modelTommorrow.ItemToCookList.count];
        for(int i=0; i<_modelTommorrow.ItemToCookList.count; i++) {
            [_tomorrowPreOrderArray addObject:[NSNull null]];
        }
    }
}

- (void)loadData
{
    [self clearData];
    
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"yyyy-MM-dd"];
    NSString *time;
    NSDate *now = [NSDate date];
    if (_isToday) {
        time = [output stringFromDate:now];
    } else {
        now = [now addTimeInterval:60*60*24];
        time = [output stringFromDate:now];
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取订单，请稍后...";
    [hud show:YES];
    
    [WENetUtil GetItemToCookListWithDate:time
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     JSONModelError* error = nil;
                                     NSDictionary *dict = (NSDictionary *)responseObject;
                                     WEModelGetItemToCookList *model = [[WEModelGetItemToCookList alloc] initWithDictionary:dict error:&error];
                                     if (error) {
                                         NSLog(@"error %@, model %p", error, model);
                                     }
                                     if (!model.IsSuccessful) {
                                         hud.labelText = model.ResponseMessage;
                                         [hud hide:YES afterDelay:1.5];
                                         [_tableView.mj_header endRefreshing];
                                         return;
                                     }
                                     if (_isToday) {
                                         _modelToday = model;
                                         
                                     } else {
                                         _modelTommorrow = model;
                                     }
                                     [self initPreorderData];
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


- (void)loadDataSilent
{
    [self clearData];
    
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"yyyy-MM-dd"];
    NSString *time;
    NSDate *now = [NSDate date];
    if (_isToday) {
        time = [output stringFromDate:now];
    } else {
        now = [now addTimeInterval:60*60*24];
        time = [output stringFromDate:now];
    }
    
    [WENetUtil GetItemToCookListWithDate:time
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     JSONModelError* error = nil;
                                     NSDictionary *dict = (NSDictionary *)responseObject;
                                     WEModelGetItemToCookList *model = [[WEModelGetItemToCookList alloc] initWithDictionary:dict error:&error];
                                     if (error) {
                                         NSLog(@"error %@, model %p", error, model);
                                     }
                                     if (!model.IsSuccessful) {
                                         return;
                                     }
                                     if (_isToday) {
                                         _modelToday = model;
                                         
                                     } else {
                                         _modelTommorrow = model;
                                     }
                                     [self initPreorderData];
                                     [_tableView reloadData];
                                     
                                 } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                     NSLog(@"failure %@", errorMsg);
                                 }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isToday) {
        return _modelToday.ItemToCookList.count;
    } else {
        return _modelTommorrow.ItemToCookList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = @"WEItemToCookTableViewCell";
    WEItemToCookTableViewCell *cell = [[WEItemToCookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    WEModelGetItemToCookListItemToCookList *model;
    if (_isToday) {
        model = _modelToday.ItemToCookList[indexPath.row];
    } else {
        model = _modelTommorrow.ItemToCookList[indexPath.row];
    }
    [cell setItemData:model];
    cell.itemDelegate = self;
    
    BOOL isExpand;
    if (_isToday) {
        isExpand = [_todayIsExpand[indexPath.row] boolValue];
    } else {
        isExpand = [_tomorrowIsExpand[indexPath.row] boolValue];
    }
    cell.isExpand = isExpand;
    
    WEModelGetItemToCookPerOrderList *order;
    if (_isToday) {
        order = _todayPreOrderArray[indexPath.row];
    } else {
        order = _tomorrowPreOrderArray[indexPath.row];
    }

//    if (![order isEqual:[NSNull null]]) {
        [cell setOrderData:order];
  //  }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEModelGetItemToCookPerOrderList *order;
    BOOL isExpand;
    if (_isToday) {
        isExpand = [_todayIsExpand[indexPath.row] boolValue];
        order = [_todayPreOrderArray objectAtIndex:indexPath.row];
    } else {
        isExpand = [_tomorrowIsExpand[indexPath.row] boolValue];
        order = [_tomorrowPreOrderArray objectAtIndex:indexPath.row];
    }

    float height = [WEItemToCookTableViewCell getHeightWithData:order isExpand:isExpand];
    return height;
}

- (void)buttonTapped:(UIButton *)button
{
    if (button == _todayButton) {
        _isToday = YES;
        
    } else if (button == _tomorrowbutton) {
        _isToday = NO;
    }
    if (_isToday) {
        _todayButton.backgroundColor = [UIColor whiteColor];
        _tomorrowbutton.backgroundColor = [UIColor clearColor];
    } else {
        _todayButton.backgroundColor = [UIColor clearColor];
        _tomorrowbutton.backgroundColor = [UIColor whiteColor];
    }
    [self loadDataIfNeeded];
}


- (void)loadOrderData:(NSString *)itemId index:(int)index
{
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"yyyy-MM-dd"];
    NSString *time;
    NSDate *now = [NSDate date];
    if (_isToday) {
        time = [output stringFromDate:now];
    } else {
        now = [now addTimeInterval:60*60*24];
        time = [output stringFromDate:now];
    }

    BOOL isToday = _isToday;
    [WENetUtil GetItemToCookPerOrderListWithItemId:itemId
                                              Date:time
                                           success:^(NSURLSessionDataTask *task, id responseObject) {
                                               JSONModelError* error = nil;
                                               NSDictionary *dict = (NSDictionary *)responseObject;
                                               WEModelGetItemToCookPerOrderList *model = [[WEModelGetItemToCookPerOrderList alloc] initWithDictionary:dict error:&error];
                                               if (error) {
                                                   NSLog(@"error %@, model %p", error, model);
                                               }
                                               if (!model.IsSuccessful) {
                                                   return;
                                               }
                                               if (isToday) {
                                                   _todayPreOrderArray[index] = model;
                                               } else {
                                                   _tomorrowPreOrderArray[index] = model;
                                               }
                                              // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                                              // [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                               [_tableView reloadData];
                                               
                                           } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                               
                                           }];
    
}

- (void)cellArrowTapped:(WEItemToCookTableViewCell *)cell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath) {
        WEModelGetItemToCookListItemToCookList *model;
        if (_isToday) {
            model = _modelToday.ItemToCookList[indexPath.row];
            BOOL isExpand = [_todayIsExpand[indexPath.row] boolValue];
            isExpand = !isExpand;
            _todayIsExpand[indexPath.row] = @(isExpand);
            if (isExpand) {
                WEModelGetItemToCookPerOrderList *order = [_todayPreOrderArray objectAtIndex:indexPath.row];
                if ([order isEqual:[NSNull null]]) {
                    [self loadOrderData:model.ItemId index:indexPath.row];
                }
            }
            
            
        } else {
            model = _modelTommorrow.ItemToCookList[indexPath.row];
            BOOL isExpand = [_tomorrowIsExpand[indexPath.row] boolValue];
            isExpand = !isExpand;
            _tomorrowIsExpand[indexPath.row] = @(isExpand);
            if (isExpand) {
                WEModelGetItemToCookPerOrderList *order = [_tomorrowPreOrderArray objectAtIndex:indexPath.row];
                if ([order isEqual:[NSNull null]]) {
                    [self loadOrderData:model.ItemId index:indexPath.row];
                }
            }
        }
        
        
       // [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [_tableView reloadData];
    }
}

- (void)cellOrderButtonTapped:(NSString *)orderId
{
    WEOrderDetailViewController *c = [WEOrderDetailViewController new];
    c.orderId = orderId;
    c.parentController = self;
    [self.navigationController pushViewController:c animated:YES];
}

@end
