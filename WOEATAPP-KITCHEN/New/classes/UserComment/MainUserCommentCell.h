//
//  MainUserCommentCell.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/17.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEModelGeKitchenCommentListPositive.h"

@class MainUserCommentCell;
@protocol MainUserCommentCellTapDelegate <NSObject>

- (void)replyButtonTapped:(MainUserCommentCell *)cell;

@end

@interface MainUserCommentCell : UITableViewCell

@property(nonatomic, assign) BOOL showReplyButton;
@property(nonatomic, weak) id<MainUserCommentCellTapDelegate> controller;


+ (float)getHeightWithData:(WEModelGeKitchenCommentListPositiveCommentList *)data;
- (void)setData:(WEModelGeKitchenCommentListPositiveCommentList *)data;

@end
