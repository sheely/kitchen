//
//  WEIncomeViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/9.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEIncomeViewController.h"
#import "WENetUtil.h"
#import "WECashRequestViewController.h"
#import "WECashRecordViewController.h"
#import "WEMonthIncomeViewController.h"
#import "WEGlobalData.h"

@interface WEIncomeViewController ()
{
    UILabel *_balance;
}
@end

@implementation WEIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的收入";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UICOLOR(200, 200, 200);
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentRight;
    [superView addSubview:label];
    [label sizeToFit];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.centerX).offset(-20);
        make.top.equalTo(self.mas_topLayoutGuide).offset(50);
    }];
    label.text = @"账户金额";
    
    UILabel *balance = [UILabel new];
    balance.backgroundColor = [UIColor clearColor];
    balance.textColor = UICOLOR(0, 0, 0);
    balance.font = [UIFont systemFontOfSize:30];
    balance.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:balance];
    [balance sizeToFit];
    [balance makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.centerX).offset(10);
        make.centerY.equalTo(label.centerY);
    }];
    _balance = balance;
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR(205, 177, 135);
    [superView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right);
        make.top.equalTo(label.bottom).offset(50);
        make.height.equalTo(3);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    [self loadBalance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadBalance
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取余额，请稍后...";
    [hud show:YES];
    [WENetUtil GetMyBalanceWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *ResponseCode = [dict objectForKey:@"ResponseCode"];
        if ([ResponseCode isEqualToString:@"200"]) {
            double balance = [[dict objectForKey:@"Balance"] floatValue];
            _balance.text = [NSString stringWithFormat:@"$%.2f", balance];
            [hud hide:YES afterDelay:0];
            [WEGlobalData sharedInstance].myBalance = balance;
            
        } else {
            NSString *ResponseMessage = [dict objectForKey:@"ResponseMessage"];
            hud.labelText = ResponseMessage;
            [hud hide:YES afterDelay:1.5];
        }
        
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    superView.backgroundColor = UICOLOR(63, 63, 64);
    NSArray *titles = @[@"申请提现", @"提现记录", @"月收入统计"];
    NSString *title = titles[indexPath.row];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UICOLOR(218, 188, 141);
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:label];
    [label sizeToFit];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.centerY.equalTo(superView.centerY);
    }];
    label.text = title;
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR(134, 120, 99);
    [superView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(superView.bottom);
        make.height.equalTo(1);
    }];
    
    float imgHeight = 20;
    UIImage *arrow = [UIImage imageNamed:@"icon_arrow_gray_light"];
    UIImageView *imgView1 = [UIImageView new];
    imgView1.image = arrow;
    [superView addSubview:imgView1];
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-15);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(arrow.size.width * imgHeight/ arrow.size.height);
        make.height.equalTo(imgHeight);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        WECashRequestViewController *c = [WECashRequestViewController new];
        [self.navigationController pushViewController:c  animated:YES];
        
    } else if (indexPath.row == 1) {
        WECashRecordViewController *c = [WECashRecordViewController new];
        [self.navigationController pushViewController:c  animated:YES];
        //WKBusinessViewController *businessCtrl = [[WKBusinessViewController alloc] init];
        //[self.navigationController pushViewController:businessCtrl animated:YES];
        
    } else if (indexPath.row == 2) {
        WEMonthIncomeViewController *c = [WEMonthIncomeViewController new];
        [self.navigationController pushViewController:c  animated:YES];
        //WEDeliverTypeViewController *c = [[WEDeliverTypeViewController alloc] init];
        //[self.navigationController pushViewController:c animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
