//
//  WEWaitApprovedViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/30.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEWaitApprovedViewController.h"
#import "WEUtil.h"

@interface WEWaitApprovedViewController ()

@end

@implementation WEWaitApprovedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"等待审核";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UIImageView *logo = [UIImageView new];
    UIImage *img = [UIImage imageNamed:@"wait_approved"];
    logo.image = img;
    [superView addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX).offset(0);
        make.top.equalTo(self.mas_topLayoutGuide).offset([WEUtil getScreenHeight]*0.15);
        make.width.equalTo(img.size.width);
        make.height.equalTo(img.size.height);
    }];
    
    UILabel *title = [UILabel new];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = UICOLOR(200, 200, 200);
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    [superView addSubview:title];
    [title sizeToFit];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(logo.bottom).offset([WEUtil getScreenHeight]*0.08);
    }];
    title.text = @"您的家厨申请已经提交，我们正在审核";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
