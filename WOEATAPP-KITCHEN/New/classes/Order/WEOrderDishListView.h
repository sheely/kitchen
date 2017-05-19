//
//  WEOrderDishListView.h
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEModelGetOrder.h"


@interface WEOrderDishListView : UIView

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) WEModelGetOrder *order;

+ (float)getHeightWithOrder:(WEModelGetOrder *)order;
@end
