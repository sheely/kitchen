//
//  WKOrderType1TableViewCell.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/22.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKOrderTypeBaseTableViewCell.h"

@interface WKOrderType1TableViewCell : WKOrderTypeBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfTakenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
