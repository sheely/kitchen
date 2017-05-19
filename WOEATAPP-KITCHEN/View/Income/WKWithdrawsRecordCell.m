//
//  WKWithdrawsRecordCell.m
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2017/1/8.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WKWithdrawsRecordCell.h"
#import "WKWithdrawRecord.h"
#import "CashOutModel.h"
#import "OrderModel.h"

@interface WKWithdrawsRecordCell()

@property (nonatomic , strong) UILabel *labTime;
@property (nonatomic , strong) UILabel *labMoney;
@property (nonatomic , strong) UILabel *labState;

@end

@implementation WKWithdrawsRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 30)];
        _labTime.text = @"";
        [self addSubview:_labTime];
        
        _labMoney = [[UILabel alloc] initWithFrame:CGRectMake(screen_width / 2, 5, 80, 30)];
        _labMoney.text = @"";
        [self addSubview:_labMoney];

        
        _labState = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - 80, 5, 60, 30)];
        _labState.text = @"";
        [self addSubview:_labState];
    }
    return self;
}

- (void)loadData:(CashOutModel *)record{
    
    if (record.TimeCreated.length > 11) {
        _labTime.text = [record.TimeCreated substringToIndex:10];
    }
    _labMoney.text = [NSString stringWithFormat:@"$%ld",(long)record.CashoutValue];
    _labState.text = @"审核中";
    
    [_labTime setFrame:CGRectMake(20, 5, 140, 30)];
    [_labMoney setFrame:CGRectMake(screen_width / 2, 5, 80, 30)];
    [_labState setFrame:CGRectMake(screen_width - 90, 5, 60, 30)];

}

- (void)loadMonthData:(OrderModel *)record{
    if (record.RequiredArrivalTime.length > 11) {
        _labTime.text = [record.RequiredArrivalTime substringToIndex:10];
    }
    _labMoney.text = [NSString stringWithFormat:@"订单号%ld",(long)record.Id];
    _labState.text = [NSString stringWithFormat:@"$%ld",(long)[record.TotalValue integerValue]];
    [_labTime setFrame:CGRectMake(20, 5, 140, 30)];
    [_labMoney setFrame:CGRectMake(screen_width / 2-40, 5, 120, 100)];
    [_labState setFrame:CGRectMake(screen_width - 80, 5, 80, 30)];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_cellType == 1) {
        [_labTime setFrame:CGRectMake(20, 5, 140, 30)];
        [_labMoney setFrame:CGRectMake(screen_width / 2-40, 5, 120, 100)];
        [_labState setFrame:CGRectMake(screen_width - 80, 5, 80, 30)];
  
    }else{
        [_labTime setFrame:CGRectMake(20, 5, 140, 30)];
        [_labMoney setFrame:CGRectMake(screen_width / 2, 5, 80, 30)];
        [_labState setFrame:CGRectMake(screen_width - 90, 5, 60, 30)];
    }
    
}


@end
