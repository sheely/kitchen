//
//  WECheckButtonGroup.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WECheckButtonGroup.h"
#import "WEUtil.h"
#import "WECheckButton.h"

#define TAG_BUTTON_START 100

@interface WECheckButtonGroup()
{
    int _total;
    float _totalWidth;
    float _totalHeight;
    float _secondY;
}
@end

@implementation WECheckButtonGroup

- (void)setUp
{
    _total = _titleArray.count;
    _totalWidth = 0;
    _totalHeight = 0;
    _secondY = 30;
    
    UIView *superView = self;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *lastView = nil;
    float x = 0;
    for(int i=0; i<_total; i++) {
        NSString *title = _titleArray[i];
        WECheckButton *button = [WECheckButton new];
        button.title = title;
        button.selectImageName = _selectImageName;
        button.unSelectImageName = _unSelectImageName;
        [button setUp];
        button.tag = TAG_BUTTON_START + i;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        float y = 0;
        if (_rowCount > 0 && i >= _rowCount) {
            y = _secondY;
        }
    
        if (i > 0) {
            if (_buttonWidthArray.count) {
                x += [_buttonWidthArray[i-1] floatValue];
            } else {
                x += _buttonWidth;
            }
            if (_rowCount > 0 && i == _rowCount) {
                x = 0;
            }
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(x);
            make.top.equalTo(superView.top).offset(y);
            make.width.equalTo([button originSize].width);
            make.height.equalTo([button originSize].height);
        }];
        if (x + [button originSize].width > _totalWidth) {
            _totalWidth = x + [button originSize].width;
        }
        
        if ([button originSize].height > _totalHeight) {
            _totalHeight = [button originSize].height;
        }
        lastView = button;
    }
    if (_rowCount > 0 && _total > _rowCount) {
        _totalHeight += _secondY;
    }
    [self updateCheckedButton];
}

- (void)updateCheckedButton
{
    for(WECheckButton *button in self.subviews) {
        int index = button.tag - TAG_BUTTON_START;
        if (_checkedIndex == index) {
            button.checked = YES;
        } else {
            button.checked = NO;
        }
    }
}

- (CGSize)originSize
{
    return CGSizeMake(_totalWidth, _totalHeight);
}

- (void)buttonTapped:(UIButton *)button
{
    if (_type == WECheckButtonGroup_SINGLE_CAN_EMPTY) {
        WECheckButton *b = button;
        if (b.checked) {
            _checkedIndex = -1;
        } else {
            _checkedIndex = b.tag - TAG_BUTTON_START;
        }
        [self updateCheckedButton];
        
    } else if (_type == WECheckButtonGroup_SINGLE_NOT_EMPTY) {
        _checkedIndex = button.tag - TAG_BUTTON_START;
        [self updateCheckedButton];
    }
}

@end
