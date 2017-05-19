//
//  WKOrderType4TableViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKOrderType4TableViewCell.h"
#import "OrderModel.h"

@implementation WKOrderType4TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(OrderModel *)model{
    _messageText.text = model.Message;
    
}

@end
