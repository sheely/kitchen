//
//  WECashRecordViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/9.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WECashRecordViewController.h"
#import "WENetUtil.h"
#import "WEModelGetCashOutRequestList.h"
#import "WEUtil.h"

#define CELL_LFET   25
#define CELL_RIGHT  15
#define GRAY_COLOR UICOLOR(150,150,150)



@interface WECashRecordViewController ()
{
    WEModelGetCashOutRequestList *_model;
    UITableView *_tableView;
}
@end

@implementation WECashRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"提现记录";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _tableView = tableView;
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取提现记录，请稍后...";
    [hud show:YES];
    [WENetUtil GetCashOutRequestListWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        JSONModelError* error = nil;
        WEModelGetCashOutRequestList *res = [[WEModelGetCashOutRequestList alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        if (!res.IsSuccessful) {
            hud.labelText = res.ResponseMessage;
            [hud hide:YES afterDelay:1.5];
            return;
        }
        _model = res;
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
    return _model.CashOutRequestList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    WEModelGetCashOutRequestListCashOutRequestList *data = _model.CashOutRequestList[indexPath.row];
    
    UILabel *time = [UILabel new];
    time.backgroundColor = [UIColor clearColor];
    time.textColor = GRAY_COLOR;
    time.font = [UIFont systemFontOfSize:13];
    time.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:time];
    [time sizeToFit];
    [time makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(CELL_LFET);
        make.centerY.equalTo(superView.centerY);
    }];
    time.text = [WEUtil convertFullDateStringToDay:data.TimeCreated];
    
    UILabel *amount = [UILabel new];
    amount.backgroundColor = [UIColor clearColor];
    amount.textColor = GRAY_COLOR;
    amount.font = [UIFont systemFontOfSize:13];
    amount.textAlignment = NSTextAlignmentRight;
    [superView addSubview:amount];
    [amount sizeToFit];
    [amount makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.left).offset([WEUtil getScreenWidth]*0.65);
        make.centerY.equalTo(superView.centerY);
    }];
    amount.text = [NSString stringWithFormat:@"$%d", (int)data.CashoutValue];
    
    UILabel *result = [UILabel new];
    result.backgroundColor = [UIColor clearColor];
    result.textColor = GRAY_COLOR;
    result.font = [UIFont systemFontOfSize:13];
    result.textAlignment = NSTextAlignmentRight;
    [superView addSubview:result];
    [result sizeToFit];
    [result makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-CELL_RIGHT);
        make.centerY.equalTo(superView.centerY);
    }];
    if (!data.Result.length) {
        result.text = @"审核中";
        result.textColor = UICOLOR(249, 222, 180);
    } else if ([data.Result isEqualToString:@"APPROVED"]) {
        result.text = @"已完成";
    } else if ([data.Result isEqualToString:@"DECLINED"]) {
        result.text = @"未通过";
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = GRAY_COLOR;
    [superView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(superView.bottom);
        make.height.equalTo(0.5);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(184, 184, 184);
    UIView *superView = bg;
    
    UILabel *time = [UILabel new];
    time.backgroundColor = [UIColor clearColor];
    time.textColor = UICOLOR(0, 0, 0);
    time.font = [UIFont systemFontOfSize:13];
    time.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:time];
    [time sizeToFit];
    [time makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(CELL_LFET);
        make.centerY.equalTo(superView.centerY);
    }];
    time.text = @"申请日期";
    
    UILabel *amount = [UILabel new];
    amount.backgroundColor = [UIColor clearColor];
    amount.textColor = UICOLOR(0, 0, 0);
    amount.font = [UIFont systemFontOfSize:13];
    amount.textAlignment = NSTextAlignmentRight;
    [superView addSubview:amount];
    [amount sizeToFit];
    [amount makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.left).offset([WEUtil getScreenWidth]*0.65);
        make.centerY.equalTo(superView.centerY);
    }];
    amount.text = @"提现金额";
    
    UILabel *result = [UILabel new];
    result.backgroundColor = [UIColor clearColor];
    result.textColor = UICOLOR(0, 0, 0);
    result.font = [UIFont systemFontOfSize:13];
    result.textAlignment = NSTextAlignmentRight;
    [superView addSubview:result];
    [result sizeToFit];
    [result makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-CELL_RIGHT);
        make.centerY.equalTo(superView.centerY);
    }];
    result.text = @"审核结果";
    
    return bg;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
