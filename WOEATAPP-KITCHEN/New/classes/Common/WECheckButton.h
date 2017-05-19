//
//  WECheckButton.h
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WECheckButton :  UIButton

@property(nonatomic, assign) BOOL checked;
@property(nonatomic, strong) NSString *selectImageName;
@property(nonatomic, strong) NSString *unSelectImageName;
@property(nonatomic, strong) NSString *title;

- (CGSize)originSize;
- (void)setUp;
@end
