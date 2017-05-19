//
//  WETmpStartViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WETmpStartViewController.h"

@interface WETmpStartViewController ()

@end

@implementation WETmpStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *superView = self.view;
    UIImage *logo = [UIImage imageNamed:@"Default"];
    UIImageView *logoView = [UIImageView new];
    logoView.image = logo;
    [superView addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
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
