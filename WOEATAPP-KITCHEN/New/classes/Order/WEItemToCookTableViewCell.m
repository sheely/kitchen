//
//  WEItemToCookTableViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEItemToCookTableViewCell.h"
#import "WEUtil.h"
#import "WEItemToCookCellButton.h"



#define TAG_BUTTON_START  100

#define TOP_BUTTON_HEIGHT 30
#define ORDER_BUTTON_HEIGHT 45

@interface WEItemToCookTableViewCell()
{
    UILabel *_name;
    UILabel *_amount;
    UIImageView *_arrow;
    UIButton *_topButton;
    UILabel *_loadingLabel;
    WEModelGetItemToCookListItemToCookList *_item;
    WEModelGetItemToCookPerOrderList *_orderData;
}

@end

@implementation WEItemToCookTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *superView = self.contentView;
  
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right).offset(0);
        make.top.equalTo(superView.top);
        make.height.equalTo(TOP_BUTTON_HEIGHT);
    }];
    //button.backgroundColor = [UIColor blueColor];
    _topButton = button;
    
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = [UIColor blackColor];
    [superView addSubview:name];
    [name sizeToFit];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(15);
        make.top.equalTo(_topButton.top).offset(5);
    }];
    _name = name;
    
    UIImageView *arrow = [UIImageView new];
    UIImage *arrowImg = [UIImage imageNamed:@"gray_arrow_right"];
    arrow.image = arrowImg;
    [superView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-20);
        make.centerY.equalTo(name.centerY);
        make.width.equalTo(arrowImg.size.width);
        make.height.equalTo(arrowImg.size.height);
    }];
    _arrow = arrow;
    
    UILabel *amount = [UILabel new];
    amount.numberOfLines = 1;
    amount.textAlignment = NSTextAlignmentRight;
    amount.font = [UIFont systemFontOfSize:14];
    amount.textColor = [UIColor blackColor];
    [superView addSubview:amount];
    [amount sizeToFit];
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-[WEUtil getScreenWidth]*0.15);
        make.centerY.equalTo(name.centerY);
        make.left.equalTo(name.right);
    }];
    _amount = amount;
    
    UILabel *loading = [UILabel new];
    loading.numberOfLines = 1;
    loading.textAlignment = NSTextAlignmentCenter;
    loading.font = [UIFont systemFontOfSize:12];
    loading.textColor = [UIColor lightGrayColor];
    [superView addSubview:loading];
    [loading sizeToFit];
    [loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.bottom).offset(0);
        make.centerX.equalTo(button.centerX);
    }];
    _loadingLabel = loading;
    _loadingLabel.text = @"正在加载...";
    _loadingLabel.hidden = YES;
    return self;
}

- (void)setItemData:(WEModelGetItemToCookListItemToCookList *)data
{
    _item = data;
    if (!_item) {
        return;
    }
    if (![data isKindOfClass:[WEModelGetItemToCookListItemToCookList class]]) {
        NSLog(@"setData class error, should be %@, but %@", [WEModelGetItemToCookListItemToCookList class], [data class]);
        return;
    }
    
    _name.text = _item.ItemName;
    _amount.text = [NSString stringWithFormat:@"%d份", _item.Quantity];
    
}


- (void)setOrderData:(WEModelGetItemToCookPerOrderList *)data
{
    if (!data) {
        return;
    }
    
    _orderData = data;
    _loadingLabel.hidden = YES;
    if([_orderData isEqual:[NSNull null]]) {
        if (_isExpand) {
            _loadingLabel.hidden = NO;
        }
        return;
    }
    
    if (![data isKindOfClass:[WEModelGetItemToCookPerOrderList class]]) {
        NSLog(@"setData class error, should be %@, but %@", [WEModelGetItemToCookPerOrderList class], [data class]);
        return;
    }
    
    for(UIView *v in self.contentView.subviews) {
        if ([v isKindOfClass:[WEItemToCookCellButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    UIView *superView = self.contentView;
    WEItemToCookCellButton *lastButton = nil;
    for(int i=0; i<data.ItemToCookPerOrderList.count; i++) {
        WEModelGetItemToCookPerOrderListItemToCookPerOrderList *item = [data.ItemToCookPerOrderList objectAtIndex:i];
        WEItemToCookCellButton *button = [WEItemToCookCellButton new];
        [button setModel:item];
        button.tag = TAG_BUTTON_START + i;
        [button addTarget:self action:@selector(orderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(_topButton.bottom).offset(0);
            } else {
                make.top.equalTo(lastButton.bottom).offset(5);
            }
            make.left.equalTo(_name.left).offset(-10);
            make.right.equalTo(_amount.right).offset(5);
            make.height.equalTo(ORDER_BUTTON_HEIGHT);
        }];
        lastButton = button;
        
        if (_isExpand) {
            button.hidden = NO;
        } else {
            button.hidden = YES;
        }
    }

}

- (void)setIsExpand:(BOOL)isExpand
{
    _isExpand = isExpand;
    if (isExpand) {
        UIImage *arrowImg = [UIImage imageNamed:@"gray_arrow_down"];
        _arrow.image = arrowImg;
        [_arrow mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(arrowImg.size.width);
            make.height.equalTo(arrowImg.size.height);
        }];
        
        
        
    } else {
        UIImage *arrowImg = [UIImage imageNamed:@"gray_arrow_right"];
        _arrow.image = arrowImg;
        [_arrow mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(arrowImg.size.width);
            make.height.equalTo(arrowImg.size.height);
        }];
    }
}

- (void)orderButtonTapped:(UIButton *)button
{
    int i = button.tag - TAG_BUTTON_START;
    WEModelGetItemToCookPerOrderListItemToCookPerOrderList *item = [_orderData.ItemToCookPerOrderList objectAtIndex:i];
    if ([_itemDelegate respondsToSelector:@selector(cellOrderButtonTapped:)]) {
        [_itemDelegate cellOrderButtonTapped:item.SalesOrderId];
    }
}

- (void)topButtonTapped:(UIButton *)button
{
    if ([_itemDelegate respondsToSelector:@selector(cellArrowTapped:)]) {
        [_itemDelegate cellArrowTapped:self];
    }
}

+ (float)getHeightWithData:(WEModelGetItemToCookPerOrderList *)data isExpand:(BOOL)isExpand
{
    if (isExpand) {
        if ([data isEqual:[NSNull null]]) {
            return TOP_BUTTON_HEIGHT + 20;
        } else {
            return TOP_BUTTON_HEIGHT + data.ItemToCookPerOrderList.count * (ORDER_BUTTON_HEIGHT + 5) + 10;
        }
    } else {
        return TOP_BUTTON_HEIGHT + 5;
    }
}

@end
