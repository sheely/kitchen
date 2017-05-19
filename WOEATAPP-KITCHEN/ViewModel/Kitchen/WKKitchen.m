//
//  WKKitchen.m
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2016/11/13.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKKitchen.h"

@implementation WKKitchen

- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

@end
