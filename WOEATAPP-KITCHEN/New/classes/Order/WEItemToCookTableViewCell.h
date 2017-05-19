//
//  WEItemToCookTableViewCell.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEModelGetItemToCookList.h"
#import "WEModelGetItemToCookPerOrderList.h"

@class WEItemToCookTableViewCell;
@protocol WEItemToCookCellDelegate <NSObject>

- (void)cellArrowTapped:(WEItemToCookTableViewCell *)cell;
- (void)cellOrderButtonTapped:(NSString *)orderId;
@end

@interface WEItemToCookTableViewCell : UITableViewCell

@property(nonatomic, assign) id<WEItemToCookCellDelegate> itemDelegate;
@property(nonatomic, assign) BOOL isExpand;

- (void)setItemData:(WEModelGetItemToCookListItemToCookList *)data;
- (void)setOrderData:(WEModelGetItemToCookPerOrderList *)data;
+ (float)getHeightWithData:(WEModelGetItemToCookPerOrderList *)data isExpand:(BOOL)isExpand;
@end
