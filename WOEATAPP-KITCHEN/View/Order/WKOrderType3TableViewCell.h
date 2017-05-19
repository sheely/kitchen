//
//  WKOrderType3TableViewCell.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKOrderTypeBaseTableViewCell.h"
@class LineModel;
@interface WKOrderType3TableViewCell : WKOrderTypeBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellHeader;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodPriceLabel;

@property (nonatomic, strong) LineModel* lineModel;

@end
