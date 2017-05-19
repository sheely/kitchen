//
//  WEDeliverTypeViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/1.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEDeliverTypeViewController.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"
#import "WENetUtil.h"
#import "WEModelCommon.h"

@interface WEDeliverTypeViewController ()
{
    UITableView *_tableView;
    BOOL _canPickup;
    BOOL _canDeliver;
}
@end

@implementation WEDeliverTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"就餐方式";
    
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    _canPickup = model.Kitchen.CanPickup;
    _canDeliver = model.Kitchen.CanDeliver;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *superView = self.view;
    UILabel *title = [UILabel new];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = UICOLOR(187, 187, 187);
    [superView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.height.equalTo(40);
    }];
    title.text = @"     请至少选择一种就餐方式";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.bottom).offset(5);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _tableView = tableView;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
    UIView *superView = cell.contentView;
    
    float offset = 25;
    UIImage *check = [UIImage imageNamed:@"checkbox_check"];
    UIImage *unCheck = [UIImage imageNamed:@"checkbox_uncheck"];
    UIImageView *imgView = [UIImageView new];
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offset);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(check.size.width);
        make.height.equalTo(check.size.height);
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
        make.left.equalTo(imgView.right).offset(5);
        make.right.equalTo(superView.right);
        make.centerY.equalTo(superView.centerY);
    }];
    
    if (indexPath.row == 0) {
        if (_canPickup) {
            imgView.image = check;
        } else {
            imgView.image = unCheck;
        }
        title.text = @"饭友自取";
    } else {
        if (_canDeliver) {
            imgView.image = check;
        } else {
            imgView.image = unCheck;
        }
        title.text = @"家厨配送";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        _canPickup = !_canPickup;
    } else {
        _canDeliver = !_canDeliver;
    }
    [_tableView reloadData];
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
    if (!_canPickup && !_canDeliver) {
        [self showErrorHud:@"请至少选择一种送餐方式"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在保存送餐方式，请稍后...";
    [hud show:YES];
    
    [WENetUtil UpdateDispatchMethodWithCanPickup:_canPickup
                                      CanDeliver:_canDeliver
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
                                             hud.labelText = @"保存成功";
                                             hud.delegate = self;
                                             [hud hide:YES afterDelay:1.0];
                                         } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                             hud.labelText = errorMsg;
                                             [hud hide:YES afterDelay:1.5];
                                         }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
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
