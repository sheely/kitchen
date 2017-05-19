//
//  WKMenuSettingCell.h
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKMenuModel;

@protocol WKMenuSettingCellDelegate <NSObject>

@optional
- (void)editMenuWithModel:(WKMenuModel *)model;
- (void)editMenu:(NSString *)itemId;
- (void)deleteMenu:(NSString *)itemId;
- (void)activateMenu:(NSString *)itemId;
- (void)deActivateMenu:(NSString *)itemId;

@end

@interface WKMenuSettingCell : UITableViewCell

@property (nonatomic, weak) id<WKMenuSettingCellDelegate> delegate;
@property (nonatomic, strong) UIButton *btnEditMenu;
@property (nonatomic, strong) UIButton *btnDeleteMenu;
@property (nonatomic, assign) BOOL tagStatus;
@property (nonatomic, strong) WKMenuModel* model;
@end
