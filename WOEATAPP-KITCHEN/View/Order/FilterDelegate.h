//
//  FilterDelegate.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 17/1/8.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FilterDelegate <NSObject>
- (void)orderStatus:(NSString *)status;
- (void)dispatchMethod:(NSString *)status;
- (void)orderBy:(NSString *)status;

@end
