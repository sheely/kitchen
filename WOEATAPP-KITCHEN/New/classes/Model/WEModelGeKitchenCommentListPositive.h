//
//  WEModelGeKitchenCommentListPositive.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGeKitchenCommentListPositiveCommentList
@end

@interface WEModelGeKitchenCommentListPositiveCommentListReply : JSONModel
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *Reply;
@property(nonatomic, strong) NSString<Optional> *ObjectId;
@property(nonatomic, strong) NSString<Optional> *KitchenName;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitId;
@property(nonatomic, assign) BOOL IsMasked;
@property(nonatomic, strong) NSString<Optional> *Message;
@property(nonatomic, strong) NSString<Optional> *ObjectTimeCreated;
@property(nonatomic, strong) NSString<Optional> *ParentCommentId;
@property(nonatomic, assign) int SalesOrderTotalValue;
@property(nonatomic, strong) NSString<Optional> *ObjectType;
@property(nonatomic, strong) NSString<Optional> *UserPortraitId;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *UserDisplayName;
@property(nonatomic, strong) NSString<Optional> *ByUserId;
@property(nonatomic, strong) NSString<Optional> *UserPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *Positive;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *SalesOrderDispatchMethod;
@end

@interface WEModelGeKitchenCommentListPositiveCommentList : JSONModel
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) WEModelGeKitchenCommentListPositiveCommentListReply<Optional> *Reply;
@property(nonatomic, strong) NSString<Optional> *ObjectId;
@property(nonatomic, strong) NSString<Optional> *KitchenName;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitId;
@property(nonatomic, assign) BOOL IsMasked;
@property(nonatomic, strong) NSString<Optional> *Message;
@property(nonatomic, strong) NSString<Optional> *ObjectTimeCreated;
@property(nonatomic, strong) NSString<Optional> *ParentCommentId;
@property(nonatomic, assign) double SalesOrderTotalValue;
@property(nonatomic, strong) NSString<Optional> *ObjectType;
@property(nonatomic, strong) NSString<Optional> *UserPortraitId;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *UserDisplayName;
@property(nonatomic, strong) NSString<Optional> *ByUserId;
@property(nonatomic, strong) NSString<Optional> *UserPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *Positive;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *SalesOrderDispatchMethod;
@property(nonatomic, strong) NSArray<NSString *> *TagList;
@end

@interface WEModelGeKitchenCommentListPositivePageFilter : JSONModel
@property(nonatomic, strong) NSString<Optional> *SortDir;
@property(nonatomic, assign) int PageSize;
@property(nonatomic, assign) int TotalRecords;
@property(nonatomic, assign) int TotalPages;
@property(nonatomic, strong) NSString<Optional> *SortBy;
@property(nonatomic, assign) int PageIndex;
@end

@interface WEModelGeKitchenCommentListPositive : JSONModel
@property(nonatomic, strong) NSArray<WEModelGeKitchenCommentListPositiveCommentList> *CommentList;
@property(nonatomic, strong) NSString<Optional> *ModelFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) WEModelGeKitchenCommentListPositivePageFilter<Optional> *PageFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@end

