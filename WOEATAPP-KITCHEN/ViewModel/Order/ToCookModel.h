//
//  ToCookModel.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/28.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface ToCookModel : JSONModel
@property(nonatomic, assign) NSInteger ItemId;
@property(nonatomic, copy) NSString *ItemName;
@property(nonatomic, assign) NSInteger Quantity;

@end
