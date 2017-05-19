//
//  WKIncomeViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/23.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKIncomeViewController.h"
#import "WKBandAccountViewController.h"
#import "WKWithdrawsViewController.h"
#import "WKWithdrawsRecordController.h"

@interface WKIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *btnGetCash;//提现
@property (nonatomic, strong) UIButton *btnSetBankAccount;//设置银行卡
@property (nonatomic, strong) NSArray *monthRecordArray;
@property (nonatomic, assign) CGFloat totalIncome;

@end

@implementation WKIncomeViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收入";
    [self.view addSubview:self.tableView];
    [self creatHeaderView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.btnGetCash];
//    [self.view addSubview:self.btnSetBankAccount];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requetTotalIncome];
    NSDictionary *param = @{};
    WS(ws);
    [[WKNetworkManager sharedAuthManager] GET:@"v1/Kitchen/GetKitchenSalesByMonth" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                    ws.monthRecordArray = (NSArray *)responseObject[@"SalesByMonthList"];
                    [ws.tableView reloadData];
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
    }];
}

- (void)requetTotalIncome
{
    NSDictionary *param = @{};
    WS(ws);
    [[WKNetworkManager sharedAuthManager] POST:@"v1/User/GetMyBalance" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                    ws.totalIncome = [responseObject[@"Balance"] floatValue];
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
    }];
}
-(void)creatHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = [NSString stringWithFormat:@"$ %.2f",self.totalIncome];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:34];
    [headerView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView),
        make.centerY.equalTo(headerView),
        make.height.mas_equalTo(35);
    }];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"可提现金额";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView),
        make.top.equalTo(moneyLabel).offset(-18),
        make.height.mas_equalTo(14);
    }];
    
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"提现" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button addTarget:self action:@selector(WithdrawsCashAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.0;
    button.layer.masksToBounds = YES;
    [headerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(moneyLabel).offset(-6),
        make.right.equalTo(moneyLabel).offset(80),
        make.size.mas_offset(CGSizeMake(54, 16));
    }];
//
    _tableView.tableHeaderView = headerView;
}

- (UIButton *)btnGetCash
{
    if (_btnGetCash == nil) {
        _btnGetCash = [[UIButton alloc] initWithFrame:CGRectMake(0,screen_height - 40, screen_width, 40)];
        [_btnGetCash setTitle:@"提现记录" forState:UIControlStateNormal];
        [_btnGetCash setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
        [_btnGetCash addTarget:self action:@selector(getCashRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnGetCash;
}

- (UIButton *)btnSetBankAccount
{
    if (_btnSetBankAccount == nil) {
        _btnSetBankAccount = [[UIButton alloc] initWithFrame:CGRectMake(0, screen_height - 40, screen_width,40)];
        [_btnSetBankAccount setTitle:@"设置银行卡" forState:UIControlStateNormal];
        [_btnSetBankAccount setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
        [_btnSetBankAccount addTarget:self action:@selector(setBankAccount:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSetBankAccount;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)getCashRecord:(id)sender
{
    WKWithdrawsRecordController *recordCtrl = [[WKWithdrawsRecordController alloc]init];
    [self.navigationController pushViewController:recordCtrl animated:YES];
}

- (void)setBankAccount:(id)sender
{
    WKBandAccountViewController *account = [[WKBandAccountViewController alloc]init];
    [self.navigationController pushViewController:account animated:YES];
}
#pragma mark---------UITableViewDataSource, UITableViewDelegate 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.monthRecordArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger year = [self.monthRecordArray[indexPath.row][@"Year"] integerValue];
    NSInteger month = [self.monthRecordArray[indexPath.row][@"Month"] integerValue];
    CGFloat totalSales = [self.monthRecordArray[indexPath.row][@"TotalSales"] floatValue];
    NSString *strDate = [NSString stringWithFormat:@"%ld年%.2ld月",(long)year,(long)month];
    cell.textLabel.text = strDate;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - 100, 10, 80, 15)];
    label.text = [NSString stringWithFormat:@"$%.2f",totalSales];
    label.font = [UIFont boldSystemFontOfSize:16];
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *recordDic = self.monthRecordArray[indexPath.row];
    WKWithdrawsRecordController *recordCtrl = [[WKWithdrawsRecordController alloc]init];
    recordCtrl.recordDic = recordDic;
    [self.navigationController pushViewController:recordCtrl animated:YES];
}

-(void)WithdrawsCashAction:(id)sender
{
    
    WKWithdrawsViewController *vc = [[WKWithdrawsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
//    headerView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
//    return headerView;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 36;
//    }
//    return 0;
//    
//}


@end
