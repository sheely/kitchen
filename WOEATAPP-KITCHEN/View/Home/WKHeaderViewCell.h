//
//  WKHeaderViewCell.h
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/19.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKHeaderViewCellDelegate <NSObject>

@optional
- (void)didQueryCookMenu;
- (void)didQueryTodayOrder;
- (void)didQueryTomorrowOrder;

@end

@interface WKHeaderViewCell : UITableViewCell

@property (nonatomic, weak) id<WKHeaderViewCellDelegate> delegate;

@property (nonatomic, strong) UILabel *labCookNum;
@property (nonatomic, strong) UILabel *labTodayOrderNum;
@property (nonatomic, strong) UILabel *labTomorrowOrderNum;

@end
