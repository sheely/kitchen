//
//  WKRegisterViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/17.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKRegisterViewController.h"

@interface WKRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@end

@implementation WKRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)sendVerfyCodeAction:(id)sender {
    
}
- (IBAction)nextAction:(id)sender {

}


- (IBAction)tapBackground:(id)sender {
    [self.phoneTextField resignFirstResponder];
    [self.verifyCodeTextField resignFirstResponder];
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
