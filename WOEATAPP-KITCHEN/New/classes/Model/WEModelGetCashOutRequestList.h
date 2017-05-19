//
//  WEModelGetCashOutRequestList.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetCashOutRequestListCashOutRequestList
@end

@interface WEModelGetCashOutRequestListCashOutRequestList : JSONModel
@property(nonatomic, strong) NSString<Optional> *TransactionId;
@property(nonatomic, assign) float CashoutValue;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, assign) BOOL HasSufficientBalance;
@property(nonatomic, strong) NSString<Optional> *UserId;
@property(nonatomic, strong) NSString<Optional> *UserMobileNumber;
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *UserDisplayName;
@property(nonatomic, strong) NSString<Optional> *Result;
@property(nonatomic, assign) int UserBalance;
@property(nonatomic, strong) NSString<Optional> *TimeProcessed;
@property(nonatomic, strong) NSString<Optional> *AdminNote;
@property(nonatomic, assign) int DisplayOrder;
@end

@interface WEModelGetCashOutRequestListPageFilter : JSONModel
@property(nonatomic, strong) NSString<Optional> *SortDir;
@property(nonatomic, assign) int PageSize;
@property(nonatomic, assign) int TotalRecords;
@property(nonatomic, assign) int TotalPages;
@property(nonatomic, strong) NSString<Optional> *SortBy;
@property(nonatomic, assign) int PageIndex;
@end

@interface WEModelGetCashOutRequestList : JSONModel
@property(nonatomic, strong) NSArray<WEModelGetCashOutRequestListCashOutRequestList> *CashOutRequestList;
@property(nonatomic, strong) NSString<Optional> *ModelFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) WEModelGetCashOutRequestListPageFilter<Optional> *PageFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@end

