//
//  WKRegisterInfoViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/17.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKRegisterInfoViewController.h"
#import "WKUserInfo.h"
#import "WKHomeViewController.h"

@interface WKRegisterInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *backView;
    UIView *pickerViewBackView;
    NSDictionary *poiDic;
    NSArray *stateArray;
    NSArray *cityArray;
    NSString *statey;
    NSString *city;
    NSString *selectedState;
    NSString *selectedCity;
    NSInteger selectStateIndex;
    NSInteger selectCityIndex;
    NSString *gender;
}
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (weak, nonatomic) IBOutlet UITextField *familynameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *kiechenTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *proviceTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (nonatomic, strong)UIPickerView *pickerView;
@property (strong, nonatomic) WKUserInfo *userInfo;

@end

@implementation WKRegisterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    poiDic = [ELEBaseInfoTool poiDict];
    stateArray = [ELEBaseInfoTool stateArray];
    _userInfo = [[WKUserInfo alloc]init];

}

- (void)getAllState{
    NSDictionary *param = @{@"CountryId":@1000};
    [[WKNetworkManager sharedManager] GET:@"v1/GeoState/GetList" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"发送成功");
            NSLog(@"response %@",responseObject);
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YRToastView showMessage:error.description inView:self.view];
    }];
}
- (IBAction)selectState:(id)sender {
    
    [self configuratePickView:101];
}

- (IBAction)selectCity:(id)sender {

    [self configuratePickView:102];

}
- (IBAction)selectMale:(UIButton *)sender {
    sender.selected = YES;
    self.femaleBtn.selected = NO;
    gender = @"M";
}
- (IBAction)chooseFemale:(UIButton *)sender {
    sender.selected = YES;
    self.maleBtn.selected = NO;
    gender = @"F";

}

- (IBAction)tapBackGround:(id)sender {
    [_cityTextField resignFirstResponder];
    [_proviceTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_familynameTextField resignFirstResponder];
    [_detailAddressTextField resignFirstResponder];
}


- (IBAction)registerAction:(id)sender {
    NSString *stateTemp = _proviceTextField.text;
    if (_proviceTextField.text.length == 0 || _cityTextField.text.length == 0) {
        [YRToastView showMessage:@"请选择城市" inView:self.view];
        return;
    }
    NSDictionary *stateDict = [ELEBaseInfoTool stateDict];
    NSString *state = @"";
    if ([stateDict objectForKey:stateTemp]) {
        state = stateDict[stateTemp];
    }
 
    NSDictionary *param = @{
                            @"ChefUsername":[NSString stringWithFormat:@"%@ %@",_familynameTextField.text,_nameTextField.text],
                            @"ChefGender":gender,
                            @"AddressLine1":_detailAddressTextField.text,
                            @"AddressLine2":@"",
                            @"AddressLine3":@"",
                            @"City":_cityTextField.text,
                            @"State":state?state:@"",
                            @"PortraitImageId":@"0",
                            @"ThemeImageId":@"0",
                            @"KitchenStory":@"0",
                            @"BroadcastMessage":@"0",
                            @"CanPickup":@"true",
                            @"CanDeliver":@"false",
                            @"InvitationCode":@"",
                            @"Country":@"US",
                            @"Postcode":@"90012",
                            @"Latitude":@"0",
                            @"Longitude":@"0",
                            @"Name":_kiechenTextField.text
                            };
    [[WKNetworkManager sharedAuthManager] POST:@"v1/Kitchen/Register" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"返回信息 %@",responseObject);
                if (responseObject && [responseObject objectForKey:@"IsSuccessful"]) {
                    if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                        [YRToastView showMessage:@"注册成功" inView:self.view];
                        //保存厨房信息
                        NSDictionary *result = (NSDictionary *)responseObject;
                        NSDictionary *kitchenInfo = result[@"Kitchen"];
                        _userInfo.KitchenId = [kitchenInfo[@"UserId"] integerValue];
                        _userInfo.userName = kitchenInfo[@"Name"];
                        _userInfo.nickName = kitchenInfo[@"ChefUsername"];
                        _userInfo.mobilNum = kitchenInfo[@"ChefMobileNumber"];
                        _userInfo.gender = kitchenInfo[@"ChefGender"];
                        _userInfo.PortraitImageUrl = kitchenInfo[@"PortraitImageUrl"];
                        _userInfo.State = kitchenInfo[@"State"];
                        _userInfo.City = kitchenInfo[@"City"];
                        _userInfo.InspectionStatus = kitchenInfo[@"InspectionStatus"];
                        _userInfo.AddressLine1 = kitchenInfo[@"AddressLine1"];
                        
                        _userInfo.accessToken = _accessToken;
                        _userInfo.expirationDate = _expirationDate;
                        _userInfo.tokenType = _tokenType;
                        
                        [WKKeyChain saveUserInfo:kAPPSecurityStoreKey userInfo:_userInfo];
                        
                        WKHomeViewController *home = [[WKHomeViewController alloc]init];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
                        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                    
                    }
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView showMessage:@"注册失败" inView:self.view];

    }];
}



