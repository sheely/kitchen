//
//  WKMenuSettingCell.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKMenuSettingCell.h"
#import "WKMenuModel.h"
#import "UIImageView+WebCache.h"

@interface WKMenuSettingCell(){
    NSInteger isActive;
}

@property (nonatomic, strong) UIImageView *imgCover;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labPrice;
@property (nonatomic, strong) UILabel *tagLabel;


@end

@implementation WKMenuSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgCover = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 120, 120)];
        _imgCover.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imgCover];
        [_imgCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self),
            make.width.mas_equalTo(120),
            make.leftMargin.mas_equalTo(20),
            make.topMargin.mas_equalTo(10);
        }];
        
        _labName = [UILabel new];
        [_labName setText:@"脆皮猪肉"];
        [_labName setFont:[UIFont systemFontOfSize:16]];
        [_labName setBackgroundColor:[UIColor clearColor]];
        [_labName setTextColor:[UIColor blackColor]];
        [self addSubview:_labName];
        [_labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgCover.mas_right).offset(15);
            make.top.equalTo(_imgCover),
            make.height.mas_equalTo(20);
        }];
        
        
        _tagLabel = [UILabel new];
        [_tagLabel setText:@"招牌菜"];
        [_tagLabel setFont:[UIFont systemFontOfSize:13]];
        [_tagLabel setBackgroundColor:[UIColor lightGrayColor]];
        [_tagLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_tagLabel];
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labName.mas_right).offset(5);
            make.centerY.equalTo(_labName),
            make.height.mas_equalTo(20);
        }];
        [_tagLabel.layer  setCornerRadius:3];
        _tagLabel.layer.masksToBounds = YES;
        
        
        CGFloat originX = CGRectGetMaxX(_imgCover.frame) + 6;
        _labPrice = [[UILabel alloc] initWithFrame:CGRectMake(originX, 45, screen_width - originX - 10, 15)];
        _labPrice.textColor = [UIColor lightGrayColor];
        _labPrice.font = [UIFont systemFontOfSize:15];
        _labPrice.text = @"";
        [self addSubview:_labPrice];
        
        _btnEditMenu = [[UIButton alloc]initWithFrame:CGRectMake(originX,90,60,23)];
        [_btnEditMenu setTitle:@"编辑" forState:UIControlStateNormal];
        [_btnEditMenu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnEditMenu.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_btnEditMenu addTarget:self action:@selector(editMenu:)forControlEvents:UIControlEventTouchUpInside];
        _btnEditMenu.layer.cornerRadius = 5;
        _btnEditMenu.layer.masksToBounds = YES;
        _btnEditMenu.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_btnEditMenu];
        
        _btnDeleteMenu = [[UIButton alloc]initWithFrame:CGRectMake(originX + 80,90,60,23)];
        [_btnDeleteMenu setTitle:@"下架" forState:UIControlStateNormal];
        [_btnDeleteMenu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnDeleteMenu.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [_btnDeleteMenu addTarget:self action:@selector(deActivateMenu:)forControlEvents:UIControlEventTouchUpInside];
        _btnDeleteMenu.layer.cornerRadius = 5;
        _btnDeleteMenu.layer.masksToBounds = YES;
        _btnDeleteMenu.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_btnDeleteMenu];
    }
    return self;
}

-(void)setModel:(WKMenuModel *)model{
    if (model == _model) {
        return;
    }
    _model = model;
    
    _labName.text = _model.Name;
    [_imgCover sd_setImageWithURL:[NSURL URLWithString:_model.PortraitImageUrl] placeholderImage:nil options:SDWebImageRetryFailed];
    _labPrice.text = [NSString stringWithFormat:@"$%.2f",_model.UnitPrice];
    if (_model.IsFeatured == 1) {
        _tagLabel.hidden = NO;
    }else{
        _tagLabel.hidden = YES;
    }
    isActive = _model.IsActive;
    if (isActive == 1) {
        [_btnDeleteMenu setTitle:@"下架" forState:UIControlStateNormal];
    }else{
        [_btnDeleteMenu setTitle:@"上架" forState:UIControlStateNormal];

    }
    
//    _tagStatus = YES;
//    if (_tagStatus) {
//        _tagLabel.hidden = NO;
//    }else{
//        _tagLabel.hidden = YES;
//    }
}

- (void)editMenu:(id)sender
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(editMenu:)]) {
//        [self.delegate editMenu:_model.Id];
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editMenuWithModel:)]) {
        [self.delegate editMenuWithModel:_model];
    }
}

- (void)deActivateMenu:(id)sender
{
    
    if (isActive == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deActivateMenu:)]) {
            [self.delegate deActivateMenu:_model.Id];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(activateMenu:)]) {
            [self.delegate activateMenu:_model.Id];
        }
    }

}


@end
