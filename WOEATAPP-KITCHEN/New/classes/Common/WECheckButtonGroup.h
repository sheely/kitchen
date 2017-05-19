//
//  WECheckButtonGroup.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WECheckButtonGroup_SINGLE_CAN_EMPTY    1
#define WECheckButtonGroup_SINGLE_NOT_EMPTY    2

@interface WECheckButtonGroup : UIView

@property(nonatomic, assign) int type;
@property(nonatomic, assign) int checkedIndex;
@property(nonatomic, strong) NSString *selectImageName;
@property(nonatomic, strong) NSString *unSelectImageName;
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, assign) float buttonWidth;
@property(nonatomic, assign) int rowCount;
@property(nonatomic, strong) NSArray *buttonWidthArray;

- (CGSize)originSize;
- (void)setUp;


@end
