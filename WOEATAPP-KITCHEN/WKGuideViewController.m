//
//  WKGuideViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 17/1/12.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WKGuideViewController.h"
#import "WKLoginViewController.h"

@interface WKGuideViewController ()

@end

@implementation WKGuideViewController

- (IBAction)disMiss:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WK_Old_User];
    
    WKLoginViewController *login = [[UIStoryboard accountStoryboard] instantiateViewControllerWithIdentifier:@"WKLoginViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
