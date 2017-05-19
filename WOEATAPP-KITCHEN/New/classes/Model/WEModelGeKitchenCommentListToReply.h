//
//  WEModelGeKitchenCommentListToReply.h
//  woeat
//
//  Created by liubin on 17/1/30.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGeKitchenCommentListToReplyCommentList
@end

@interface WEModelGeKitchenCommentListToReplyCommentList : JSONModel
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *Reply;
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
@end

@interface WEModelGeKitchenCommentListToReplyPageFilter : JSONModel
@property(nonatomic, strong) NSString<Optional> *SortDir;
@property(nonatomic, assign) int PageSize;
@property(nonatomic, assign) int TotalRecords;
@property(nonatomic, assign) int TotalPages;
@property(nonatomic, strong) NSString<Optional> *SortBy;
@property(nonatomic, assign) int PageIndex;
@end

@interface WEModelGeKitchenCommentListToReply : JSONModel
@property(nonatomic, strong) NSArray<WEModelGeKitchenCommentListToReplyCommentList> *CommentList;
@property(nonatomic, strong) NSString<Optional> *ModelFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) WEModelGeKitchenCommentListToReplyPageFilter<Optional> *PageFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@end

