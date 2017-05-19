//
//  WECheckButton.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WECheckButton.h"

@interface WECheckButton()
{
    float _space;
    float _imageWidth;
    UIImageView *_imgView;
    UILabel *_label;
}

@end

@implementation WECheckButton

- (void)setUp
{
    _space = 5;
    _imageWidth = 15;
    [_imgView removeFromSuperview];
    [_label removeFromSuperview];
    UIView *superView = self;
    
    UIImageView *imgView = [UIImageView new];
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.centerY.equalTo(superView.centerY).offset(0);
        make.width.equalTo(_imageWidth);
        make.height.equalTo(_imageWidth);
    }];
    _imgView = imgView;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UICOLOR(150,150,150);
    [superView addSubview:label];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.right).offset(_space);
        make.centerY.equalTo(superView.centerY).offset(0);
    }];
    _label = label;
    _label.text = _title;
    
    [self updateBackgroundImage];
}

- (void)updateBackgroundImage
{
    if (_checked) {
        _imgView.image = [UIImage imageNamed:_selectImageName];
    } else {
        _imgView.image = [UIImage imageNamed:_unSelectImageName];
    }
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    [self updateBackgroundImage];
}

- (void)buttonTapped:(id)sender
{
    _checked = !_checked;
    [self updateBackgroundImage];
}

- (CGSize)originSize
{
    CGFloat width = _imageWidth + _space + _label.intrinsicContentSize.width;
    CGFloat height = MAX(_imageWidth, _label.intrinsicContentSize.height);
    return CGSizeMake(width, height);
}

@end
