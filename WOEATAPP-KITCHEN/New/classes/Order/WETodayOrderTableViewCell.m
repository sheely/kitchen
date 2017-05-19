//
//  WETodayOrderTableViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WETodayOrderTableViewCell.h"
#import "WEOrderStatus.h"
#import "WEUtil.h"

@interface WETodayOrderTableViewCell()
{
    UILabel *_orderId;
    UILabel *_orderStatus;
    UILabel *_orderDate;
    UILabel *_diliver;
    UILabel *_price;
    UILabel *_customerName;
}

@end


@implementation WETodayOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;

    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(199, 199, 203);
    [superView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top);
        make.left.equalTo(superView.left).offset(20);
        make.right.equalTo(superView.right).offset(-20);
        make.bottom.equalTo(superView.bottom).offset(-10);
    }];
    
    superView = bg;
    UIImage *grayArrow = [UIImage imageNamed:@"arrow_order_right"];
    UIImageView *arrowView = [UIImageView new];
    arrowView.image = grayArrow;
    [superView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.centerY);
        make.right.equalTo(superView.right).offset(0);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    
    UILabel *price = [UILabel new];
    price.numberOfLines = 1;
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = [UIColor blackColor];
    //price.text = @"需支付: $36.00";
    [superView addSubview:price];
    [price sizeToFit];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowView.left).offset(-10);
        make.top.equalTo(superView.top).offset(10);
    }];
    _price = price;

    UILabel *orderStatus = [UILabel new];
    orderStatus.numberOfLines = 1;
    orderStatus.textAlignment = NSTextAlignmentRight;
    orderStatus.font = [UIFont systemFontOfSize:12];
    orderStatus.textColor = [UIColor whiteColor];
    //orderStatus.text = @"待支付";
    [superView addSubview:orderStatus];
    [orderStatus sizeToFit];
    [orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_price.bottom).offset(8);
        make.right.equalTo(_price.right);
    }];
    _orderStatus = orderStatus;

    UILabel *orderDate = [UILabel new];
    orderDate.numberOfLines = 1;
    orderDate.textAlignment = NSTextAlignmentRight;
    orderDate.font = [UIFont systemFontOfSize:12];
    orderDate.textColor = [UIColor whiteColor];
    //orderDate.text = @"2016年10月20日 19:25";
    [superView addSubview:orderDate];
    [orderDate sizeToFit];
    [orderDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderStatus.bottom).offset(3);
        make.right.equalTo(_price.right);
    }];
    _orderDate = orderDate;
    
    UILabel *orderId = [UILabel new];
    orderId.numberOfLines = 1;
    orderId.textAlignment = NSTextAlignmentLeft;
    orderId.font = [UIFont systemFontOfSize:14];
    orderId.textColor = [UIColor blackColor];
    //orderId.text = @"订单号 102226";
    [superView addSubview:orderId];
    [orderId sizeToFit];
    [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(10);
        make.centerY.equalTo(_price.centerY);
    }];
    _orderId = orderId;
    
    UILabel *diliver = [UILabel new];
    diliver.numberOfLines = 1;
    diliver.textAlignment = NSTextAlignmentLeft;
    diliver.font = [UIFont systemFontOfSize:12];
    diliver.textColor = [UIColor whiteColor];
    //diliver.text = @"配送";
    [superView addSubview:diliver];
    [diliver sizeToFit];
    [diliver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderId.left);
        make.centerY.equalTo(orderStatus.centerY);
    }];
    _diliver = diliver;
    
    UILabel *customerName = [UILabel new];
    customerName.numberOfLines = 1;
    customerName.textAlignment = NSTextAlignmentLeft;
    customerName.font = [UIFont systemFontOfSize:12];
    customerName.textColor = [UIColor whiteColor];
    //diliver.text = @"配送";
    [superView addSubview:customerName];
    [customerName sizeToFit];
    [customerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderId.left);
        make.centerY.equalTo(_orderDate.centerY);
    }];
    _customerName = customerName;
    
    return self;
}

- (void)setData:(WEModelGetOrderListTodayOrderList *)model
{
    if (!model) {
        return;
    }
    
    _orderId.text = [NSString stringWithFormat:@"订单号 %@", model.Id];
    if ([model.DispatchMethod isEqualToString:@"PICKUP"]) {
        _diliver.text = @"自取";
    } else if ([model.DispatchMethod isEqualToString:@"DELIVER"]){
        _diliver.text = @"配送";
    }
    _customerName.text = [NSString stringWithFormat:@"饭友: %@", model.UserDisplayName];
    _price.text = [NSString stringWithFormat:@"$%.2f",model.PayableValue];
    if ([model.OrderStatus isEqualToString:WEOrderStatus_READY]) {
         if ([model.DispatchMethod isEqualToString:@"PICKUP"]) {
             _orderStatus.text = [NSString stringWithFormat:@"状态 %@", @"待自取"];
         } else if ([model.DispatchMethod isEqualToString:@"DELIVER"]){
             _orderStatus.text = [NSString stringWithFormat:@"状态 %@", @"待派送"];
         }
    } else {
        _orderStatus.text = [NSString stringWithFormat:@"状态 %@", [WEOrderStatus getDesc:model.OrderStatus]];
    }
    NSString *time = [WEUtil convertFullDateStringToHourMinute:model.RequiredArrivalTime];
    _orderDate.text = [NSString stringWithFormat:@"就餐时间 %@", time];
}

@end
