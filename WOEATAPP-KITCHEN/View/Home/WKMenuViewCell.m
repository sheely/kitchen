//
//  WKMenuViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/19.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKMenuViewCell.h"
@interface WKMenuViewCell()

@end

@implementation WKMenuViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#3F3F40" andAlpha:1.0];
        CGFloat iconWidth  = 50;
        CGFloat originX = (screen_width / 2 - iconWidth) / 2;
        CGFloat originY = (CellMenuHeight - (iconWidth + 30)) / 2;
        _imgLeftMenu = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, iconWidth, iconWidth)];
        _imgLeftMenu.backgroundColor = [UIColor purpleColor];
        [self addSubview:_imgLeftMenu];
        
        _labLeftMenu = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgLeftMenu.frame), screen_width / 2, 30)];
        _labLeftMenu.textAlignment = NSTextAlignmentCenter;
        _labLeftMenu.textColor = [UIColor colorWithHexString:@"#F7D598" andAlpha:1.0];
        [self addSubview:_labLeftMenu];
        
        _imgRightMenu = [[UIImageView alloc] initWithFrame:CGRectMake(originX + screen_width / 2, originY, iconWidth, iconWidth)];
        _imgRightMenu.backgroundColor = [UIColor blueColor];
        [self addSubview:_imgRightMenu];
        
        _labRightMenu = [[UILabel alloc] initWithFrame:CGRectMake(screen_width / 2, CGRectGetMaxY(_imgRightMenu.frame), screen_width / 2, 30)];
        _labRightMenu.textAlignment = NSTextAlignmentCenter;
        _labRightMenu.textColor = [UIColor colorWithHexString:@"#F7D598" andAlpha:1.0];
        [self addSubview:_labRightMenu];
        
        CALayer *verticalLine = [CALayer layer];
        verticalLine.backgroundColor = [UIColor colorWithHexString:@"#F7D598" andAlpha:1.0].CGColor;
        verticalLine.frame = CGRectMake((screen_width - 2) / 2, 0, 2, CellMenuHeight);
        [self.layer addSublayer:verticalLine];
       
        CALayer *horizonLine = [CALayer layer];
        horizonLine.backgroundColor = [UIColor colorWithHexString:@"#F7D598" andAlpha:1.0].CGColor;
        horizonLine.frame = CGRectMake(0, CellMenuHeight - 2, screen_width, 2);
        [self.layer addSublayer:horizonLine];
    }
    return self;
}

@end
