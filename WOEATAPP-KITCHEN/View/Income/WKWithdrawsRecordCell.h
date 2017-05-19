//
//  WKWithdrawsRecordCell.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2017/1/8.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@class CashOutModel;
@interface WKWithdrawsRecordCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellType;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)loadData:(CashOutModel *)record;
- (void)loadMonthData:(OrderModel *)record;

@end
