//
//  WEModelGetMyKitchenSales.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@interface WEModelGetMyKitchenSales : JSONModel
@property(nonatomic, assign) int CountOfItemsToCookToday;
@property(nonatomic, assign) int CountOfOrderToday;
@property(nonatomic, assign) int CountOfOrderTomorrow;
@property(nonatomic, assign) float TotalSalesToday;
@property(nonatomic, assign) float TotalBalance;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@end

