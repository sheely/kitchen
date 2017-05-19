//
//  WEKitchenStoryViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/1.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEKitchenStoryViewController.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"
#import "WENetUtil.h"
#import "WEModelCommon.h"
#import "UITextView+Placeholder.h"
#import "WEUtil.h"
#import "IQKeyboardManager.h"

@interface WEKitchenStoryViewController ()
{
    UILabel *_countLabel;
    UITextView *_textView;
}
@end

@implementation WEKitchenStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"厨房故事";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *superView = self.view;
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(187, 187, 187);
    [superView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.height.equalTo(40);
    }];
    
    superView = bg;
    UILabel *title = [UILabel new];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont boldSystemFontOfSize:13];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    [superView addSubview:title];
    [title sizeToFit];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(15);
        make.centerY.equalTo(superView.centerY);
    }];
    title.text = @"说说您的厨房故事";
    
    UILabel *countLabel = [UILabel new];
    countLabel.numberOfLines = 1;
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont boldSystemFontOfSize:13];
    countLabel.textColor = UICOLOR(130, 130, 130);
    countLabel.backgroundColor = [UIColor clearColor];
    [superView addSubview:countLabel];
    [countLabel sizeToFit];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-15);
        make.centerY.equalTo(superView.centerY);
    }];
    _countLabel = countLabel;
    
    superView = self.view;
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = UICOLOR(68,68,68);
    textView.delegate = self;
    [superView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg.bottom).offset(5);
        make.left.equalTo(superView.left).offset(15);
        make.right.equalTo(superView.right).offset(-15);
        make.height.equalTo([WEUtil getScreenHeight] * 0.5);
        
    }];
    textView.placeholder = @"在此输入您的厨房故事，用故事中的情感与您的饭友共鸣";
    textView.placeholderColor = UICOLOR(170, 170, 170);
    _textView = textView;
    
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    _textView.text = model.Kitchen.KitchenStory;
    [self updateCountLabel];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = NO;
}

//

-(void)viewWillDisappear:(BOOL)animated{
    [_textView resignFirstResponder];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)updateCountLabel
{
    _countLabel.text = [NSString stringWithFormat:@"还可输入%ld字", 300-_textView.text.length];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int newLen = textView.text.length - range.length + text.length;
    if (newLen > 200) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCountLabel];
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


- (void)save:(UIButton *)button
{
    if (!_textView.text.length) {
        [self showErrorHud:@"请输入厨房故事"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在保存厨房故事，请稍后...";
    [hud show:YES];
    
    [WENetUtil UpdateKitchenStoryWithKitchenStory:_textView.text
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
                                              hud.labelText = @"保存成功";
                                              hud.delegate = self;
                                              [hud hide:YES afterDelay:1.0];
                                          } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                              hud.labelText = errorMsg;
                                              [hud hide:YES afterDelay:1.5];
                                          }];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
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
