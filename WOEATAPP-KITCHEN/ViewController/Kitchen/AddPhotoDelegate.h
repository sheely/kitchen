//
//  AddPhotoDelegate.h
//  HeTang
//
//  Created by Huang Yirong on 16/7/25.
//  Copyright © 2016年 sogou.com Inc. All rights reserved.
//


@class WKKitchenCoverCell;
@class WKMenuCoverCell;

@protocol AddPhotoDelegate<NSObject>
- (void)didAddButtonClick:(WKKitchenCoverCell*)tableViewCell;
- (void)didMenuAddButtonClick:(WKMenuCoverCell*)tableViewCell;

@end
