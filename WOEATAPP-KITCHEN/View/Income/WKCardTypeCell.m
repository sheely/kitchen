//
//  WKCardTypeCell.m
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2017/1/8.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WKCardTypeCell.h"

@implementation WKCardTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgChecked = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        [self addSubview:_imgChecked];
        
        _labCardType = [[UILabel  alloc] initWithFrame:CGRectMake(50, 5, screen_width - 70, 30)];
//        [_labCardType mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(CGRectGetMaxX(_imgChecked.frame));
//            make.width.mas_equalTo(screen_width - 40);
//            make.center.equalTo(self);
//        }];
        [self addSubview:_labCardType];
    }
    return self;
}

- (void)loadData:(NSString *)cardType checked:(BOOL)check
{
    if (check) {
        self.imgChecked.image = [UIImage imageNamed:@"check-sign"];
    }else{
        self.imgChecked.image = [UIImage imageNamed:@"circle"];
    }
    self.labCardType.text = cardType;
}
@end
