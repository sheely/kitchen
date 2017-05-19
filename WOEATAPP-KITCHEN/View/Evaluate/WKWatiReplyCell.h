//
//  WKWatiReplyCell.h
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKEvaluate;

@protocol WKWatiReplyCellDelegate <NSObject>

@optional
- (void)replyClientEvaluate:(WKEvaluate *)evaluate;

@end

@interface WKWatiReplyCell : UITableViewCell

@property (nonatomic, weak) id<WKWatiReplyCellDelegate> delegate;

@property (nonatomic, strong) WKEvaluate *evaluate;

- (void)loadData:(WKEvaluate *)evaluate;

@end
