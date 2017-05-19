//
//  WEModelGetItemToCookList.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetItemToCookListItemToCookList
@end

@interface WEModelGetItemToCookListItemToCookList : JSONModel
@property(nonatomic, strong) NSString<Optional> *ItemId;
@property(nonatomic, strong) NSString<Optional> *ItemName;
@property(nonatomic, assign) int Quantity;
@end

@interface WEModelGetItemToCookList : JSONModel
@property(nonatomic, strong) NSArray<WEModelGetItemToCookListItemToCookList> *ItemToCookList;
@property(nonatomic, strong) NSString<Optional> *Date;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@end

