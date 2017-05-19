//
//  WKBandAccountViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by huangyirong on 2016/10/25.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKBandAccountViewController.h"
#import "WKCardTypeCell.h"

@interface WKBandAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
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
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, strong) NSArray *cardTypeArray;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *expireTimeField;
//地址
@property (nonatomic, strong) UIButton *btnState;
@property (nonatomic, strong) UIButton *btnCity;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UITextField *streetField;
@property (nonatomic, strong) UITextField *postcodeField;

@end

@implementation WKBandAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置银行账号";
    [self.view addSubview:self.tableView];

    poiDic = [ELEBaseInfoTool poiDict];
    stateArray = [ELEBaseInfoTool stateArray];

    _cardTypeArray = @[@"Visa",@"MasterCard",@"Amex",@"Discover",@"Other"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveAddCard:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}


- (UIView *)creatViewWithTitle:(NSString *)title
{
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    backView1.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7" andAlpha:1.0];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width - 40, 30)];
    labTitle.text = title;
    labTitle.textColor = [UIColor blackColor];
    [backView1 addSubview:labTitle];
    return backView1;
}

- (UITextField *)nameField
{
    if (_nameField == nil) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, screen_width - 40, 40)];
        _nameField.placeholder = @"未填写";
        _nameField.delegate = self;
        _nameField.font = [UIFont systemFontOfSize:13];
    }
    return _nameField;
}

- (UITextField *)accountField
{
    if (_accountField == nil) {
        _accountField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, screen_width - 40, 40)];
        _accountField.placeholder = @"未填写";
        _accountField.delegate = self;
        _accountField.font = [UIFont systemFontOfSize:13];
    }
    return _accountField;
}

- (UITextField *)expireTimeField
{
    if (_expireTimeField == nil) {
        _expireTimeField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, screen_width - 40, 40)];
        _expireTimeField.placeholder = @"未填写";
        _expireTimeField.delegate = self;
        _expireTimeField.font = [UIFont systemFontOfSize:13];
    }
    return _expireTimeField;
}

- (UIButton *)btnState
{
    if (_btnState == nil) {
        _btnState = [[UIButton alloc] initWithFrame:CGRectMake(30, 70, screen_width/2 - 30, 40)];
        _btnState.tag = 101;
        [_btnState setTitle:@"州" forState:UIControlStateNormal];
        [_btnState.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_btnState setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btnState.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btnState addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnState;
}

- (UIButton *)btnCity
{
    if (_btnCity == nil) {
        _btnCity = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2, 70, screen_width/2 - 20, 40)];
        _btnCity.tag = 102;
        [_btnCity setTitle:@"城市" forState:UIControlStateNormal];
        [_btnCity.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_btnCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btnCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btnCity addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCity;
}

- (UITextField *)streetField
{
    if (_streetField == nil) {
        _streetField = [[UITextField alloc] initWithFrame:CGRectMake(90, 30, screen_width - 100, 40)];
        _streetField.textColor = [UIColor colorWithHexString:@"666666"];
        _streetField.font = [UIFont systemFontOfSize:13];
        _streetField.delegate = self;
    }
    return _streetField;
}

- (UITextField *)postcodeField
{
    if (_postcodeField == nil) {
        _postcodeField = [[UITextField alloc] initWithFrame:CGRectMake(60, 110, screen_width - 70, 40)];
        _postcodeField.textColor = [UIColor colorWithHexString:@"666666"];
        _postcodeField.font = [UIFont systemFontOfSize:13];
        _postcodeField.delegate = self;
    }
    return _postcodeField;
}

- (void)saveAddCard:(id)sender
{
//    [YRToastView showMessage:@"保存成功" inView:self.view];

}

- (void)selectState:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    [self configuratePickView:tag];
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

-(void)setupBackView{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
    [backView addGestureRecognizer:tap];
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
        [self.btnState setTitle:[NSString stringWithFormat:@"州   %@",selectedState] forState:UIControlStateNormal];
    }else{
        
        NSString *tempState = stateArray[selectStateIndex];
        if ([poiDic objectForKey:tempState]) {
            NSArray *cities = poiDic[tempState];
            selectedCity = cities[row];
            selectCityIndex = row;
            [self.btnCity setTitle:[NSString stringWithFormat:@"城市   %@",selectedCity] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark---------UITableViewDataSource, UITableViewDelegate 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else{
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height =  40;
    }else{
        switch (indexPath.row) {
            case 0:
            case 1:
            case 2:
                height = 70;
                break;
            default:
                height = 150;
                break;
        }
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        WKCardTypeCell *cardCell = [[WKCardTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        BOOL check = (self.curIndex == indexPath.row);
        [cardCell loadData:self.cardTypeArray[indexPath.row] checked:check];
        cell = cardCell;
    }else{
        if(indexPath.row == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
            [cell addSubview:[self creatViewWithTitle:@"持卡人姓名"]];
            [cell addSubview:self.nameField];
        }else if(indexPath.row == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
            [cell addSubview:[self creatViewWithTitle:@"账号"]];
            [cell addSubview:self.accountField];
        }else if(indexPath.row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
            [cell addSubview:[self creatViewWithTitle:@"过期时间"]];
            [cell addSubview:self.expireTimeField];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
            [cell addSubview:[self creatViewWithTitle:@"账单地址"]];
            UILabel *labStreet = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 60, 40)];
            labStreet.text = @"街道地址";
            labStreet.textColor = [UIColor colorWithHexString:@"666666"];
            labStreet.font = [UIFont systemFontOfSize:13];
            [cell addSubview:labStreet];
            [cell addSubview:self.streetField];
            
            [self.btnState setTitle:[NSString stringWithFormat:@"州   %@",@"dd"] forState:UIControlStateNormal];
            [cell addSubview:self.btnState];
            [self.btnCity setTitle:[NSString stringWithFormat:@"城市   %@",@"dd"] forState:UIControlStateNormal];
            [cell addSubview:self.btnCity];
            
            UILabel *labPostcode = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, 30, 40)];
            labPostcode.text = @"邮编";
            labPostcode.textColor = [UIColor colorWithHexString:@"666666"];
            labPostcode.font = [UIFont systemFontOfSize:13];
            [cell addSubview:labPostcode];
            [cell addSubview:self.postcodeField];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.curIndex = indexPath.row;
        [self.tableView reloadData];
    }else{
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self creatViewWithTitle:@"类型"];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }else{
        return 0;
    }
}
@end
