//
//  WEOrderDetailViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/7.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEOrderDetailViewController.h"
#import "WENetUtil.h"
#import "WEModelGetOrder.h"
#import "WEOrderStatus.h"
#import "WETwoColumnListView.h"
#import "WEUtil.h"
#import "WEOrderDishListView.h"

@interface WEOrderDetailViewController ()
{
    UITableView *_tableView;
    WEModelGetOrder *_model;
}
@end

@implementation WEOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"订单详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *superView = self.view;
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    tableView.scrollEnabled = YES;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(superView.bottom);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    
    [self loadData];
}

- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取订单，请稍后...";
    [hud show:YES];
    
    [WENetUtil GetOrderWithOrderId:_orderId
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               JSONModelError* error = nil;
                               NSDictionary *dict = (NSDictionary *)responseObject;
                               WEModelGetOrder *model = [[WEModelGetOrder alloc] initWithDictionary:dict error:&error];
                               if (error) {
                                   NSLog(@"error %@, model %p", error, model);
                               }
                               if (!model.IsSuccessful) {
                                   hud.labelText = model.ResponseMessage;
                                   [hud hide:YES afterDelay:1.5];
                                   return;
                               }
                               _model = model;
                               [_tableView reloadData];
                               [hud hide:YES afterDelay:0];
                               
                           } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                               NSLog(@"failure %@", errorMsg);
                               hud.labelText = errorMsg;
                               [hud hide:YES afterDelay:1.5];
                           }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *superView = cell.contentView;
    float offsetX = 20;
    
    if (indexPath.row == 0) {
        superView.backgroundColor = UICOLOR(247, 247, 247);
        UILabel *t1 = [UILabel new];
        t1.backgroundColor = [UIColor clearColor];
        t1.font = [UIFont systemFontOfSize:13];
        t1.textColor = [UIColor blackColor];
        [superView addSubview:t1];
        [t1 sizeToFit];
        [t1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
        }];
        if (_model.Order.Id)
            t1.text = [NSString stringWithFormat:@"订单号 %@", _model.Order.Id];
        
        UILabel *t2 = [UILabel new];
        t2.backgroundColor = [UIColor clearColor];
        t2.font = [UIFont systemFontOfSize:13];
        t2.textColor = UICOLOR(34, 215, 66);
        [superView addSubview:t2];
        [t2 sizeToFit];
        [t2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-15);
            make.centerY.equalTo(superView.centerY);
        }];
        if (_model.Order.OrderStatus)
            t2.text = [WEOrderStatus getDesc:_model.Order.OrderStatus];
    
    } else if (indexPath.row == 1) {
        UIColor *gray = UICOLOR(68, 68, 68);
        NSArray *leftArray = @[@"饭", @"友", @"电", @"话", @"送餐时间", @"配送地址"];
        
        UILabel *t1 = [UILabel new];
        t1.backgroundColor = [UIColor clearColor];
        t1.font = [UIFont systemFontOfSize:13];
        t1.textColor = gray;
        [superView addSubview:t1];
        [t1 sizeToFit];
        [t1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(superView.top).offset(10);
        }];
        t1.text = leftArray[0];
        
        UILabel *t2 = [UILabel new];
        t2.backgroundColor = [UIColor clearColor];
        t2.font = [UIFont systemFontOfSize:13];
        t2.textColor = gray;
        [superView addSubview:t2];
        [t2 sizeToFit];
        [t2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(t1.top);
        }];
        t2.text = leftArray[1];
        
        UILabel *t3 = [UILabel new];
        t3.backgroundColor = [UIColor clearColor];
        t3.font = [UIFont systemFontOfSize:13];
        t3.textColor = gray;
        [superView addSubview:t3];
        [t3 sizeToFit];
        [t3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(t1.left);
            make.top.equalTo(t1.bottom).offset(10);
        }];
        t3.text = leftArray[2];

        UILabel *t4 = [UILabel new];
        t4.backgroundColor = [UIColor clearColor];
        t4.font = [UIFont systemFontOfSize:13];
        t4.textColor = gray;
        [superView addSubview:t4];
        [t4 sizeToFit];
        [t4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(t3.top);
            make.right.equalTo(t2.right);
        }];
        t4.text = leftArray[3];
        
        UILabel *t5 = [UILabel new];
        t5.backgroundColor = [UIColor clearColor];
        t5.font = [UIFont systemFontOfSize:13];
        t5.textColor = gray;
        [superView addSubview:t5];
        [t5 sizeToFit];
        [t5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(t3.bottom).offset(10);
            make.left.equalTo(t1.left);
            make.right.equalTo(t2.right);
        }];
        t5.text = leftArray[4];
        
        UILabel *t6 = [UILabel new];
        t6.backgroundColor = [UIColor clearColor];
        t6.font = [UIFont systemFontOfSize:13];
        t6.textColor = gray;
        [superView addSubview:t6];
        [t6 sizeToFit];
        [t6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(t5.bottom).offset(10);
            make.left.equalTo(t1.left);
            make.right.equalTo(t5.right);
        }];
        t6.text = leftArray[5];

        UILabel *m1 = [UILabel new];
        m1.backgroundColor = [UIColor clearColor];
        m1.font = [UIFont systemFontOfSize:13];
        m1.textColor = [UIColor blackColor];
        [superView addSubview:m1];
        [m1 sizeToFit];
        [m1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(t2.right).offset(20);
            make.centerY.equalTo(t2.centerY);
        }];
        if (_model.Order.UserDisplayName)
            m1.text = _model.Order.UserDisplayName;
        
        UILabel *m2 = [UILabel new];
        m2.backgroundColor = [UIColor clearColor];
        m2.font = [UIFont systemFontOfSize:13];
        m2.textColor = [UIColor blackColor];
        [superView addSubview:m2];
        [m2 sizeToFit];
        [m2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m1.left);
            make.centerY.equalTo(t4.centerY);
        }];
        if (_model.Order.ContactNumber)
            m2.text = _model.Order.ContactNumber;
        
        UILabel *m3 = [UILabel new];
        m3.backgroundColor = [UIColor clearColor];
        m3.font = [UIFont systemFontOfSize:13];
        m3.textColor = [UIColor blackColor];
        [superView addSubview:m3];
        [m3 sizeToFit];
        [m3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m1.left);
            make.centerY.equalTo(t5.centerY);
        }];
        if (_model.Order.RequiredArrivalTime)
            m3.text = [WEUtil convertFullDateStringToHourMinute:_model.Order.RequiredArrivalTime];
        
        UILabel *m4 = [UILabel new];
        m4.backgroundColor = [UIColor clearColor];
        m4.font = [UIFont systemFontOfSize:13];
        m4.textColor = [UIColor blackColor];
        [superView addSubview:m4];
        [m4 sizeToFit];
        [m4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m1.left);
            make.centerY.equalTo(t6.centerY);
        }];
        if (_model.Order.DispatchToAddressLine1)
            m4.text = _model.Order.DispatchToAddressLine1;

        UILabel *m5 = [UILabel new];
        m5.backgroundColor = [UIColor clearColor];
        m5.font = [UIFont systemFontOfSize:13];
        m5.textColor = [UIColor blackColor];
        [superView addSubview:m5];
        [m5 sizeToFit];
        [m5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m1.left);
            make.top.equalTo(m4.bottom).offset(10);
        }];
        if (_model.Order.DispatchToCity) {
            NSString *city = [NSString stringWithFormat:@"%@ %@", _model.Order.DispatchToCity, _model.Order.DispatchToState];
            m5.text = city;
        }
        
    } else if (indexPath.row == 2) {
        superView.backgroundColor = UICOLOR(247, 247, 247);
        UILabel *t1 = [UILabel new];
        t1.backgroundColor = [UIColor clearColor];
        t1.font = [UIFont systemFontOfSize:13];
        t1.textColor = [UIColor blackColor];
        [superView addSubview:t1];
        [t1 sizeToFit];
        [t1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
        }];
        t1.text = @"订单内容";
        
    } else if (indexPath.row == 3) {
        WEOrderDishListView *dishListView = [WEOrderDishListView new];
        dishListView.order = _model;
        [superView addSubview:dishListView];
        [dishListView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top).offset(0);
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.bottom.equalTo(superView.bottom).offset(0);
        }];

    } else if (indexPath.row == 4) {
        superView.backgroundColor = UICOLOR(247, 247, 247);
        UILabel *t1 = [UILabel new];
        t1.backgroundColor = [UIColor clearColor];
        t1.font = [UIFont systemFontOfSize:13];
        t1.textColor = [UIColor blackColor];
        [superView addSubview:t1];
        [t1 sizeToFit];
        [t1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
        }];
        t1.text = @"饭友捎话";
    
    } else if (indexPath.row == 5) {
        UILabel *t1 = [UILabel new];
        t1.numberOfLines = 0;
        t1.backgroundColor = [UIColor clearColor];
        t1.font = [UIFont systemFontOfSize:13];
        t1.textColor = UICOLOR(150, 150, 150);
        [superView addSubview:t1];
        [t1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.centerY.equalTo(superView.centerY);
        }];
        t1.text = _model.Order.Message;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float heighs[] = {35, 140, 35, 200, 35, 45};
    if (indexPath.row == 3) {
        return [WEOrderDishListView getHeightWithOrder:_model];
    }
    if (indexPath.row == 5) {
        float w = [WEUtil getScreenWidth] - 20*2;
        CGSize size = [WEUtil sizeForTitle:_model.Order.Message
                                      font:[UIFont systemFontOfSize:13]
                                  maxWidth:w];
        return size.height + 25;
    }
    
    return heighs[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor clearColor];
    
    UIView *superView = bg;
    UIView *box = [UIView new];
    box.backgroundColor = [UIColor clearColor];
    [superView addSubview:box];
    [box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.centerY.equalTo(superView.centerY);
    }];

    if ([_model.Order.OrderStatus isEqualToString:WEOrderStatus_NEW] || [_model.Order.OrderStatus isEqualToString:WEOrderStatus_PAID]) {
        UIButton *b1 = [UIButton new];
        b1.backgroundColor = UICOLOR(53, 176, 30);
        [b1 setTitle:@"接单" forState:UIControlStateNormal];
        b1.titleLabel.font = [UIFont systemFontOfSize:14];
        [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b1.layer.cornerRadius = 5;
        b1.layer.masksToBounds = YES;
        [b1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:b1];
        [b1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(box.left);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
        
        UIButton *b2 = [UIButton new];
        b2.backgroundColor = UICOLOR(214, 9, 21);
        [b2 setTitle:@"拒单" forState:UIControlStateNormal];
        b2.titleLabel.font = [UIFont systemFontOfSize:14];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b2.layer.cornerRadius = 5;
        b2.layer.masksToBounds = YES;
        [b2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:b2];
        [b2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(b1.right).offset(50);
            make.centerY.equalTo(superView.centerY);
            make.right.equalTo(box.right);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
    
    } else if ([_model.Order.OrderStatus isEqualToString:WEOrderStatus_ACCEPTED]) {
        UIButton *b1 = [UIButton new];
        [b1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b1.backgroundColor = UICOLOR(53, 176, 30);
        if ([_model.Order.DispatchMethod isEqualToString:@"PICKUP"]) {
            [b1 setTitle:@"待自取" forState:UIControlStateNormal];
        } else if ([_model.Order.DispatchMethod isEqualToString:@"DELIVER"]) {
            [b1 setTitle:@"待派送" forState:UIControlStateNormal];
        }
        b1.titleLabel.font = [UIFont systemFontOfSize:14];
        [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b1.layer.cornerRadius = 5;
        b1.layer.masksToBounds = YES;
        [superView addSubview:b1];
        [b1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(box.left);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
        
        UIButton *b2 = [UIButton new];
        [b2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b2.backgroundColor = UICOLOR(184, 184, 184);
        [b2 setTitle:@"取消订单并退款" forState:UIControlStateNormal];
        b2.titleLabel.font = [UIFont systemFontOfSize:14];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [superView addSubview:b2];
        [b2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(b1.right).offset(50);
            make.centerY.equalTo(superView.centerY);
            make.right.equalTo(box.right);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
        
    } else if ([_model.Order.OrderStatus isEqualToString:WEOrderStatus_READY]) {
        UIButton *b1 = [UIButton new];
        [b1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b1.backgroundColor = UICOLOR(53, 176, 30);
        [b1 setTitle:@"已派送" forState:UIControlStateNormal];
        b1.titleLabel.font = [UIFont systemFontOfSize:14];
        [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b1.layer.cornerRadius = 5;
        b1.layer.masksToBounds = YES;
        [superView addSubview:b1];
        [b1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(box.left);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
        
        UIButton *b2 = [UIButton new];
        [b2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b2.backgroundColor = UICOLOR(184, 184, 184);
        [b2 setTitle:@"取消订单并退款" forState:UIControlStateNormal];
        b2.titleLabel.font = [UIFont systemFontOfSize:14];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [superView addSubview:b2];
        [b2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(b1.right).offset(50);
            make.centerY.equalTo(superView.centerY);
            make.right.equalTo(box.right);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
        
    } else if ([_model.Order.OrderStatus isEqualToString:WEOrderStatus_DISPATCHED]) {
        UIButton *b1 = [UIButton new];
        [b1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b1.backgroundColor = UICOLOR(53, 176, 30);
        [b1 setTitle:@"已送达" forState:UIControlStateNormal];
        b1.titleLabel.font = [UIFont systemFontOfSize:14];
        [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b1.layer.cornerRadius = 5;
        b1.layer.masksToBounds = YES;
        [superView addSubview:b1];
        [b1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(box.left);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
        
        UIButton *b2 = [UIButton new];
        [b2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b2.backgroundColor = UICOLOR(184, 184, 184);
        [b2 setTitle:@"取消订单并退款" forState:UIControlStateNormal];
        b2.titleLabel.font = [UIFont systemFontOfSize:14];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [superView addSubview:b2];
        [b2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(b1.right).offset(50);
            make.centerY.equalTo(superView.centerY);
            make.right.equalTo(box.right);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
    }
    
    return bg;
}

- (void)buttonTapped:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在处理订单，请稍后...";
    [hud show:YES];
    
    NSString *title = [button titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"接单"]) {
        [WENetUtil AcceptOrderWithOrderId:_model.Order.Id
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      JSONModelError* error = nil;
                                      NSDictionary *dict = (NSDictionary *)responseObject;
                                      WEModelGetOrder *model = [[WEModelGetOrder alloc] initWithDictionary:dict error:&error];
                                      if (error) {
                                          NSLog(@"error %@, model %p", error, model);
                                      }
                                      if (!model.IsSuccessful) {
                                          hud.labelText = model.ResponseMessage;
                                          [hud hide:YES afterDelay:1.5];
                                          return;
                                      }
                                      _model = model;
                                      [_tableView reloadData];
                                      hud.labelText = [NSString stringWithFormat:@"%@成功",title];
                                      [hud hide:YES afterDelay:1.0];
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                      NSLog(@"failure %@", errorMsg);
                                      hud.labelText = errorMsg;
                                      [hud hide:YES afterDelay:1.5];
                                  }];
        
    } else if ([title isEqualToString:@"拒单"]) {
        [WENetUtil RejectOrderWithOrderId:_model.Order.Id
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      JSONModelError* error = nil;
                                      NSDictionary *dict = (NSDictionary *)responseObject;
                                      WEModelGetOrder *model = [[WEModelGetOrder alloc] initWithDictionary:dict error:&error];
                                      if (error) {
                                          NSLog(@"error %@, model %p", error, model);
                                      }
                                      if (!model.IsSuccessful) {
                                          hud.labelText = model.ResponseMessage;
                                          [hud hide:YES afterDelay:1.5];
                                          return;
                                      }
                                      _model = model;
                                      [_tableView reloadData];
                                      hud.labelText = [NSString stringWithFormat:@"%@成功",title];
                                      [hud hide:YES afterDelay:1.0];
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                      NSLog(@"failure %@", errorMsg);
                                      hud.labelText = errorMsg;
                                      [hud hide:YES afterDelay:1.5];
                                  }];
        
    } else if ([title isEqualToString:@"待派送"] ||
              [title isEqualToString:@"待自取"] ) {
        [WENetUtil SetReadyOrderWithOrderId:_model.Order.Id
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      JSONModelError* error = nil;
                                      NSDictionary *dict = (NSDictionary *)responseObject;
                                      WEModelGetOrder *model = [[WEModelGetOrder alloc] initWithDictionary:dict error:&error];
                                      if (error) {
                                          NSLog(@"error %@, model %p", error, model);
                                      }
                                      if (!model.IsSuccessful) {
                                          hud.labelText = model.ResponseMessage;
                                          [hud hide:YES afterDelay:1.5];
                                          return;
                                      }
                                      _model = model;
                                      [_tableView reloadData];
                                      hud.labelText = [NSString stringWithFormat:@"%@成功",title];
                                      [hud hide:YES afterDelay:1.0];
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                      NSLog(@"failure %@", errorMsg);
                                      hud.labelText = errorMsg;
                                      [hud hide:YES afterDelay:1.5];
                                  }];
        
    } else if ([title isEqualToString:@"取消订单并退款"]) {
        [WENetUtil CancelOrderWithOrderId:_model.Order.Id
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      JSONModelError* error = nil;
                                      NSDictionary *dict = (NSDictionary *)responseObject;
                                      WEModelGetOrder *model = [[WEModelGetOrder alloc] initWithDictionary:dict error:&error];
                                      if (error) {
                                          NSLog(@"error %@, model %p", error, model);
                                      }
                                      if (!model.IsSuccessful) {
                                          hud.labelText = model.ResponseMessage;
                                          [hud hide:YES afterDelay:1.5];
                                          return;
                                      }
                                      _model = model;
                                      [_tableView reloadData];
                                      hud.labelText = [NSString stringWithFormat:@"%@成功",title];
                                      [hud hide:YES afterDelay:1.0];
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                      NSLog(@"failure %@", errorMsg);
                                      hud.labelText = errorMsg;
                                      [hud hide:YES afterDelay:1.5];
                                  }];
        
    } else if ([title isEqualToString:@"已派送"]) {
        [WENetUtil DispatchOrderWithOrderId:_model.Order.Id
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      JSONModelError* error = nil;
                                      NSDictionary *dict = (NSDictionary *)responseObject;
                                      WEModelGetOrder *model = [[WEModelGetOrder alloc] initWithDictionary:dict error:&error];
                                      if (error) {
                                          NSLog(@"error %@, model %p", error, model);
                                      }
                                      if (!model.IsSuccessful) {
                                          hud.labelText = model.ResponseMessage;
                                          [hud hide:YES afterDelay:1.5];
                                          return;
                                      }
                                      _model = model;
                                      [_tableView reloadData];
                                      hud.labelText = [NSString stringWithFormat:@"%@成功",title];
                                      [hud hide:YES afterDelay:1.0];
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                      NSLog(@"failure %@", errorMsg);
                                      hud.labelText = errorMsg;
                                      [hud hide:YES afterDelay:1.5];
                                  }];
        
    } else if ([title isEqualToString:@"已送达"]) {
        [WENetUtil ReceiveOrderWithOrderId:_model.Order.Id
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        JSONModelError* error = nil;
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        WEModelGetOrder *model = [[WEModelGetOrder alloc] initWithDictionary:dict error:&error];
                                        if (error) {
                                            NSLog(@"error %@, model %p", error, model);
                                        }
                                        if (!model.IsSuccessful) {
                                            hud.labelText = model.ResponseMessage;
                                            [hud hide:YES afterDelay:1.5];
                                            return;
                                        }
                                        _model = model;
                                        [_tableView reloadData];
                                        hud.labelText = [NSString stringWithFormat:@"%@成功",title];
                                        [hud hide:YES afterDelay:1.0];
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                        NSLog(@"failure %@", errorMsg);
                                        hud.labelText = errorMsg;
                                        [hud hide:YES afterDelay:1.5];
                                    }];
        
    }
    if ([_parentController respondsToSelector:@selector(loadData)]) {
        [_parentController performSelector:@selector(loadData) withObject:nil afterDelay:1];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