-(void)configuratePickView:(NSInteger)tag{
    
    [self setupBackView];
    pickerViewBackView = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height, screen_width, screen_height / 3 + 5)];
    [backView addSubview:pickerViewBackView];
    
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 10, screen_width, screen_height / 3)];
    _pickerView.tag = tag;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.userInteractionEnabled = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [pickerViewBackView addSubview:_pickerView];
    [self setCancelAndConfirm:pickerViewBackView];
    
    [self animationAppear:pickerViewBackView tran:-(screen_height / 3 + 5)];

    
}

-(void)setupBackView{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
    [backView addGestureRecognizer:tap];
}

-(void)removeBackView{
    [self animationDisMiss];
}

-(void)animationDisMiss{
    for (int index = 0; index < backView.subviews.count; index ++) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            backView.subviews[index].transform = CGAffineTransformMakeTranslation(0,0);
            
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }
}


-(void)setCancelAndConfirm:(UIView *)backview{
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 60, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width - 60, 5, 60, 40)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:confirmBtn];
}

-(void)confirmAction:(UIButton *)sender{
    [self animationDisMiss];
}

-(void)cancelAction:(UIButton *)sender{
    [self animationDisMiss];
    
}

-(void)animationAppear:(UIView*)backView1 tran:(CGFloat)translation_y{
    [UIView  animateWithDuration:0.3 animations:^{
        backView1.transform = CGAffineTransformMakeTranslation(0,translation_y);
    }];
}
//UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
    
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return stateArray.count;
    }else{
        NSString *tempState = stateArray[selectStateIndex];
        if ([poiDic objectForKey:tempState]) {
            return  [poiDic[tempState] count];
        }else{
            return 0;
        }
    }
    
    return 1;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    if (component == 0) {
        return stateArray[row];
    }else{
        NSString *tempState = stateArray[selectStateIndex];
        if ([poiDic objectForKey:tempState]) {
            NSArray *cities = poiDic[tempState];
            return cities[row];
        }else{
            return @"";
        }
        
//        if (cityDic[selectedProvince]) {
//            NSArray *array = cityDic[selectedProvince];
//            NSString *city = array[row];
//            return city;
//        }else{
//            return @"";
//        }
    }
    
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
    if (component == 0) {
        selectedState = stateArray[row];
        selectStateIndex = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        _proviceTextField.text = selectedState;
        
    }else{
        
        NSString *tempState = stateArray[selectStateIndex];
        if ([poiDic objectForKey:tempState]) {
            NSArray *cities = poiDic[tempState];
            selectedCity = cities[row];
            _cityTextField.text = selectedCity;
            selectCityIndex = row;
        }
    }

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
