//
//  WEModelGetKitchenSalesByMonth.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetKitchenSalesByMonthSalesByMonthList
@end

@interface WEModelGetKitchenSalesByMonthSalesByMonthList : JSONModel
@property(nonatomic, assign) int Month;
@property(nonatomic, assign) int Year;
@property(nonatomic, assign) double TotalSales;
@end

@interface WEModelGetKitchenSalesByMonth : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSArray<WEModelGetKitchenSalesByMonthSalesByMonthList> *SalesByMonthList;
@end

