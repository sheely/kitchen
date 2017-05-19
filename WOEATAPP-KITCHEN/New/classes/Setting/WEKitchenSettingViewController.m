//
//  WEKitchenSettingViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEKitchenSettingViewController.h"
#import "WEKitchenInfoViewController.h"
#import "WKBusinessViewController.h"
#import "WEDeliverTypeViewController.h"
#import "WENetUtil.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"
#import "WEKitchenStoryViewController.h"
#import "WEKitchenPictureViewController.h"
#import "WKPersionalViewController.h"
#import "WEToken.h"
#import "AppDelegate.h"

@interface WEKitchenSettingViewController ()
{
    UITableView *_tableView;
}
@end

@implementation WEKitchenSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"厨房设置";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchKitenInfo];
}

- (void)fetchKitenInfo{
    
    [WENetUtil GetMyKitchenWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyKitchen *model = [[WEModelGetMyKitchen alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        
        if ([model.Kitchen.Id isEqual:[NSNull null]] || [model.Kitchen.Id integerValue] == 0) {
        } else {
            [WEGlobalData sharedInstance].cacheMyKitchen = model;
            [_tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"错误信息 -> %@",errorMsg);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    superView.backgroundColor = UICOLOR(63, 63, 64);
    
    NSArray *icons = @[@"icon_kitchen_details", @"icon_business_hour", @"icon_diliver_type",
                        @"icon_kitchen_story",@"icon_kitchen_camera",
                        @"icon_personal_details", @"icon_sign_out"];
    NSArray *titles = @[@"厨房信息", @"营业时间", @"配送方式",
                         @"厨房故事",@"厨房照片",
                        @"个人信息", @"退出登录"];
    float imageWidth[] = {31, 31, 43,
                        31, 37,
                        31,31};
    
    float imgWidth = imageWidth[indexPath.row];
    UIImage *img = [UIImage imageNamed:icons[indexPath.row]];
    NSString *title = titles[indexPath.row];
    UIImageView *imgView = [UIImageView new];
    imgView.image = img;
    [superView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.left).offset(31);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(imgWidth);
        make.height.equalTo(imgWidth * img.size.height/ img.size.width);
    }];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UICOLOR(248, 212, 160);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:label];
    [label sizeToFit];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(62);
        make.centerY.equalTo(superView.centerY);
    }];
    label.text = title;
    
    float imgHeight = 23;
    UIImage *arrow = [UIImage imageNamed:@"icon_arrow_gray_light"];
    UIImageView *imgView1 = [UIImageView new];
    imgView1.image = arrow;
    [superView addSubview:imgView1];
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-10);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(arrow.size.width * imgHeight/ arrow.size.height);
        make.height.equalTo(imgHeight);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR(127, 115, 97);
    [superView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(superView.bottom);
        make.height.equalTo(0.5);
    }];
    
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = UICOLOR(202, 202, 202);
    label.font = [UIFont systemFontOfSize:14];
    [superView addSubview:label];
    [label sizeToFit];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgView1.left).offset(-10);
        make.centerY.equalTo(superView.centerY);
    }];
    
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    if (indexPath.row == 0) {
        label.text = @"已完成";
    } else if (indexPath.row == 1) {
        label.text = @"必填";
    } else if (indexPath.row == 2) {
        label.text = @"必填";
    } else if (indexPath.row == 3) {
        if (model.Kitchen.KitchenStory.length) {
            label.text = @"已完成";
        } else {
            label.text = @"待完善";
        }
    } else if (indexPath.row == 4) {
        if (model.Images.count) {
            label.text = @"已完成";
        } else {
            label.text = @"待完善";
        }
    } else if (indexPath.row == 5) {
        label.text = @"待完善";
    
    } else if (indexPath.row == 6) {
        imgView1.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        WEKitchenInfoViewController *c = [WEKitchenInfoViewController new];
        [self.navigationController pushViewController:c  animated:YES];
    
    } else if (indexPath.row == 1) {
        WKBusinessViewController *businessCtrl = [[WKBusinessViewController alloc] init];
        [self.navigationController pushViewController:businessCtrl animated:YES];
    
    } else if (indexPath.row == 2) {
        WEDeliverTypeViewController *c = [[WEDeliverTypeViewController alloc] init];
        [self.navigationController pushViewController:c animated:YES];
        
    } else if (indexPath.row == 3) {
        WEKitchenStoryViewController *c = [[WEKitchenStoryViewController alloc] init];
        [self.navigationController pushViewController:c animated:YES];
    
    } else if (indexPath.row == 4) {
        WEKitchenPictureViewController *c = [[WEKitchenPictureViewController alloc] init];
        [self.navigationController pushViewController:c animated:YES];
    
    } else if (indexPath.row == 5) {
        WKPersionalViewController *personalCtrl = [[WKPersionalViewController alloc] init];
        [self.navigationController pushViewController:personalCtrl animated:YES];
    
    } else if (indexPath.row == 6) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"您确定要退出登录么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alerView show];
    }

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [WEToken clearToken];
        [WEGlobalData sharedInstance].registerToken = nil;
        [WEGlobalData logOut];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setRootToLoginController];

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
