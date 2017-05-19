//
//  LineModel.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/31.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LineModel : JSONModel

@property(nonatomic, assign) NSInteger DisplayOrder;
@property(nonatomic, assign) NSInteger Id;
@property(nonatomic, assign) NSInteger ItemId;
@property(nonatomic, assign) NSInteger Quantity;
@property(nonatomic, assign) NSInteger SalesOrderId;
@property(nonatomic, assign) NSInteger UserCouponId;

@property(nonatomic, copy) NSString *LineTotalValue;
@property(nonatomic, copy) NSString *Name;
@property(nonatomic, copy) NSString *Reference;


@end
