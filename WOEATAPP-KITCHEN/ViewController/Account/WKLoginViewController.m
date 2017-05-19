//
//  WKLoginViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/17.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKLoginViewController.h"
#import "WKHomeViewController.h"
#import "SGAValidatorUtil.h"
#import "WKRegisterInfoViewController.h"
#import "WKWebBrowserViewController.h"
#import "WEModeluserLogin.h"
#import "WEGlobalData.h"
#import "WEToken.h"
#import "AppDelegate.h"
#import "WERegisterViewController.h"
#import "WENetUtil.h"
#import "WEModelGetMyKitchen.h"
#import "WEModelCommon.h"

@interface WKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
//@property (strong, nonatomic) WKUserInfo *userInfo;

//@property (nonatomic,copy)NSString *accessToken;
//@property (nonatomic,copy)NSString *tokenType;
//@property (nonatomic,copy)NSDate *expirationDate;
//@property (nonatomic,copy)NSString *mobilNum;

@end

@implementation WKLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#3D3938" andAlpha:1.0];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PHONE];
    _accountTextfield.text = phone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_userInfo = [[WKUserInfo alloc]init];
    //self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

}

- (IBAction)sendVerfyCodeAction:(id)sender {
    
//    if (![SGAValidatorUtil isMobileNumber:_accountTextfield.text]) {
//        NSLog(@"手机号不合法");
//        return;
//    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.yOffset = -30;
    [self.view addSubview:hud];
    if (_accountTextfield.text.length != 10) {
        hud.labelText = @"请输入10位手机号码";
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        return;
    }

    
    hud.labelText = @"正在发送验证码，请稍后...";
    [hud show:YES];

    
    UIButton *sendButton = sender;
    [WENetUtil sendSecurityCodeWithPhoneNumber:_accountTextfield.text success:^(NSURLSessionDataTask *task, id responseObject) {
        hud.labelText = @"验证码已发送，请查收";
        [hud hide:YES afterDelay:1.5];
        
        __block int timeout=59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                    sendButton.userInteractionEnabled = YES;
                    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [sendButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
                    sendButton.userInteractionEnabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}

- (IBAction)loginAction:(id)sender {

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.yOffset = -30;
    [self.view addSubview:hud];
    if (!_accountTextfield.text.length) {
        hud.labelText = @"请输入手机号码";
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        return;
    }
    if (!_passwordTextfield.text.length) {
        hud.labelText = @"请输入验证码";
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        return;
    }
    
    hud.labelText = @"正在登录，请稍后...";
    [hud show:YES];
    
    [WENetUtil userLoginWithPhoneNumber:_accountTextfield.text securityCode:_passwordTextfield.text success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        hud.labelText = @"登录成功";
//        [hud hide:YES afterDelay:1];
        
        
        NSLog(@"class %@",[responseObject class]);
        
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModeluserLogin *model = [[WEModeluserLogin alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        [[NSUserDefaults standardUserDefaults] setObject:_accountTextfield.text forKey:USER_DEFAULT_PHONE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [WEGlobalData sharedInstance].curUserName = _accountTextfield.text;
        [WEGlobalData logIn];
        
        NSString *s = [NSString stringWithFormat:@"%@ %@", model.token_type, model.access_token];
        [WEToken saveToken:s];
        
        [self fetchKitenInfo];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}

- (void)fetchKitenInfo{
    
    [WENetUtil GetMyKitchenWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyKitchen *model = [[WEModelGetMyKitchen alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        [hud hide:YES];
        
         if ([model.Kitchen.Id isEqual:[NSNull null]] || [model.Kitchen.Id integerValue] == 0) {
             [WEGlobalData sharedInstance].registerToken = [WEToken getToken];
             [WEToken clearToken];
             WERegisterViewController *c = [WERegisterViewController new];
             [self.navigationController pushViewController:c animated:YES];
         } else {
             [WEGlobalData sharedInstance].cacheMyKitchen = model;
             [self checkIsApproved];
         }
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"错误信息 -> %@",errorMsg);
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
    
#if 0
    NSDictionary *param = @{@"MobileNumber":_accountTextfield.text};
    __weak typeof(self) weakSelf = self;
    
    [[WKNetworkManager sharedAuthManager] GET:@"v1/Kitchen/GetMyKitchen" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            [hud hide:YES];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = (NSDictionary *)responseObject;
                if ([result objectForKey:@"Kitchen"]) {
                    NSDictionary *kitchenInfo = result[@"Kitchen"];
                    if ([kitchenInfo isEqual:[NSNull null]] || [kitchenInfo[@"Id"] integerValue] == 0) { //还未注册
                    
                        [WEGlobalData sharedInstance].registerToken = [WEToken getToken];
                        [WEToken clearToken];
                        
                        //[WKKeyChain delete:[NSString stringWithFormat:@"%@%@",kAPPSecurityStoreKey,@"_accessToken"]];
                        
//                        WKRegisterInfoViewController *vc = [[UIStoryboard accountStoryboard] instantiateViewControllerWithIdentifier:@"WKRegisterInfoViewController"];
//                        vc.mobilNum = _mobilNum;
//                        vc.accessToken = _accessToken;
//                        vc.tokenType = _tokenType;
//                        vc.expirationDate = _expirationDate;
//                        
//                        vc.accountName = _accountTextfield.text;
//                        vc.securityCode = _passwordTextfield.text;
                        WERegisterViewController *c = [WERegisterViewController new];
                        [self.navigationController pushViewController:c animated:YES];
                    }else{ //已经注册
                        //保存厨房信息
//                        _userInfo.KitchenId = [kitchenInfo[@"UserId"] integerValue];
//                        _userInfo.userName = kitchenInfo[@"Name"];
//                        _userInfo.nickName = kitchenInfo[@"ChefUsername"];
//                        _userInfo.mobilNum = kitchenInfo[@"ChefMobileNumber"];
//                        _userInfo.gender = kitchenInfo[@"ChefGender"];
//                        _userInfo.PortraitImageUrl = kitchenInfo[@"PortraitImageUrl"];
//                        _userInfo.State = kitchenInfo[@"State"];
//                        _userInfo.City = kitchenInfo[@"City"];
//                        _userInfo.InspectionStatus = kitchenInfo[@"InspectionStatus"];
//                        _userInfo.AddressLine1 = kitchenInfo[@"AddressLine1"];
//                        
//                        [WKKeyChain saveUserInfo:kAPPSecurityStoreKey userInfo:_userInfo];

                        
//                        WKHomeViewController *home = [[WKHomeViewController alloc]init];
//                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
//                        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate setRootToHomeController:self];
                    }
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.labelText = @"登录失败";
        [hud hide:YES afterDelay:1.5];
        //[YRToastView hide];
        //[WKKeyChain saveUserInfo:kAPPSecurityStoreKey userInfo:_userInfo];

    }];
#endif
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



- (IBAction)gotoAgreements:(id)sender {
    WKWebBrowserViewController *webBrowser = [[WKWebBrowserViewController alloc]init];
    NSString *devTool = @"https://api.woeatapp.com/WebPage/View/KITCHEN_APP_TNC";
    webBrowser.url = devTool;
    webBrowser.webTitle = @"用户协议";
    [self.navigationController pushViewController:webBrowser animated:YES];
}


- (IBAction)tapBackground:(id)sender {
    [self.accountTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
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
