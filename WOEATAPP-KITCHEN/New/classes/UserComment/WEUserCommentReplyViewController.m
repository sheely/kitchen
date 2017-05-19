//
//  WEUserCommentReplyViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/18.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEUserCommentReplyViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "MBProgressHUD.h"
#import "WERoundTextView.h"
#import "WERoundTextListView.h"
#import "UITextView+Placeholder.h"
#import "WEModelCommon.h"

static float offsetX = 15;
static float imageWidth = 60;
static float topSpace = 15;
static float offsetLeft;
static float offsetRight;
static float vSpace = 10;
static float replyTop = 10;
static float replyOffsetX = 10;
static float replyVSpace = 10;
static float bottomSpace = 20;


#define NAME_FONT [UIFont boldSystemFontOfSize:13]
#define CONTENT_FONT [UIFont systemFontOfSize:14]
#define TIME_FONT [UIFont systemFontOfSize:12]

#define REPLY_HEADER_FONT [UIFont boldSystemFontOfSize:14]
#define REPLY_CONTENT_FONT [UIFont systemFontOfSize:14]


@interface WEUserCommentReplyViewController ()
{
    UITextView *_textView;
}
@end

@implementation WEUserCommentReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"回复饭友评价";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(self.mas_topLayoutGuide).offset(15);
        make.width.equalTo(imageWidth);
        make.height.equalTo(imageWidth);
    }];
    NSString *s = _model.UserPortraitUrl;
    NSURL *url = [NSURL URLWithString:s];
    [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    
    offsetLeft = COND_WIDTH_320(15, 10);
    offsetRight = COND_WIDTH_320(10, 10);
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = NAME_FONT;
    name.textColor = [UIColor blackColor];
    name.text = _model.UserDisplayName;
    CGSize size = [name.text sizeWithAttributes:@{NSFontAttributeName : name.font}];
    [superView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offsetLeft);
        make.top.equalTo(imgView.top);
        make.width.equalTo(size.width+0.5).priorityHigh();
        make.height.equalTo(size.height);
    }];
    
    WERoundTextView *level = [WERoundTextView new];
    level.textBgColor = UICOLOR(139, 133, 101);
    level.textFont = [UIFont systemFontOfSize:12];
    level.textInset = UIEdgeInsetsMake(-3, -7, -3, -7);
    level.cornerRadius = 0;
    [level setString:[self getPosttiveString:_model.Positive]];
    [superView addSubview:level];
    [level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.right).offset(offsetRight);
        make.centerY.equalTo(name.centerY);
        make.width.equalTo([level getWidth]);
        make.height.equalTo([level getHeight]);
        make.right.lessThanOrEqualTo(superView.right).offset(-offsetX);
    }];
    
    float replyButtonWidth = 60;
    UILabel *content = [UILabel new];
    content.backgroundColor = [UIColor clearColor];
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentLeft;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.font = CONTENT_FONT;
    content.textColor = UICOLOR(180, 180, 180);
    content.text = _model.Message;
    [superView addSubview:content];
    float contentWidth = [WEUtil getScreenWidth] - (offsetX + imageWidth + offsetLeft) - offsetX;
    content.preferredMaxLayoutWidth = contentWidth;
    CGSize contentSize = [WEUtil sizeForTitle:content.text font:content.font maxWidth:contentWidth];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(superView.right).offset(-offsetRight);
        make.top.equalTo(name.bottom).offset(vSpace);
        make.left.equalTo(name.left);
        make.width.equalTo(contentWidth);
        make.height.equalTo(contentSize.height);
    }];
    
    WERoundTextListView *evaluationListView = [WERoundTextListView new];
    evaluationListView.textBgColor = UICOLOR(184, 184, 184);
    evaluationListView.textFont = [UIFont systemFontOfSize:13];
    evaluationListView.textInset = UIEdgeInsetsMake(-6, -11, -6, -11);
    evaluationListView.cornerRadius = 6;
    evaluationListView.onlyBorder = NO;
    evaluationListView.maxWidth = contentWidth;
    evaluationListView.lineSpace = 10;
    evaluationListView.itemSpace = 10;
    [evaluationListView setStringArray: _model.TagList];
    [superView addSubview:evaluationListView];
    [evaluationListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content.left);
        make.width.equalTo([evaluationListView getWidth]);
        make.top.equalTo(content.bottom).offset(vSpace);
        make.height.equalTo([evaluationListView getHeight]);
    }];
    
    UILabel *time = [UILabel new];
    time.numberOfLines = 1;
    time.textAlignment = NSTextAlignmentLeft;
    time.font = TIME_FONT;
    time.textColor = UICOLOR(150, 150, 150);
    NSString *timeString = [WEUtil convertFullDateStringToSimple:_model.ObjectTimeCreated];
    time.text = timeString;
    [superView addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(evaluationListView.bottom).offset(vSpace);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(time.font.pointSize+1);
    }];
    
 
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = UICOLOR(68,68,68);
    textView.font = [UIFont systemFontOfSize:13];
    textView.delegate = self;
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.cornerRadius = 8;
    textView.layer.masksToBounds = YES;
    [superView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(time.bottom).offset(15);
        make.left.equalTo(time.left).offset(-5);
        make.right.equalTo(superView.right).offset(-15);
        make.height.equalTo(120);
        
    }];
    textView.placeholder = @"谢谢回复";
    textView.placeholderColor = UICOLOR(170, 170, 170);
    _textView = textView;
    
    UIButton *button = [UIButton new];
    button.backgroundColor = level.textBgColor;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(time.left);
        make.top.equalTo(textView.bottom).offset(15);
        make.width.equalTo(70);
        make.height.equalTo(30);
    }];

}


- (NSString *)getPosttiveString:(NSString *)text
{
    if ([text isEqualToString:@"POSITIVE"]) {
        return @"好评";
    } else if ([text isEqualToString:@"NEUTRAL"]) {
        return @"中评";
    } else if ([text isEqualToString:@"NEGATIVE"]) {
        return @"差评";
    }
    return nil;
}

- (void)buttonTapped:(UIButton *)button
{
    if (!_textView.text.length) {
        [self showErrorHud:@"请填写回复内容"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在提交回复，请稍后...";
    [hud show:YES];
    
    [WENetUtil ReplyCommentWithParentCommentId:_model.Id
                                       Message:_textView.text
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           NSDictionary *dict = (NSDictionary *)responseObject;
                                           JSONModelError* error = nil;
                                           WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                           if (error) {
                                               NSLog(@"error %@", error);
                                           }
                                           if (!res.IsSuccessful) {
                                               hud.labelText = res.ResponseMessage;
                                               [hud hide:YES afterDelay:1.5];
                                               return;
                                           }
                                           hud.labelText = @"提交成功";
                                           [hud hide:YES afterDelay:1];
                                           hud.delegate = self;
                                       }
                                       failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                           hud.labelText = errorMsg;
                                           [hud hide:YES afterDelay:1.5];
                                       }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showErrorHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = text;
    [hud show:YES];
    
    [hud hide:YES afterDelay:2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
