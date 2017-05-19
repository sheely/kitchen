//
//  AppDelegate.m
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2016/10/13.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "AppDelegate.h"
#import "WKHomeViewController.h"
#import "WKLoginViewController.h"
#import "CCLocationManager.h"
#import "WKGuideViewController.h"
#import "IQKeyboardManager.h"
#import "WEIntroViewController.h"
#import "WEBaseNavigationController.h"
#import "WEGlobalData.h"
#import "WEToken.h"
#import "WEIntroDownload.h"
#import "WEIntroViewController.h"
#import "WEWaitApprovedViewController.h"
#import "WENetUtil.h"
#import "WEModelCommon.h"
#import "WETmpStartViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate>{
    CLLocationManager *locationmanager;
}

@property (nonatomic, strong) UIViewController * rootViewController;

@end

@implementation AppDelegate

- (void)addWindowAnimation
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"rootControllerAnim"];
}


- (void)removeWindowAnimation
{
    [[UIApplication sharedApplication].keyWindow.layer removeAnimationForKey:@"rootControllerAnim"];
}

- (void)setRootToHomeController:(UIViewController *)originController
{
    if (!originController) {
        WKHomeViewController *home = [[WKHomeViewController alloc]init];
        WEBaseNavigationController *nav1 = [[WEBaseNavigationController alloc] initWithRootViewController:home];
        self.window.rootViewController = nav1;
        [self.window addSubview:nav1.view];
        [self.window makeKeyAndVisible];
        return;
    }
    
    [self addWindowAnimation];
    
    [originController.view removeFromSuperview];
    [self performSelector:@selector(removeWindowAnimation) withObject:nil afterDelay:3.0];
    
    WKHomeViewController *home = [[WKHomeViewController alloc]init];
    WEBaseNavigationController *nav1 = [[WEBaseNavigationController alloc] initWithRootViewController:home];
    
    [UIView transitionFromView:originController.view
                        toView:nav1.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
         self.window.rootViewController = nav1;
         [self.window addSubview:nav1.view];
         [originController.view removeFromSuperview];
     }];
    
    
    [self.window makeKeyAndVisible];
}

- (void)setRootToTmpController
{
    WETmpStartViewController *c = [WETmpStartViewController new];
    WEBaseNavigationController *nav1 = [[WEBaseNavigationController alloc] initWithRootViewController:c];
    nav1.navigationBar.hidden = YES;
    self.window.rootViewController=nav1;
    [self.window addSubview:nav1.view];
    [self.window makeKeyAndVisible];
    [self setNav];
}


- (void)setRootToApprovedController
{
    WEWaitApprovedViewController *c = [WEWaitApprovedViewController new];
    WEBaseNavigationController *nav1 = [[WEBaseNavigationController alloc] initWithRootViewController:c];
    nav1.navigationBar.hidden = YES;
    self.window.rootViewController=nav1;
    [self.window addSubview:nav1.view];
    [self.window makeKeyAndVisible];
    [self setNav];
}

- (void)setRootToLoginController
{
    WKLoginViewController *login = [[UIStoryboard accountStoryboard] instantiateViewControllerWithIdentifier:@"WKLoginViewController"];
    WEBaseNavigationController *nav1 = [[WEBaseNavigationController alloc] initWithRootViewController:login];
    nav1.navigationBar.hidden = NO;
    self.window.rootViewController=nav1;
    [self.window addSubview:nav1.view];
    [self.window makeKeyAndVisible];
    [self setNav];
}

- (void)setRootToIntroController:(NSArray *)imageArray
{
    WEIntroViewController *c1 = [[WEIntroViewController alloc] initWithImageArray:imageArray];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:c1];
    nav1.navigationBar.hidden = YES;
    self.window.rootViewController=nav1;
    [self.window addSubview:nav1.view];
    [self.window makeKeyAndVisible];
    [self setNav];
}

- (void)selectRootController
{
    NSArray *array = [WEIntroDownload getDispayImagePathArray];
    if (array.count) {
        [self setRootToIntroController:array];
        return;
    }
    
    NSString *token = [WEToken getToken];
    if (token.length) {
        //[self setRootToHomeController:nil];
        [self setRootToTmpController];
        [self fetchKitenInfo];
    } else {
        [self setRootToLoginController];
    }
}

- (void)showErrorAlert:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)fetchKitenInfo{
    
    [WENetUtil GetMyKitchenWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyKitchen *model = [[WEModelGetMyKitchen alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
       
        if ([model.Kitchen.Id isEqual:[NSNull null]] || [model.Kitchen.Id integerValue] == 0) {
            NSLog(@"should not here");
            [self setRootToLoginController];
        } else {
            [WEGlobalData sharedInstance].cacheMyKitchen = model;
            [self checkIsApproved];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"错误信息 -> %@",errorMsg);
        [self showErrorAlert:errorMsg];
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
        if (common.IsSuccessful) {
            if ([dict[@"Result"] boolValue]) {
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate setRootToHomeController:nil];
            } else {
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate setRootToApprovedController];
            }
            
        } else {
            [self showErrorAlert:common.ResponseMessage];
        }
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
         [self showErrorAlert:errorMsg];
    }];
}

