//
//  X1DatePickerView.m
//  X1
//
//  Created by xel on 14-4-3.
//  Copyright (c) 2014年 xel. All rights reserved.
//


#import "X1DatePickerView.h"
#import "UIColor+UPDAddition.h"

@interface X1DatePickerView ()

@end

@implementation X1DatePickerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CAGradientLayer *shadowLine = [CAGradientLayer layer];
        shadowLine.frame = CGRectMake(0, 0, screen_width, 0.5);
        CGColorRef shadowColor = [[UIColor colorWithHexString:@"cacaca" andAlpha:1.0] CGColor];
        shadowLine.colors = @[(__bridge id)shadowColor,(__bridge id)shadowColor];
        shadowLine.opacity = 1.0;
        [self.layer addSublayer:shadowLine];
        
        CAGradientLayer *shadowLine2 = [CAGradientLayer layer];
        shadowLine2.frame = CGRectMake(0, 43, screen_width, 0.5);
        shadowLine2.colors = @[(__bridge id)shadowColor,(__bridge id)shadowColor];
        shadowLine2.opacity = 1.0;
        [self.layer addSublayer:shadowLine2];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, screen_width, self.frame.size.height - 44)];
        _datePicker.maximumDate = [NSDate date];
        
        [self addSubview:_datePicker];
        
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 42, 42)];
        _btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnCancel setTitleColor:[UIColor colorWithHexString:@"2c90c5" andAlpha:1.0] forState:UIControlStateNormal];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(cancelSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCancel];
        
        _btnSave = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 52, 0, 42, 42)];
        _btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnSave setTitleColor:[UIColor colorWithHexString:@"2c90c5" andAlpha:1.0] forState:UIControlStateNormal];
        [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [_btnSave addTarget:self action:@selector(savelSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnSave];
    }
    return self;
}

- (void)setPickerMode:(UIDatePickerMode)pickerMode
{
    self.datePicker.datePickerMode = pickerMode;
    if (self.datePicker.datePickerMode == UIDatePickerModeDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        //NSDate *minBirthDate = [dateFormatter dateFromString:@"2008-01-01"];
        NSDate *defaultBirthDate = [dateFormatter dateFromString:@"2010-01-01"];
        //_datePicker.minimumDate = minBirthDate;
        _datePicker.date = defaultBirthDate;
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    }
}

- (void)setPickerData:(NSDate *)pickerDate
{
    //NSLog(@"pickdate = %@",pickerDate);
    if (pickerDate != nil) {
        self.datePicker.date = pickerDate;
    }
}

- (void)cancelSelectAction:(id)sender
{
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(cancelSelectedDate)]) {
        [self.delegate cancelSelectedDate];
    }
}

- (void)savelSelectAction:(id)sender
{
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(saveSelectedDate:)]) {
        [self.delegate saveSelectedDate:self.datePicker.date];
    }
}

@end
