//
//  WKBusinessTimeCell.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2016/12/22.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKBusinessDayTime;

@protocol WKBusinessTimeCellDelegate <NSObject>

@optional
- (void)tapToChooseTime:(WKBusinessDayTime *)businessTime tag:(NSInteger)tag;

@end

@interface WKBusinessTimeCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, weak) id<WKBusinessTimeCellDelegate> delegate;
@property (nonatomic, strong) WKBusinessDayTime *businessTime;
@property (nonatomic, strong) UITextField *morStartTimeField;
@property (nonatomic, strong) UITextField *morEndTimeField;
@property (nonatomic, strong) UITextField *afterStartTimeField;
@property (nonatomic, strong) UITextField *afterEndTimeField;

- (void)loadData:(WKBusinessDayTime *)businessTime;

@end
