//
//  WERegisterViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/29.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WERegisterViewController.h"
#import "WEUtil.h"
#import "MBProgressHUD.h"
#import "WEAddress.h"
#import "WEAddressManager.h"
#import "WESearchCityViewController.h"
#import "WEState.h"
#import "WECity.h"
#import "WERightImageLeftLabelButton.h"
#import "WENetUtil.h"
#import "WEUserDataManager.h"
#import "WESingleWebViewController.h"
#import "WEModelCommon.h"
#import "TNRadioButtonGroup.h"
#import "WEGlobalData.h"
#import "AppDelegate.h"
#import "WEToken.h"


@interface WERegisterViewController ()
{
    UITextField *_personNameField;
    UITextField *_kitchenNameField;
    UITextField *_streetField;
    UITextField *_codeField;
    WERightImageLeftLabelButton *_stateButton;
    WERightImageLeftLabelButton *_cityButton;
    TNRadioButtonGroup *_checkGroup;
    
    NSString *_personName;
    NSString *_kitchenName;
    NSString *_street;
    NSString *_code;
    int _stateId;
    NSString *_stateName;
    NSString *_cityName;
    BOOL _genderIsMale;
}
@end

@implementation WERegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    //self.title = @"成为家厨";
    self.view.backgroundColor = UICOLOR(249,249,249);
    UIView *superView = self.view;
    
    //scroll
    UIScrollView *scrollView = [UIScrollView new];
    [superView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
    }];
    
    //content
    superView = scrollView;
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    [superView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.top);
        make.left.equalTo(scrollView.left);
        make.right.equalTo(scrollView.right);
        make.bottom.equalTo(scrollView.bottom);
        make.width.equalTo([WEUtil getScreenWidth]);
        //contentHeightConstraint = make.height.equalTo(1000);
    }];
    
    superView = contentView;

    
    float offsetX = 15;
