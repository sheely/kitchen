//
//  X1DatePickerView.h
//  X1
//
//  Created by xel on 14-4-3.
//  Copyright (c) 2014年 xel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol X1DatePickerViewDelegate <NSObject>

- (void)saveSelectedDate:(NSDate *)date;
- (void)cancelSelectedDate;

@end

@interface X1DatePickerView : UIView

@property (nonatomic, strong) NSDate *pickerData;
@property (nonatomic, assign) UIDatePickerMode pickerMode;
@property (nonatomic, weak) id<X1DatePickerViewDelegate> delegate;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIButton *btnCancel;
@end
