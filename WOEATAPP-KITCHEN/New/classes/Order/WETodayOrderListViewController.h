//
//  WETodayOrderListViewController.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  TodayOrderListViewController_Today      1
#define  TodayOrderListViewController_Tomorrow   2

@interface WETodayOrderListViewController : UIViewController

@property(nonatomic, assign) int type;
- (void)loadDataIfNeeded;
- (void)loadData;

- (void)loadDataSilent;
@end
