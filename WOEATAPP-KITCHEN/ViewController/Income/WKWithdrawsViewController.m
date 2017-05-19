//
//  WKWithdrawsViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/30.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKWithdrawsViewController.h"
#import "ELETextField.h"

@interface WKWithdrawsViewController ()

@property (nonatomic, strong) ELETextField *moneyTextField;
@end

@implementation WKWithdrawsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现";
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(withdraw:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIView *bannerView = [UIView  new];
    bannerView.backgroundColor = [UIColor colorWithHexString:@"b1b1b1"];
    [self.view addSubview:bannerView];

    WS(weakSelf);
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64),
        make.height.mas_equalTo(40),
        make.leading.equalTo(weakSelf.view),
        make.trailing.equalTo(weakSelf.view);
    }];
    
    UILabel *withDarwsLabel = [UILabel new];
    withDarwsLabel.backgroundColor = [UIColor clearColor];
    withDarwsLabel.text = @"提现金额";
    withDarwsLabel.font = [UIFont systemFontOfSize:14];
    [bannerView addSubview:withDarwsLabel];
    [withDarwsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bannerView),
        make.height.mas_equalTo(15),
        make.leading.equalTo(bannerView).offset(40);
    }];
    
    UILabel *totalMoneyLabel = [UILabel new];
    totalMoneyLabel.backgroundColor = [UIColor clearColor];
    totalMoneyLabel.text = [NSString stringWithFormat:@"可提现金额$%.2f",self.totalIncome];
    totalMoneyLabel.font = [UIFont systemFontOfSize:14];
    [bannerView addSubview:totalMoneyLabel];
    [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bannerView),
        make.height.mas_equalTo(15),
        make.trailing.equalTo(bannerView).offset(-20);
    }];
    
    _moneyTextField = [ELETextField new];
    _moneyTextField.placeholder = @"请输入提现金额";
    [self.view addSubview:_moneyTextField];
    [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView).offset(40),
        make.height.mas_equalTo(40),
        make.leading.equalTo(weakSelf.view),
        make.trailing.equalTo(weakSelf.view);
    }];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor colorWithHexString:@"b1b1b1"];
    tipLabel.text = @"您的提现申请提交后，我们将进行人工审核并尽快通知您审核结果";
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moneyTextField).offset(38),
        make.height.mas_equalTo(40),
        make.width.mas_equalTo(screen_width - 40),
        make.leading.equalTo(bannerView).offset(20);
    }];
    
//    UIButton *withDarwsButton = [UIButton new];
//    [withDarwsButton setBackgroundColor:[UIColor greenColor]];
//    [withDarwsButton setTitle:@"提交提现请求" forState:UIControlStateNormal];
//    [withDarwsButton.titleLabel setTextColor:[UIColor whiteColor]];
//    [withDarwsButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    withDarwsButton.layer.cornerRadius = 3;
//    withDarwsButton.layer.masksToBounds = YES;
//    [self.view addSubview:withDarwsButton];
//    [withDarwsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_moneyTextField).offset(84),
//        make.height.mas_equalTo(20),
//        make.centerX.equalTo(weakSelf.view),
//        make.width.mas_equalTo(60);
//    }];
//    [withDarwsButton addTarget:self action:@selector(withdraw:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)withdraw:(id)sender
{
    WS(ws);
    NSDictionary *param = @{@"CashoutValue":@([self.moneyTextField.text integerValue])};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/TransactionCashOutRequest/AddCashOutRequest" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                    [ws.navigationController popViewControllerAnimated:YES];
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
    }];
}
@end
