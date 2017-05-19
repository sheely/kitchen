//
//  WKMenuViewCell.h
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/19.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CellMenuHeight ((screen_height - 46 - ((screen_width - 30 * 4) / 3 + 50) - 80) / 3.0)

@interface WKMenuViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgLeftMenu;
@property (nonatomic, strong) UILabel *labLeftMenu;
@property (nonatomic, strong) UIImageView *imgRightMenu;
@property (nonatomic, strong) UILabel *labRightMenu;

@end
