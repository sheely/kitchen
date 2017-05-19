//
//  WKMenuCoverCell.h
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPhotoDelegate.h"

@interface WKMenuCoverCell : UITableViewCell
@property (nonatomic,weak) id<AddPhotoDelegate> delegate;
@property (nonatomic, strong) NSArray *photos;

- (void)loadImages:(NSArray *)images;

@end
