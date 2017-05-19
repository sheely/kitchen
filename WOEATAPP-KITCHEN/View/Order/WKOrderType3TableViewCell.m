//
//  WKOrderType3TableViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKOrderType3TableViewCell.h"
#import "OrderModel.h"
#import "LineModel.h"

@implementation WKOrderType3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)setModel:(OrderModel *)model{
//    
//}

-(void)setLineModel:(LineModel *)lineModel{
    _foodNumLabel.text = [NSString stringWithFormat:@"%ld",lineModel.Quantity];
    _foodNameLabel.text = lineModel.Name;
    _foodPriceLabel.text = lineModel.LineTotalValue;
}

@end
