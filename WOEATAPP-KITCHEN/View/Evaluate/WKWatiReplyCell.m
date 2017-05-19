//
//  WKWatiReplyCell.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKWatiReplyCell.h"
#import "WKEvaluate.h"

@interface WKWatiReplyCell()

@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UILabel *labReply;
@property (nonatomic, strong) UIView *evaMarkView;
@property (nonatomic, strong) UILabel *labStamp;
@property (nonatomic, strong) UIButton *btnReply;

@end

@implementation WKWatiReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        _imgAvatar.backgroundColor = [UIColor purpleColor];
        [self addSubview:_imgAvatar];
        
        CGFloat originX = CGRectGetMaxX(_imgAvatar.frame) + 5;
        _labName = [[UILabel alloc] initWithFrame:CGRectMake(originX, 5, screen_width - originX - 60, 30)];
        _labName.text = @"HUXIAOXIAO";
        [self addSubview:_labName];
        
        CGFloat originY = CGRectGetMaxY(_labName.frame);
        _labContent = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, screen_width - originX - 60, 30)];
        _labContent.text = @"还不错哦";
        _labContent.numberOfLines = 0;
        [self addSubview:_labContent];
        
        originY = CGRectGetMaxY(_labContent.frame);
        _evaMarkView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, screen_width - originX - 60, 30)];
        _evaMarkView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _evaMarkView.layer.borderWidth = 1.0;
        [self addSubview:_evaMarkView];
        
        _labReply = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width - originX - 60, 30)];
        _labReply.numberOfLines = 0;
        [_evaMarkView addSubview:_labReply];


        originY = CGRectGetMaxY(_evaMarkView.frame);
        _labStamp = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, screen_width - originX - 60, 30)];
        _labStamp.text = @"2016年12月01日";
        _labStamp.textColor = [UIColor blackColor];
        [self addSubview:_labStamp];
        
        _btnReply = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 60, (120 - 40) / 2, 50, 40)];
        [_btnReply setTitle:@"回评" forState:UIControlStateNormal];
        [_btnReply setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
        [_btnReply addTarget:self action:@selector(replyClientEvaluate:) forControlEvents:UIControlEventTouchUpInside];
        _btnReply.layer.cornerRadius = 5;
        _btnReply.layer.masksToBounds = YES;
        [self addSubview:_btnReply];
    }
    return self;
}

- (void)loadData:(WKEvaluate *)evaluate
{
    self.evaluate = evaluate;
    if (CheckValidString(evaluate.userAvatar)) {
        [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:evaluate.userAvatar] placeholderImage:nil];
    }
    self.labName.text = evaluate.userName;
    self.labContent.text = evaluate.message;
    if (CheckValidString(evaluate.replyMessage)) {
        self.evaMarkView.hidden = NO;
        self.labReply.text = [NSString stringWithFormat:@"回复：%@",evaluate.replyMessage];
    }else{
        self.evaMarkView.hidden = YES;
    }
    self.labStamp.text = evaluate.createTime;
    if ([evaluate.type isEqualToString:@"wait"]) {
        self.btnReply.hidden = YES;//待回复才有回评按钮
    }else{
        self.btnReply.hidden = NO;
    }
}

- (void)replyClientEvaluate:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyClientEvaluate:)]) {
        [self.delegate replyClientEvaluate:self.evaluate];
    }
}

@end
