//
//  ELETextField.m
//  Eleplant
//
//  Created by huangyirong on 2016/1/29.
//  Copyright © 2016年 eleplant. All rights reserved.
//

#import "ELETextField.h"

@implementation ELETextField

//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +20, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
}

@end
