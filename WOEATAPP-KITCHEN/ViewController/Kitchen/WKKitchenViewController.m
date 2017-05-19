//
//  WKKitchenViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/23.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKKitchenViewController.h"
#import "WKKitchenSettingController.h"
#import "WKBusinessViewController.h"
#import "WKPersionalViewController.h"
#import "WKLoginViewController.h"

@interface WKKitchenViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *kitchenTableView;

@end

@implementation WKKitchenViewController

- (void)loadView
{
    [super loadView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.kitchenTableView];
    self.title = @"厨房设置";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)kitchenTableView
{
    if (_kitchenTableView == nil) {
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _kitchenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY) style:UITableViewStylePlain];
        _kitchenTableView.dataSource = self;
        _kitchenTableView.delegate = self;
        _kitchenTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _kitchenTableView.separatorColor = [UIColor colorWithHexString:@"#F7D598" andAlpha:1.0];
        _kitchenTableView.tableFooterView = [[UIView alloc] init];
        if ([_kitchenTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_kitchenTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _kitchenTableView;
}

#pragma mark- tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KitchenCell"];
        cell.imageView.image = [UIImage imageNamed:@"icon_kitchen_details"];
        cell.textLabel.text = @"厨房信息";
    }else if (indexPath.row == 1){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessTimeCell"];
        cell.imageView.image = [UIImage imageNamed:@"icon_business_hour"];
        cell.textLabel.text = @"营业时间";
    }else if (indexPath.row == 2){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonCell"];
        cell.imageView.image = [UIImage imageNamed:@"icon_personal_details"];
        cell.textLabel.text = @"个人信息";
    }
    else if (indexPath.row == 3){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonCell"];
        cell.imageView.image = [UIImage imageNamed:@"icon_sign_out"];
        cell.textLabel.text = @"退出登录";
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#F7D598" andAlpha:1.0];
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#3F3F40" andAlpha:1.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            WKKitchenSettingController *setttingCtrl = [[WKKitchenSettingController alloc] init];
            [self.navigationController pushViewController:setttingCtrl animated:YES];
        }
            break;
        case 1:{
            WKBusinessViewController *businessCtrl = [[WKBusinessViewController alloc] init];
            [self.navigationController pushViewController:businessCtrl animated:YES];
        }
            break;
        case 3:{
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"您确定要退出登录么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alerView show];
        }
            break;
        default:{
            WKPersionalViewController *personalCtrl = [[WKPersionalViewController alloc] init];
            [self.navigationController pushViewController:personalCtrl animated:YES];
        }
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [WKKeyChain deleteUserInfo:kAPPSecurityStoreKey];
        WKLoginViewController *login = [[UIStoryboard accountStoryboard] instantiateViewControllerWithIdentifier:@"WKLoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    }
}
@end
