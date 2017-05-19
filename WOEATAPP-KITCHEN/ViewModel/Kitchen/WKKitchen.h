//
//  WKKitchen.h
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2016/11/13.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKKitchen : NSObject

/** 厨房id */
@property (nonatomic,copy)NSString *kitchenId;

/** 厨房名称 */
@property (nonatomic,copy)NSString *name;

@property (nonatomic,assign)NSInteger displayOrder;

@property (nonatomic,assign)BOOL isCertified;

@property (nonatomic,copy)NSString *portiaitImageUrl;

@property (nonatomic,copy)NSString *chefImageUrl;

@property (nonatomic,copy)NSString *chefName;

@property (nonatomic,copy)NSString *chefGender;

@property (nonatomic,copy)NSString *addressLine1;

@property (nonatomic,copy)NSString *addressLine2;

@property (nonatomic,copy)NSString *city;

@property (nonatomic,copy)NSString *state;

@property (nonatomic,copy)NSString *postCode;

@property (nonatomic,assign)CGFloat latitude;

@property (nonatomic,assign)CGFloat longitude;

@property (nonatomic,assign)CGFloat customerRating;

@property (nonatomic,copy)NSString *broadcastMessage;

@property (nonatomic,copy)NSString *kitchenStory;

@property (nonatomic,assign)BOOL canPickup;

@property (nonatomic,assign)BOOL canDeliver;

@property (nonatomic,copy)NSMutableArray *tags;

@property (nonatomic,copy)NSMutableArray *images;


@end
