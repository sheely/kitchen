//
//  WKCardTypeCell.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2017/1/8.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCardTypeCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgChecked;

@property (nonatomic, strong) UILabel *labCardType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)loadData:(NSString *)cardType checked:(BOOL)check;

@end
