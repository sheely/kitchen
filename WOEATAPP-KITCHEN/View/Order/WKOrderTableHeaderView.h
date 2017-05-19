//
//  WKOrderTableHeaderView.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/22.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@class WKOrderTableHeaderView;
@protocol WKOrderGroupHeaderViewDelegate <NSObject>

- (void)OrderHeaderViewDidClickBtn:(WKOrderTableHeaderView *)headerView;

@end

@interface WKOrderTableHeaderView : UITableViewHeaderFooterView
@property (nonatomic, assign) id<WKOrderGroupHeaderViewDelegate>delegate;
@property (nonatomic, strong) OrderModel *orderModel;
@property(nonatomic, assign) BOOL isExpend;

+ (instancetype)orderHeaderViewWithTableView:(UITableView *)tableView;

@end
