//
//  WKReplyClientController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKReplyClientController.h"

@interface WKReplyClientController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UIView *evaMarkView;
@property (nonatomic, strong) UILabel *labReply;
@property (nonatomic, strong) UILabel *labStamp;
@property (nonatomic, strong) UITextView *replyTextView;
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation WKReplyClientController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"回复饭友评价";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}


- (void)initUI
{
    [self.view addSubview:self.scrollView];
    _imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    _imgAvatar.backgroundColor = [UIColor purpleColor];
    [self.scrollView addSubview:_imgAvatar];
    
    CGFloat originX = CGRectGetMaxX(_imgAvatar.frame) + 5;
    _labName = [[UILabel alloc] initWithFrame:CGRectMake(originX, 5, screen_width - originX - 60, 30)];
    _labName.text = @"HUXIAOXIAO";
    [self.scrollView addSubview:_labName];
    
    CGFloat originY = CGRectGetMaxY(_labName.frame);
    _labContent = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, screen_width - originX - 60, 30)];
    _labContent.text = @"还不错哦";
    _labContent.numberOfLines = 0;
    [self.scrollView addSubview:_labContent];
    
    originY = CGRectGetMaxY(_labContent.frame);
    _evaMarkView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, screen_width - originX - 60, 30)];
    _evaMarkView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _evaMarkView.layer.borderWidth = 1.0;
    [self.scrollView addSubview:_evaMarkView];
    
    _labReply = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width - originX - 60, 30)];
    _labReply.numberOfLines = 0;
    [_evaMarkView addSubview:_labReply];

    
    originY = CGRectGetMaxY(_evaMarkView.frame);
    _labStamp = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, screen_width - originX - 60, 30)];
    _labStamp.text = @"2016年12月01日";
    _labStamp.textColor = [UIColor blackColor];
    [self.scrollView addSubview:_labStamp];
    
    [self.scrollView addSubview:self.replyTextView];
    [self.scrollView addSubview:self.btnSubmit];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY)];
    }
    return _scrollView;
}

- (UITextView *)replyTextView
{
    if (_replyTextView == nil) {
        _replyTextView = [[UITextView alloc]initWithFrame:CGRectMake(40, 120, screen_width - 80, 120)];
        _replyTextView.textColor = [UIColor colorWithHexString:@"999999" andAlpha:1.0];
        _replyTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _replyTextView.layer.borderWidth = 1.0;
    }
    return _replyTextView;
}

- (UIButton *)btnSubmit
{
    if (_btnSubmit == nil) {
        CGFloat originY = CGRectGetMaxY(self.replyTextView.frame) + 10;
        _btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(40, originY, 60, 40)];
        [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnSubmit setBackgroundColor:[UIColor brownColor]];
        [_btnSubmit addTarget:self action:@selector(submitReply:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}

- (void)submitReply:(id)sender
{
    WS(ws);
    NSDictionary *param = @{
                            @"ParentCommentId":self.evaluate.evaluateId,
                            @"Positive":self.evaluate.objectType,
                            @"Message":self.replyTextView.text};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/Comment/ReplyComment" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [YRToastView showMessage:@"回复成功" inView:self.view];
//        [ws.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
    }];
}
@end
