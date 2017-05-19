//
//  WECashRequestViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/9.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WECashRequestViewController.h"
#import "WENetUtil.h"
#import "WEModelCommon.h"
#import "WEGlobalData.h"

@interface WECashRequestViewController ()
{
    UITextField *_countField;
}
@end

@implementation WECashRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,40)];
    [rightButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *superView = self.view;
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(190, 190, 190);
    [superView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.height.equalTo(40);
    }];
    
    UILabel *title = [UILabel new];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont boldSystemFontOfSize:13];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    [superView addSubview:title];
    [title sizeToFit];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.centerY.equalTo(bg.centerY);
    }];
    title.text = @"提现金额";
    
    UITextField *countField = [[UITextField alloc] initWithFrame:CGRectZero];
    countField.backgroundColor = [UIColor clearColor];
    countField.delegate = self;
    countField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    countField.autocorrectionType = UITextAutocorrectionTypeNo;
    countField.font = [UIFont systemFontOfSize:13];
    countField.textColor = [UIColor blackColor];
    countField.clearButtonMode = UITextFieldViewModeWhileEditing;
    countField.keyboardType = UIKeyboardTypeDecimalPad;
    countField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入要提现的金额" attributes:@{NSForegroundColorAttributeName: UICOLOR(180, 180, 180)}];
    [superView addSubview:countField];
    [countField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.width.equalTo(200);
        make.top.equalTo(title.bottom).offset(15);
        make.height.equalTo(40);
    }];
    _countField = countField;
    
    UILabel *countLabel = [UILabel new];
    countLabel.numberOfLines = 1;
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont boldSystemFontOfSize:13];
    countLabel.textColor = UICOLOR(180, 180, 180);
    countLabel.backgroundColor = [UIColor clearColor];
    [superView addSubview:countLabel];
    [countLabel sizeToFit];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-15);
        make.centerY.equalTo(countField.centerY);
    }];
    float balance = [WEGlobalData sharedInstance].myBalance;
    countLabel.text = [NSString stringWithFormat:@"可提现金额$%.2f", balance];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)showErrorHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = text;
    [hud show:YES];
    
    [hud hide:YES afterDelay:2];
}


- (void)save:(UIButton *)button
{
    float value = _countField.text.floatValue;
    
    if (!value) {
        [self showErrorHud:@"请输入要提现的金额"];
        return;
    }
    
    float balance = [WEGlobalData sharedInstance].myBalance;
    if (value > balance) {
        NSString *s = [NSString stringWithFormat:@"输入金额不能超过$%.2f", balance];
        [self showErrorHud:s];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在发送提交申请，请稍后...";
    [hud show:YES];
    
    [WENetUtil AddCashOutRequestWithCashoutValue:[NSString stringWithFormat:@"%d", value]
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
                                             hud.labelText = @"发送成功";
                                             hud.delegate = self;
                                             [hud hide:YES afterDelay:1.0];
                                             
                                         } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                             hud.labelText = errorMsg;
                                             [hud hide:YES afterDelay:1.5];
                                         } ];

}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
