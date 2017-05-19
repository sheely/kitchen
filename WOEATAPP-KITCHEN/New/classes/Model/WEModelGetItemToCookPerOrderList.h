//
//  WEModelGetItemToCookPerOrderList.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetItemToCookPerOrderListItemToCookPerOrderList
@end

@interface WEModelGetItemToCookPerOrderListItemToCookPerOrderList : JSONModel
@property(nonatomic, strong) NSString<Optional> *DispatchToState;
@property(nonatomic, strong) NSString<Optional> *SalesOrderId;
@property(nonatomic, strong) NSString<Optional> *DispatchMethod;
@property(nonatomic, assign) int Quantity;
@property(nonatomic, strong) NSString<Optional> *DispatchToCity;
@property(nonatomic, strong) NSString<Optional> *RequiredArrivalTime;
@end

@interface WEModelGetItemToCookPerOrderList : JSONModel
@property(nonatomic, strong) NSString<Optional> *ItemId;
@property(nonatomic, strong) NSArray<WEModelGetItemToCookPerOrderListItemToCookPerOrderList> *ItemToCookPerOrderList;
@property(nonatomic, strong) NSString<Optional> *Date;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@end

