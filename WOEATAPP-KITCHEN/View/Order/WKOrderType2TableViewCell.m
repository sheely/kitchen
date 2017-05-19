//
//  WKOrderType2TableViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/22.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKOrderType2TableViewCell.h"
#import "OrderModel.h"

@implementation WKOrderType2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(OrderModel *)model{
    _orderNum.text = [NSString stringWithFormat:@"%ld",(long)model.Id];
    _userNameLabel.text = model.ContactName;
    _mobileNumLabel.text =[NSString stringWithFormat:@"%ld", model.ContactNumber];
    _dispatchTimeLabel.text = model.TimeDispatched;
}


@end
