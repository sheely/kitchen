//
//  UIStoryboard+WOEAT.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/15.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "UIStoryboard+WOEAT.h"

@implementation UIStoryboard (WOEAT)

+ (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)homeStoryboard
{
    return [UIStoryboard storyboardWithName:@"Home" bundle:nil];
}

+ (UIStoryboard *)accountStoryboard
{
    return [UIStoryboard storyboardWithName:@"Account" bundle:nil];
}

+ (UIStoryboard *)orderStoryboard
{
    return [UIStoryboard storyboardWithName:@"Order" bundle:nil];
}

+ (UIStoryboard *)incomeStoryboard
{
    return [UIStoryboard storyboardWithName:@"Income" bundle:nil];
}



@end