- (void)reCheckApproved
{
    UINavigationController *nav = self.window.rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        UIViewController *c = nav.topViewController;
        if ([c isKindOfClass:[WEWaitApprovedViewController class]]) {
            NSString *token = [WEToken getToken];
            if (!token.length) {
                token = [WEGlobalData sharedInstance].registerToken;
                if (!token.length) {
                    return;
                }
            }
            
            [WENetUtil IsApprovedWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *dict = responseObject;
                JSONModelError* error = nil;
                WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error %@", error);
                }
                if (common.IsSuccessful) {
                    if ([dict[@"Result"] boolValue]) {
                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate setRootToHomeController:nil];
                    }
                } else {
                }
            } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
            }];
        }
    }
    
}


- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = DARK_COLOR;
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    bar.backgroundColor = DARK_COLOR;
    
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary: [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal]];
    [attributes setValue:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
     [attributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
    //                                                   forBarMetrics:UIBarMetricsDefault];
    
    //    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self selectRootController];
    
    return YES;
}

#if 0
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    UINavigationController *nav = nil;
    NSString *token = [WKKeyChain load:[NSString stringWithFormat:@"%@%@",kAPPSecurityStoreKey,@"_accessToken"]];
//    token = @"";
//    [WKKeyChain deleteUserInfo:kAPPSecurityStoreKey];

    if (![[NSUserDefaults standardUserDefaults]boolForKey:WK_Old_User]) {
        WKGuideViewController *welcomeController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WKGuideViewController"];
        nav = [[UINavigationController alloc]initWithRootViewController:welcomeController];
        nav.navigationBarHidden = YES;
    }else{
        if (token.length > 0) {
            WKHomeViewController *home = [[WKHomeViewController alloc]init];
            nav = [[UINavigationController alloc]initWithRootViewController:home];
        }else{
            WKLoginViewController *login = [[UIStoryboard accountStoryboard] instantiateViewControllerWithIdentifier:@"WKLoginViewController"];
            nav = [[UINavigationController alloc]initWithRootViewController:login];
        }
    }

        _rootViewController = nav;
    
    //[self getAllState];//TEST
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    [self getAllInfo];
   // [self getCity];
    
    self.window.rootViewController = _rootViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    [self test]; //测试专用
//    [self testImageUpload];
    
    //[ELEBaseInfoTool buildPoi];
    //[ELEBaseInfoTool buildStateArray];

    return YES;
}
#endif

-(void)testImageUpload{
    
    UIImage *image = [UIImage imageNamed:@"home_items"];
    NSData *data = UIImagePNGRepresentation(image);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    NSDictionary *param = @{@"ImageFile":fileName};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    WKUserInfo *account = [WKKeyChain loadUserInfo:kAPPSecurityStoreKey];
    NSString *accessToken = account.accessToken;
    NSString *tokenType = account.tokenType;
    NSString *authorization = [NSString stringWithFormat:@"%@ %@",tokenType,accessToken];
    if (authorization.length > 0) {
        [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"authorization"];
    }
    [manager POST:@"https://api.woeatapp.com/v1/Image/Upload" parameters:param constructingBodyWithBlock:^(id _Nonnull formData){
        [formData appendPartWithFileData:data name:@"ImageFile" fileName:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ( [responseObject isKindOfClass:[NSString class]]) {
            NSLog(@"response %@",responseObject);
        }else{
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"response %@",resultData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片上传 %@",error.description);
    }];
    
}

-(void)test{
    NSDictionary *param = @{@"KitchenId":@"101010"};
    __weak typeof(self) weakSelf = self;
    [[WKNetworkManager sharedAuthManager] GET:@"v1/Kitchen/GetBusinessHours" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];

}


- (void)getAllState{
    NSDictionary *param = @{@"CountryId":@1000};
    [[WKNetworkManager sharedAuthManager] GET:@"v1/GeoState/GetList" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"发送成功");
            NSLog(@"response %@",responseObject);
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)getLat
{
    if (IS_IOS8) {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
        }];
    }
}

-(void)getCity
{
    if (IS_IOS8) {
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            NSLog(@"城市 %@",cityString);
        }];
    }
}


-(void)getAllInfo
{
    if (IS_IOS8) {
        [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@" 经度%f 纬度%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
        } withAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
        }];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    // 关闭横屏
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self reCheckApproved];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
