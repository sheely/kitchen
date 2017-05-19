//
//  WEItemToCookCellButton.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/8.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEItemToCookCellButton.h"
#import "WEUtil.h"

@interface WEItemToCookCellButton()
{
    UILabel *_orderId;
    UILabel *_amount;
    UILabel *_time;
}

@end

@implementation WEItemToCookCellButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UICOLOR(199, 199, 203);
        UIView *superView = self;
        
        UILabel *orderId = [UILabel new];
        orderId.numberOfLines = 1;
        orderId.textAlignment = NSTextAlignmentLeft;
        orderId.font = [UIFont systemFontOfSize:13];
        orderId.textColor = [UIColor whiteColor];
        [superView addSubview:orderId];
        [orderId sizeToFit];
        [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(15);
            make.top.equalTo(superView.top).offset(5);
        }];
        _orderId = orderId;
        
        UILabel *amount = [UILabel new];
        amount.numberOfLines = 1;
        amount.textAlignment = NSTextAlignmentRight;
        amount.font = [UIFont systemFontOfSize:13];
        amount.textColor = [UIColor whiteColor];
        [superView addSubview:amount];
        [amount sizeToFit];
        [amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-5);
            make.centerY.equalTo(_orderId.centerY);
        }];
        _amount = amount;

        UILabel *time = [UILabel new];
        time.numberOfLines = 1;
        time.textAlignment = NSTextAlignmentRight;
        time.font = [UIFont systemFontOfSize:11];
        time.textColor = [UIColor whiteColor];
        [superView addSubview:time];
        [time sizeToFit];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_amount.right);
            make.top.equalTo(_amount.bottom).offset(5);
        }];
        _time = time;
    }
    return self;
}

- (void)setModel:(WEModelGetItemToCookPerOrderListItemToCookPerOrderList *)model
{
    if (!model) {
        return;
    }
    _orderId.text = [NSString stringWithFormat:@"订单号 %@", model.SalesOrderId];
    _amount.text = [NSString stringWithFormat:@"%d份", model.Quantity];
    NSString *time = [WEUtil convertFullDateStringToHourMinute:model.RequiredArrivalTime];
    _time.text = [NSString stringWithFormat:@"就餐时间%@",time];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
