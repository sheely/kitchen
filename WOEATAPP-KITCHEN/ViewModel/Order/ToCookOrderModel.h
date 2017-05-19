//
//  ToCookOrderModel.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 17/1/7.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ToCookOrderModel : JSONModel

//DispatchToState = "",
//SalesOrderId = 100072,
//DispatchMethod = "PICKUP",
//Quantity = 1,
//DispatchToCity = "",
//RequiredArrivalTime = "2017-01-07T10:30:00",

@property(nonatomic, assign) NSInteger SalesOrderId;
@property(nonatomic, copy) NSString *RequiredArrivalTime;
@property(nonatomic, assign) NSInteger Quantity;
@property(nonatomic, copy) NSString *DispatchMethod;
@property(nonatomic, copy) NSString *DispatchToState;

@end
