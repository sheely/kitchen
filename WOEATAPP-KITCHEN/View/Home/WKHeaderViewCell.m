//
//  WKHeaderViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/19.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKHeaderViewCell.h"

@interface WKHeaderViewCell()

@property (nonatomic, strong) UILabel *labCook;
@property (nonatomic, strong) UILabel *labTodayOrder;
@property (nonatomic, strong) UILabel *labTomorrowOrder;

@end


@implementation WKHeaderViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#3F3F40" andAlpha:1.0];

        CGFloat originX  = 30;
        CGFloat width = (screen_width - 30 * 4) / 3;
        UIImageView *imgCook = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, width,width)];
        imgCook.image = [UIImage imageNamed:@"home_items"];
        [self addSubview:imgCook];

        _labCookNum = [[UILabel alloc] initWithFrame:CGRectMake(0, width - 30, width, 30)];
//        _labCookNum.text = @"70";
        _labCookNum.textColor = [UIColor whiteColor];
        _labCookNum.textAlignment = NSTextAlignmentCenter;
        [imgCook addSubview:_labCookNum];
        
        UIImageView *imgCookCover = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, width,width)];
        imgCookCover.userInteractionEnabled = YES;
        [imgCookCover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cookMenu)]];
        [self addSubview:imgCookCover];

        _labCook = [[UILabel alloc] initWithFrame:CGRectMake(originX-20, CGRectGetMaxY(imgCook.frame), width+40, 30)];
        _labCook.text = @"要做的菜";
        _labCook.textAlignment = NSTextAlignmentCenter;
        _labCook.textColor = [UIColor whiteColor];
        [self addSubview:_labCook];
        
        UIImageView *imgTodayOrder = [[UIImageView alloc] initWithFrame:CGRectMake(originX + CGRectGetMaxX(imgCook.frame), 10, width,width)];
        imgTodayOrder.image = [UIImage imageNamed:@"home_today"];
        [self addSubview:imgTodayOrder];

        _labTodayOrderNum = [[UILabel alloc] initWithFrame:CGRectMake(0, width - 30, width, 30)];
//        _labTodayOrderNum.text = @"40";
        _labTodayOrderNum.textColor = [UIColor whiteColor];
        _labTodayOrderNum.textAlignment = NSTextAlignmentCenter;
        [imgTodayOrder addSubview:_labTodayOrderNum];
        
        UIImageView *imgTodayOrderCover = [[UIImageView alloc] initWithFrame:CGRectMake(originX + CGRectGetMaxX(imgCook.frame), 10, width,width)];
        imgTodayOrderCover.userInteractionEnabled = YES;
        [imgTodayOrderCover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todayOrder)]];
        [self addSubview:imgTodayOrderCover];

        
        _labTodayOrder = [[UILabel alloc] initWithFrame:CGRectMake(originX + CGRectGetMaxX(imgCook.frame)-20, CGRectGetMaxY(imgTodayOrder.frame), width+40, 30)];
        _labTodayOrder.text = @"今日订单";
        _labTodayOrder.textAlignment = NSTextAlignmentCenter;
        _labTodayOrder.textColor = [UIColor whiteColor];
        [self addSubview:_labTodayOrder];
        
        UIImageView *imgTomorrowOrder = [[UIImageView alloc] initWithFrame:CGRectMake(originX + CGRectGetMaxX(imgTodayOrder.frame), 10, width,width)];
        imgTomorrowOrder.image = [UIImage imageNamed:@"home_tomorrow"];
        [self addSubview:imgTomorrowOrder];

        _labTomorrowOrderNum = [[UILabel alloc] initWithFrame:CGRectMake(0, width - 30, width, 30)];
//        _labTomorrowOrderNum.text = @"50";
        _labTomorrowOrderNum.textColor = [UIColor whiteColor];
        _labTomorrowOrderNum.textAlignment = NSTextAlignmentCenter;
        [imgTomorrowOrder addSubview:_labTomorrowOrderNum];
        
        UIImageView *imgTomorrowOrderCover = [[UIImageView alloc] initWithFrame:CGRectMake(originX + CGRectGetMaxX(imgTodayOrder.frame), 10, width,width)];
        imgTomorrowOrderCover.userInteractionEnabled = YES;
        [imgTomorrowOrderCover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tomorrowOrder)]];
        [self addSubview:imgTomorrowOrderCover];

        _labTomorrowOrder = [[UILabel alloc] initWithFrame:CGRectMake(originX + CGRectGetMaxX(imgTodayOrder.frame)-20, CGRectGetMaxY(imgTomorrowOrder.frame), width+40, 30)];
        _labTomorrowOrder.text = @"明日订单";
        _labTomorrowOrder.textAlignment = NSTextAlignmentCenter;
        _labTomorrowOrder.textColor = [UIColor whiteColor];
        [self addSubview:_labTomorrowOrder];
    }
    return self;
}

- (void)cookMenu
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didQueryCookMenu)]) {
        [self.delegate didQueryCookMenu];
    }
}

- (void)todayOrder
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didQueryTodayOrder)]) {
        [self.delegate didQueryTodayOrder];
    }
}

- (void)tomorrowOrder
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didQueryTomorrowOrder)]) {
        [self.delegate didQueryTomorrowOrder];
    }
}
@end
