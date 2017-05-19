//
//  WEOrderDishListView.m
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderDishListView.h"
#import "WEUtil.h"
#import "WEOrderDishCell.h"
#import "UIImageView+WebCache.h"
#import "WEModelCommon.h"

@interface WEOrderDishListView()
{
    UILabel *_totalPay;
}

@end

@implementation WEOrderDishListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *superView = self;
        
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.allowsSelection = NO;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[WEOrderDishCell class] forCellReuseIdentifier:@"WEOrderDishCell"];

        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.top.equalTo(superView.top).offset(5);
            make.bottom.equalTo(superView.bottom);
            //_dishListViewHeightConstraint = make.height.equalTo(0);
        }];
        _tableView = tableView;
        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [superView addSubview:bottomLine];
        [bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(20);
            make.right.equalTo(superView.right).offset(-20);
            make.height.equalTo(0.5);
        }];
        
        UILabel *totalPay = [UILabel new];
        totalPay.numberOfLines = 1;
        totalPay.textAlignment = NSTextAlignmentRight;
        totalPay.font = [UIFont systemFontOfSize:13];
        totalPay.textColor = [UIColor blackColor];
        //totalPay.text = @"$100.00";
        [superView addSubview:totalPay];
        [totalPay sizeToFit];
        [totalPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-20);
            make.top.equalTo(bottomLine.bottom).offset(7);
            make.bottom.equalTo(superView.bottom).offset(-15);
        }];
        _totalPay = totalPay;
    }
    return self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _order.Order.Lines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEOrderDishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEOrderDishCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [WEOrderDishCell new];
    }
    [cell setModel:[_order.Order.Lines objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)setOrder:(WEModelGetOrder *)order
{
    _order = order;
    [_tableView reloadData];
    _totalPay.text = [NSString stringWithFormat:@"$%.2f",_order.Order.PayableValue];
    //[self performSelector:@selector(updateUI) withObject:nil afterDelay:0];
}

+ (float)getHeightWithOrder:(WEModelGetOrder *)order
{
    return 5 + order.Order.Lines.count*30 + 5 + 0.5 + 7 + 14 + 15;
}

@end