//    UIButton *backButton = [UIButton new];
//    UIImage *backImg = [UIImage imageNamed:@"back_arrow"];
//    backButton.adjustsImageWhenHighlighted = NO;
//    [backButton setBackgroundImage:backImg forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [superView addSubview:backButton];
//    [backButton makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left).offset(10);
//        make.top.equalTo(self.mas_topLayoutGuide).offset(8);
//        make.width.equalTo(backImg.size.width);
//        make.height.equalTo(backImg.size.height);
//    }];
//    
//    UILabel *title = [UILabel new];
//    title.backgroundColor = [UIColor clearColor];
//    title.textColor = DARK_COLOR;
//    title.textAlignment = NSTextAlignmentCenter;
//    title.font = [UIFont systemFontOfSize:16];
//    [superView addSubview:title];
//    [title sizeToFit];
//    [title makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left);
//        make.right.equalTo(superView.right);
//        make.centerY.equalTo(backButton.centerY).offset(2);
//    }];
//    title.text = @"成为家厨";
    
    UIView *headerBg = [UIView new];
    headerBg.backgroundColor = DARK_COLOR;
    [superView addSubview:headerBg];
    [headerBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(superView.top).offset(0);
        make.height.equalTo(150);
    }];
    
    UIImage *logo = [UIImage imageNamed:@"icon_logo"];
    UIImageView *logoView = [UIImageView new];
    logoView.image = logo;
    [superView addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerBg.centerY).offset(-20);
        make.centerX.equalTo(superView.centerX);
        make.width.equalTo(logo.size.width);
        make.height.equalTo(logo.size.height);
    }];
    
    UILabel *logoTitle = [UILabel new];
    logoTitle.backgroundColor = [UIColor clearColor];
    logoTitle.textColor = SILVER_COLOR;
    logoTitle.textAlignment = NSTextAlignmentCenter;
    logoTitle.font = [UIFont systemFontOfSize:20];
    [superView addSubview:logoTitle];
    [logoTitle sizeToFit];
    [logoTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.bottom).offset(10);
        make.centerX.equalTo(superView.centerX);
    }];
    logoTitle.text = @"家厨平台";
    
    UILabel *tip = [UILabel new];
    tip.backgroundColor = [UIColor clearColor];
    tip.textColor = [UIColor blackColor];
    tip.textAlignment = NSTextAlignmentLeft;
    tip.font = [UIFont boldSystemFontOfSize:14];
    [superView addSubview:tip];
    [tip sizeToFit];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(headerBg.bottom).offset(15);
    }];
    tip.text = @"只需填写简单信息，即可申请成为家厨";
    
    UILabel *tip1 = [UILabel new];
    tip1.backgroundColor = [UIColor clearColor];
    tip1.textColor = UICOLOR(150, 150, 150);
    tip1.textAlignment = NSTextAlignmentLeft;
    tip1.font = [UIFont systemFontOfSize:12];
    [superView addSubview:tip1];
    [tip1 sizeToFit];
    [tip1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(tip.bottom).offset(8);
    }];
    tip1.text = @"以下信息提交后不可随意更改，请谨慎填写";
    
    float fieldHeight = 25;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=DARK_COLOR.CGColor;
    textField.layer.borderWidth= 1.0f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view1;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"厨房的好名字" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(tip1.bottom).offset(20);
    }];
    _kitchenNameField = textField;
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=DARK_COLOR.CGColor;
    textField.layer.borderWidth= 1.0f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view2;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"大厨的昵称" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                        NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(_kitchenNameField.bottom).offset(10);
    }];
    _personNameField = textField;
    
    UIView *genderBg = [UIView new];
    genderBg.backgroundColor = [UIColor clearColor];
    [superView addSubview:genderBg];
    [genderBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(_personNameField.bottom).offset(10);
    }];
    superView = genderBg;
    
    UILabel *genderTip = [UILabel new];
    genderTip.backgroundColor = [UIColor clearColor];
    genderTip.textColor = UICOLOR(100, 100, 100);
    genderTip.textAlignment = NSTextAlignmentLeft;
    genderTip.font = [UIFont boldSystemFontOfSize:14];
    [superView addSubview:genderTip];
    [genderTip sizeToFit];
    [genderTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.centerY.equalTo(superView.centerY);
    }];
    genderTip.text = @"大厨性别";

    TNImageRadioButtonData *data1 = [TNImageRadioButtonData new];
    data1.labelFont = [UIFont systemFontOfSize:13];
    data1.labelActiveColor = [UIColor lightGrayColor];
    data1.labelPassiveColor = [UIColor lightGrayColor];
    data1.labelText = @"男";
    data1.identifier = @"0";
    data1.selected = _genderIsMale;
    data1.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
    data1.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
    data1.labelOffset = 5;
    
    TNImageRadioButtonData *data2 = [TNImageRadioButtonData new];
    data2.labelFont = [UIFont systemFontOfSize:13];
    data2.labelActiveColor = [UIColor lightGrayColor];
    data2.labelPassiveColor = [UIColor lightGrayColor];
    data2.labelText = @"女";
    data2.identifier = @"1";
    data2.selected = !_genderIsMale;
    data2.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
    data2.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
    data2.labelOffset = 5;
    
    TNRadioButtonGroup *group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[data1, data2] layout:TNRadioButtonGroupLayoutHorizontal];
    group.marginBetweenItems = 30;
    group.identifier = @"group";
    [group create];
    group.position = CGPointMake(80, 7);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentCheckGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:group];
    [group update];
    _checkGroup = group;
    [superView addSubview:_checkGroup];
    
    superView = contentView;
    
    
    tip = [UILabel new];
    tip.backgroundColor = [UIColor clearColor];
    tip.textColor = [UIColor blackColor];
    tip.textAlignment = NSTextAlignmentLeft;
    tip.font = [UIFont boldSystemFontOfSize:13];
    [superView addSubview:tip];
    [tip sizeToFit];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(genderBg.bottom).offset(15);
    }];
    tip.text = @"厨房地址";
    
    UIImage *grayArrow = [UIImage imageNamed:@"icon_arrow_gray"];
    WERightImageLeftLabelButton *stateButton = [[WERightImageLeftLabelButton alloc] initWithImage:grayArrow title:@"州"];
    stateButton.label.textColor = [UIColor blackColor];
    [stateButton addTarget:self action:@selector(stateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:stateButton];
    [stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip.left);
        make.top.equalTo(tip.bottom).offset(5);
        make.width.equalTo([WEUtil getScreenWidth]*0.45);
        make.height.equalTo(25);
    }];
    _stateButton = stateButton;
    
    WERightImageLeftLabelButton *cityButton = [[WERightImageLeftLabelButton alloc] initWithImage:grayArrow title:@"城市"];
    cityButton.label.textColor = [UIColor blackColor];
    [cityButton addTarget:self action:@selector(cityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:cityButton];
    [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset([WEUtil getScreenWidth]*0.5 + 15);
        make.centerY.equalTo(stateButton.centerY);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(stateButton.height);
    }];
    _cityButton = cityButton;
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=DARK_COLOR.CGColor;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.layer.borderWidth= 1.0f;
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view3;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"详细地址" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(_stateButton.bottom).offset(10);
    }];
    _streetField = textField;
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.layer.borderColor=DARK_COLOR.CGColor;
    textField.layer.borderWidth= 1.0f;
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view4;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮政编码" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(_streetField.bottom).offset(10);
    }];
    _codeField = textField;
    
    UIButton *button = [UIButton new];
    [button setTitle:@"完成注册" forState:UIControlStateNormal];
    [button setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerFinishedTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = SILVER_COLOR;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    button.layer.cornerRadius=8.0f;
    button.layer.masksToBounds=YES;
    [superView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight+5);
        make.top.equalTo(_codeField.bottom).offset(10);
        make.bottom.equalTo(superView.bottom).offset(-20);
    }];
    
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)updateUI
{
    _personNameField.text = _personName;
    _kitchenNameField.text = _kitchenName;
    _streetField.text = _street;
    _codeField.text = _code;
    if (_stateName.length) {
        _stateButton.label.text = [NSString stringWithFormat:@"州 %@", _stateName];
        _stateButton.label.textColor = [UIColor blackColor];
    } else {
        _stateButton.label.text = @"州";
        _stateButton.label.textColor = [UIColor lightGrayColor];
    }
    if (_cityName.length) {
        _cityButton.label.text = [NSString stringWithFormat:@"城市 %@", _cityName];
        _cityButton.label.textColor = [UIColor blackColor];
    } else {
        _cityButton.label.text = @"城市";
        _cityButton.label.textColor = [UIColor lightGrayColor];
    }
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

- (void)registerFinishedTapped:(UIButton *)button
{
    if (!_personName.length) {
        [self showErrorHud:@"请填写厨师姓名"];
        return;
    }
    if (!_kitchenName.length) {
        [self showErrorHud:@"请填写厨房姓名"];
        return;
    }
    if (!_street.length) {
        [self showErrorHud:@"请填写厨房详细地址"];
        return;
    }
    if (!_code.length) {
        [self showErrorHud:@"请填写邮政编码"];
        return;
    }
    if (!_stateName.length) {
        [self showErrorHud:@"请选择州"];
        return;
    }
    if (!_cityName.length) {
        [self showErrorHud:@"请选择城市"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在发送请求，请稍后...";
    [hud show:YES];
    
    [WENetUtil RegisterWithName:_kitchenName
                   ChefUsername:_personName
                         isMale:_genderIsMale
                   AddressLine1:_street
                           City:_cityName
                          State:_stateName
                       Postcode:_code
                      Longitude:TEST_Longitude
                       Latitude:TEST_Latitude
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            JSONModelError* error = nil;
                            NSDictionary *dict = (NSDictionary *)responseObject;
                            WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                            if (error) {
                                NSLog(@"error %@", error);
                            }
                            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                            if (common.IsSuccessful) {
                                [self checkIsApproved];
                                
                            } else {
                                hud.labelText = common.ResponseMessage;
                                [hud hide:YES afterDelay:1.5];
                            }
                        }
                        failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                            hud.labelText = errorMsg;
                            [hud hide:YES afterDelay:1.5];
                        }];
}

- (void)checkIsApproved
{
    [WENetUtil IsApprovedWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        JSONModelError* error = nil;
        WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        [hud hide:YES afterDelay:0];
        if (common.IsSuccessful) {
            if ([dict[@"Result"] boolValue]) {
                NSString *s = [WEGlobalData sharedInstance].registerToken;
                [WEToken saveToken:s];
                
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate setRootToHomeController:self];
            } else {
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate setRootToApprovedController];
            }
            
        } else {
            hud.labelText = common.ResponseMessage;
            [hud hide:YES afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}


- (void)stateButtonTapped:(UIButton *)button
{
    WESearchCityViewController *c = [WESearchCityViewController new];
    c.stateId = 0;
    c.searchDelegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

- (void)cityButtonTapped:(UIButton *)button
{
    if (!_stateId) {
        [self showErrorHud:@"请先选择州"];
        return;
    }
    WESearchCityViewController *c = [WESearchCityViewController new];
    c.stateId = _stateId;
    c.searchDelegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _personNameField) {
        _personName = textField.text;
    } else if (textField == _kitchenNameField) {
        _kitchenName = textField.text;
    }  else if (textField == _streetField) {
        _street = textField.text;
    }  else if (textField == _codeField) {
        _code = textField.text;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _personNameField) {
        _personName = newText;
    } else if (textField == _kitchenNameField) {
        _kitchenName = newText;
    }  else if (textField == _streetField) {
        _street = newText;
    }  else if (textField == _codeField) {
        _code = newText;
    }
    
    return YES;
    
}

- (void)userSelecteState:(WEState *)state
{
    _stateName = state.Code;
    _stateId = state.stateId;
    _cityName = nil;
    [self updateUI];
    
}
- (void)userSelecteCity:(WECity *)city
{
    _cityName = city.Name;
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonTapped:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)commentCheckGroupUpdated:(NSNotification *)notification {
    NSString *iden = _checkGroup.selectedRadioButton.data.identifier;
    
    if ([iden integerValue]) {
        _genderIsMale = NO;
    } else {
        _genderIsMale = YES;
    }
    NSLog(@"_genderIsMale %d", _genderIsMale);
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
