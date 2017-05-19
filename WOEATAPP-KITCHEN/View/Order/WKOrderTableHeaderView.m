//
//  WKOrderTableHeaderView.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/22.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKOrderTableHeaderView.h"

@interface WKOrderTableHeaderView (){
}

@property (nonatomic, weak) UIButton *headerBtn;


@end

@implementation WKOrderTableHeaderView

///像 自定义cell一样 定义一个headerView
+ (instancetype)orderHeaderViewWithTableView:(UITableView *)tableView {
    static NSString *headerID = @"header";
    WKOrderTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[self alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        //布局子控件
        [self setupChlidView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //布局子控件
        [self setupChlidView];
    }
    
    return self;
}


- (void)setupChlidView{
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:headerBtn];
    self.headerBtn = headerBtn;
    [self.headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headerBtn setTitle:@"过滤订单" forState:UIControlStateNormal];
    [self.headerBtn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:0];
    [self.headerBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    self.headerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.headerBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.headerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.headerBtn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:0];
    self.headerBtn.imageView.contentMode = UIViewContentModeCenter;
    self.headerBtn.imageView.clipsToBounds = NO;
    [self.headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerBtn.frame = self.bounds;
}


/// 按钮的监听事件
- (void)headerBtnClick:(UIButton *)sender {
    _isExpend = !_isExpend;
    if (!_isExpend) {
        //没有展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }else {
        //展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    if ([self.delegate respondsToSelector:@selector(OrderHeaderViewDidClickBtn:)]) {
        
        [self.delegate OrderHeaderViewDidClickBtn:self];
    }
}

-(void)setIsExpend:(BOOL)isExpend{
    if (_isExpend) {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
