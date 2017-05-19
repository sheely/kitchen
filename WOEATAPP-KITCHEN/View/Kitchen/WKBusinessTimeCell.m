//
//  WKBusinessTimeCell.m
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2016/12/22.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKBusinessTimeCell.h"
#import "WKBusinessDayTime.h"

@interface WKBusinessTimeCell()

@property (nonatomic, strong) UILabel *labWeek;

@end

@implementation WKBusinessTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labWeek = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 50)];
        _labWeek.font = [UIFont systemFontOfSize:13];
        [self addSubview:_labWeek];
        
        [self addSubview:self.morStartTimeField];
        
        [self addSubview:self.morEndTimeField];

        [self addSubview:self.afterStartTimeField];

        [self addSubview:self.afterEndTimeField];
    }
    return self;
}

- (UITextField *)morStartTimeField
{
    if (_morStartTimeField == nil) {
        CGFloat width = (screen_width - 100 - 10  - 20) / 2;
        _morStartTimeField = [[UITextField alloc] initWithFrame:CGRectMake(100, 7, width, 30)];
        _morStartTimeField.font = [UIFont systemFontOfSize:14];
        _morStartTimeField.textColor = [UIColor colorWithHexString:@"333333" andAlpha:1.0];
        _morStartTimeField.textAlignment = NSTextAlignmentCenter;
        _morStartTimeField.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5" andAlpha:1.0].CGColor;
        _morStartTimeField.layer.borderWidth = 0.5;
        _morStartTimeField.layer.cornerRadius = 5;
        
        UIImageView *imgTextBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,width, 30)];
        imgTextBack.userInteractionEnabled = YES;
        imgTextBack.tag = 2001;
        [imgTextBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapToChooseTime:)]];
        [_morStartTimeField addSubview:imgTextBack];
    }
    return _morStartTimeField;
}

- (UITextField *)morEndTimeField
{
    if (_morEndTimeField == nil) {
        CGFloat width = (screen_width - 100 - 10  - 20) / 2;
        _morEndTimeField = [[UITextField alloc] initWithFrame:CGRectMake(screen_width - width - 20, 7, width, 30)];
        _morEndTimeField.font = [UIFont systemFontOfSize:14];
        _morEndTimeField.textColor = [UIColor colorWithHexString:@"333333" andAlpha:1.0];
        _morEndTimeField.textAlignment = NSTextAlignmentCenter;
        _morEndTimeField.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5" andAlpha:1.0].CGColor;
        _morEndTimeField.layer.borderWidth = 0.5;
        _morEndTimeField.layer.cornerRadius = 5;
        
        UIImageView *imgTextBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,width, 30)];
        imgTextBack.userInteractionEnabled = YES;
        imgTextBack.tag = 2002;
        [imgTextBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapToChooseTime:)]];
        [_morEndTimeField addSubview:imgTextBack];
    }
    return _morEndTimeField;
}

- (UITextField *)afterStartTimeField
{
    if (_afterStartTimeField == nil) {
        CGFloat width = (screen_width - 100 - 10  - 20) / 2;
        _afterStartTimeField = [[UITextField alloc] initWithFrame:CGRectMake(100, 45,width, 30)];
        _afterStartTimeField.font = [UIFont systemFontOfSize:14];
        _afterStartTimeField.textColor = [UIColor colorWithHexString:@"333333" andAlpha:1.0];
        _afterStartTimeField.textAlignment = NSTextAlignmentCenter;
        _afterStartTimeField.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5" andAlpha:1.0].CGColor;
        _afterStartTimeField.layer.borderWidth = 0.5;
        _afterStartTimeField.layer.cornerRadius = 5;
        
        UIImageView *imgTextBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width,30)];
        imgTextBack.userInteractionEnabled = YES;
        imgTextBack.tag = 2003;
        [imgTextBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapToChooseTime:)]];
        [_afterStartTimeField addSubview:imgTextBack];
    }
    return _afterStartTimeField;
}

- (UITextField *)afterEndTimeField
{
    if (_afterEndTimeField == nil) {
        CGFloat width = (screen_width - 100 - 10  - 20) / 2;
        _afterEndTimeField = [[UITextField alloc] initWithFrame:CGRectMake(screen_width - width - 20, 45,width,30)];
        _afterEndTimeField.font = [UIFont systemFontOfSize:14];
        _afterEndTimeField.textColor = [UIColor colorWithHexString:@"333333" andAlpha:1.0];
        _afterEndTimeField.textAlignment = NSTextAlignmentCenter;
        _afterEndTimeField.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5" andAlpha:1.0].CGColor;
        _afterEndTimeField.layer.borderWidth = 0.5;
        _afterEndTimeField.layer.cornerRadius = 5;
        
        UIImageView *imgTextBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,width,30)];
        imgTextBack.userInteractionEnabled = YES;
        imgTextBack.tag = 2004;
        [imgTextBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapToChooseTime:)]];
        [_afterEndTimeField addSubview:imgTextBack];
    }
    return _afterEndTimeField;
}

- (void)loadData:(WKBusinessDayTime *)businessTime
{
    self.businessTime = businessTime;

    self.labWeek.text = businessTime.weekdayDisplay;
    if (businessTime.firstBeginTime > 0) {
        self.morStartTimeField.text = [self timeToString:businessTime.firstBeginTime];
    }else{
        self.morStartTimeField.text = @"未设置";
    }
    
    if (businessTime.firstEndTime > 0) {
        self.morEndTimeField.text = [self timeToString:businessTime.firstEndTime];
    }else{
        self.morEndTimeField.text = @"未设置";
    }
    
    if (businessTime.secondBeginTime > 0) {
        self.afterStartTimeField.text = [self timeToString:businessTime.secondBeginTime];
    }else{
        self.afterStartTimeField.text = @"未设置";
    }
    
    if (businessTime.secondEndTime > 0) {
        self.afterEndTimeField.text = [self timeToString:businessTime.secondEndTime];
    }else{
        self.afterEndTimeField.text = @"未设置";
    }
}

- (NSString *)timeToString:(NSInteger)time
{
    return  [NSString stringWithFormat:@"%.2d:%.2d",(int)(time/ 60), (int)(time% 60) ];
}

- (void)tapToChooseTime:(UITapGestureRecognizer *)recognizer
{
    NSInteger tag = recognizer.view.tag - 2001;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapToChooseTime:tag:)]) {
        [self.delegate tapToChooseTime:self.businessTime tag:tag];
    }
}

@end
