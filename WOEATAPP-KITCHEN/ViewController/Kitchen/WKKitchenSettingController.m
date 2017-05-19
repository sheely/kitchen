//
//  WKKitchenSettingController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/24.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKKitchenSettingController.h"
#import "WKKitchenCoverCell.h"
#import "WKKitchen.h"
#import "AddPhotoDelegate.h"
#import "SDPhotoBrowser.h"
#import "TZImagePickerController.h"
#import "TagsViewCell.h"


@interface WKKitchenSettingController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AddPhotoDelegate,SDPhotoBrowserDelegate,TZImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    SDPhotoBrowser *browser;
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

@property (nonatomic, strong) UITableView *kitchenTableView;
@property (nonatomic, strong) UITextField *kitchenNameField;
@property (nonatomic, strong) UITextField *contactNameField;
@property (nonatomic, strong) WKKitchen *curKitchen;
@property (nonatomic, strong) NSMutableArray *pics;
@property (nonatomic, strong) UIButton *btnMale;
@property (nonatomic, strong) UIButton *btnFemale;
@property (nonatomic, strong) UIButton *btnSelfTake;
@property (nonatomic, strong) UIButton *btnKitchenSend;
@property (nonatomic, strong) UITextView *storyTextView;

@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) TagsFrame *tagsFrame;
@property (nonatomic, strong) NSString *kitchenId;
@property (nonatomic, strong) UIButton *btnState;
@property (nonatomic, strong) UIButton *btnCity;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UITextField *streetField;
@property (nonatomic, strong) UITextField *postcodeField;

@end

@implementation WKKitchenSettingController

- (void)loadView
{
    [super loadView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.curKitchen = [[WKKitchen alloc] init];
    [self.view addSubview:self.kitchenTableView];
    self.title = @"厨房信息";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveKitchen:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    _tagsArray = @[@"湘菜",@"有机素材",@"武都",@"辣酱抽"];

    _tagsFrame = [[TagsFrame alloc] init];
    _tagsFrame.tagsMinPadding = 5;
    _tagsFrame.tagsMargin = 20;
    _tagsFrame.tagsLineSpacing = 10;
    _tagsFrame.tagsArray = _tagsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    poiDic = [ELEBaseInfoTool poiDict];
    stateArray = [ELEBaseInfoTool stateArray];

    _pics = [NSMutableArray new];
    [self fetchKitenInfo];
}


- (UITableView *)kitchenTableView
{
    if (_kitchenTableView == nil) {
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _kitchenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY) style:UITableViewStylePlain];
        _kitchenTableView.dataSource = self;
        _kitchenTableView.delegate = self;
        _kitchenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _kitchenTableView.separatorColor = [UIColor lightGrayColor];
        _kitchenTableView.tableFooterView = [[UIView alloc] init];
        if ([_kitchenTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_kitchenTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _kitchenTableView;
}

- (UITextField *)kitchenNameField
{
    if (_kitchenNameField == nil) {
        _kitchenNameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 30, screen_width - 40, 40)];
        _kitchenNameField.placeholder = @"创建后不可修改";
        _kitchenNameField.delegate = self;
        _kitchenNameField.font = [UIFont systemFontOfSize:16];
    }
    return _kitchenNameField;
}

- (UITextField *)contactNameField
{
    if (_contactNameField == nil) {
        _contactNameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 30, screen_width - 40, 40)];
        _contactNameField.placeholder = @"创建后不可修改";
        _contactNameField.delegate = self;
        _contactNameField.font = [UIFont systemFontOfSize:16];
    }
    return _contactNameField;
}

- (UIButton *)btnMale
{
    if (_btnMale == nil) {
        _btnMale = [[UIButton alloc] initWithFrame:CGRectMake(26, 30, 60, 40)];
        _btnMale.tag = 1000;
        _btnMale.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_btnMale setTitle:@"男" forState:UIControlStateNormal];
        [_btnMale.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnMale setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnMale setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnMale setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnMale addTarget:self action:@selector(maleChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMale;
}

- (UIButton *)btnFemale
{
    if (_btnFemale == nil) {
        _btnFemale = [[UIButton alloc] initWithFrame:CGRectMake(100, 30, 60, 40)];
        _btnFemale.tag = 1001;
        [_btnFemale setTitle:@"女" forState:UIControlStateNormal];
        _btnFemale.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_btnFemale.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnFemale setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnFemale setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnFemale setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnFemale addTarget:self action:@selector(maleChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFemale;
}

- (UIButton *)btnState
{
    if (_btnState == nil) {
        _btnState = [[UIButton alloc] initWithFrame:CGRectMake(35, 70, screen_width/2 - 30, 40)];
        _btnState.tag = 101;
        [_btnState setTitle:@"州" forState:UIControlStateNormal];
        [_btnState.titleLabel setFont:[UIFont systemFontOfSize:16]];
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
        [_btnCity.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnCity setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btnCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btnCity addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCity;
}

- (UITextField *)streetField
{
    if (_streetField == nil) {
        _streetField = [[UITextField alloc] initWithFrame:CGRectMake(120, 30, screen_width - 100, 40)];
        _streetField.textColor = [UIColor colorWithHexString:@"666666"];
        _streetField.font = [UIFont systemFontOfSize:16];
        _streetField.delegate = self;
    }
    return _streetField;
}

- (UITextField *)postcodeField
{
    if (_postcodeField == nil) {
        _postcodeField = [[UITextField alloc] initWithFrame:CGRectMake(80, 110, screen_width - 70, 40)];
        _postcodeField.textColor = [UIColor colorWithHexString:@"666666"];
        _postcodeField.font = [UIFont systemFontOfSize:16];
        _postcodeField.delegate = self;
    }
    return _postcodeField;
}

- (UIButton *)btnSelfTake
{
    if (_btnSelfTake == nil) {
        _btnSelfTake = [[UIButton alloc] initWithFrame:CGRectMake(28, 30, 100, 40)];
        _btnSelfTake.tag = 1000;
        [_btnSelfTake setTitle:@"饭友自取" forState:UIControlStateNormal];
        [_btnSelfTake.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _btnSelfTake.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_btnSelfTake setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnSelfTake setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnSelfTake setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnSelfTake addTarget:self action:@selector(sendStyleChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSelfTake;
}

- (UIButton *)btnKitchenSend
{
    if (_btnKitchenSend == nil) {
        _btnKitchenSend = [[UIButton alloc] initWithFrame:CGRectMake(160, 30, 100, 40)];
        _btnKitchenSend.tag = 1001;
        _btnKitchenSend.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_btnKitchenSend setTitle:@"家厨配送" forState:UIControlStateNormal];
        [_btnKitchenSend.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnKitchenSend setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnKitchenSend setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnKitchenSend setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnKitchenSend addTarget:self action:@selector(sendStyleChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnKitchenSend;
}

- (UITextView *)storyTextView
{
    if (_storyTextView == nil) {
        _storyTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 32, screen_width - 40, 100)];
        _storyTextView.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
        _storyTextView.layer.borderWidth = 1.0;
        _storyTextView.font = [UIFont systemFontOfSize:16];
    }
    return _storyTextView;
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

- (void)fetchKitenInfo{
    NSDictionary *param = @{};
    __weak typeof(self) weakSelf = self;
    [[WKNetworkManager sharedAuthManager] GET:@"v1/Kitchen/GetMyKitchen" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = (NSDictionary *)responseObject[@"Kitchen"];
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {

                    weakSelf.curKitchen.kitchenId = [result[@"Id"] stringValue];
                    weakSelf.curKitchen.name = result[@"Name"];
                    weakSelf.curKitchen.displayOrder = [result[@"DisplayOrder"] integerValue];
                    weakSelf.curKitchen.isCertified = [result[@"IsCertified"] boolValue];
                    weakSelf.curKitchen.portiaitImageUrl = result[@"PortiaitImageUrl"];
                    weakSelf.curKitchen.chefImageUrl = result[@"ChefImageUrl"];
                    weakSelf.curKitchen.chefName = result[@"ChefUsername"];
                    weakSelf.curKitchen.chefGender = result[@"ChefGender"];
                    weakSelf.curKitchen.addressLine1 = result[@"AddressLine1"];
                    weakSelf.curKitchen.addressLine2 = result[@"AddressLine2"];
                    weakSelf.curKitchen.city = result[@"City"];
                    weakSelf.curKitchen.state = result[@"State"];
                    weakSelf.curKitchen.postCode = result[@"Postcode"];
                    weakSelf.curKitchen.latitude = [result[@"Latitude"] floatValue];
                    weakSelf.curKitchen.longitude = [result[@"Longitude"] floatValue];
                    weakSelf.curKitchen.customerRating = [result[@"CustomerRating"] floatValue];
                    weakSelf.curKitchen.broadcastMessage = result[@"BroadcastMessage"];
                    weakSelf.curKitchen.kitchenStory = result[@"KitchenStory"];
                    weakSelf.curKitchen.canPickup = [result[@"CanPickup"] boolValue];
                    weakSelf.curKitchen.canDeliver = [result[@"CanDeliver"] boolValue];
                    weakSelf.curKitchen.tags = result[@"TagList"];
                    weakSelf.kitchenId = [result[@"Id"] stringValue];
                    if ([responseObject[@"TagList"] isKindOfClass:[NSArray class]]) {
                        weakSelf.curKitchen.tags = result[@"TagList"];
                    }
                    NSArray *imageArray = responseObject[@"Images"];
                    if (imageArray.count > 0) {
                        [weakSelf.curKitchen.images addObjectsFromArray:imageArray];
                    }
                    [weakSelf.kitchenTableView reloadData];
                }
              
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];
    
}

#pragma mark - button event 
- (void)maleChanged:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    if (tag == 1000) {
        self.btnMale.selected = YES;
        self.btnFemale.selected = NO;
    }else{
        self.btnMale.selected = NO;
        self.btnFemale.selected = YES;
    }
}

- (void)sendStyleChanged:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    if (tag == 1000) {
        self.btnSelfTake.selected = !self.btnSelfTake.selected;
        self.curKitchen.canPickup = self.btnSelfTake.selected;
    }else{
        self.btnKitchenSend.selected = !self.btnKitchenSend.selected;
        self.curKitchen.canDeliver = self.btnKitchenSend.selected;
    }
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

-(void)setupBackView{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
    [backView addGestureRecognizer:tap];
}

#pragma mark- tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        WKKitchenCoverCell *kitchenCell = [[WKKitchenCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KitchenCell"];
        [kitchenCell loadImages:self.curKitchen.images];
        kitchenCell.delegate = self;
//        [kitchenCell setPhotos:@[@"meishi",@"meishi.jpg",@"meishi.jpg",@"meishi.jpg"]];
        cell = kitchenCell;
    }else if (indexPath.row == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  厨房名称"]];
        if (CheckValidString(self.curKitchen.name)) {
            self.kitchenNameField.enabled = NO;
        }
        self.kitchenNameField.text = self.curKitchen.name;
        [cell addSubview:self.kitchenNameField];
    }else if (indexPath.row == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  联系人姓名"]];
        if (CheckValidString(self.curKitchen.chefName)) {
            self.contactNameField.enabled = NO;
        }
        self.contactNameField.text = self.curKitchen.chefName;
        [cell addSubview:self.contactNameField];
    }else if (indexPath.row == 3) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  联系人性别"]];
        if ([self.curKitchen.chefGender isEqualToString:@"男"]) {
            self.btnMale.selected = YES;
            self.btnFemale.selected = NO;
        }else{
            self.btnMale.selected = NO;
            self.btnFemale.selected = YES;
        }
        [cell addSubview:self.btnMale];
        [cell addSubview:self.btnFemale];
    }else if (indexPath.row == 4) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  厨房地址"]];
        
        UILabel *labStreet = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 80, 40)];
        labStreet.text = @"街道地址";
        labStreet.textColor = [UIColor colorWithHexString:@"666666"];
        labStreet.font = [UIFont systemFontOfSize:16];
        [cell addSubview:labStreet];
        self.streetField.text = self.curKitchen.addressLine1;
        [cell addSubview:self.streetField];
       
        [self.btnState setTitle:[NSString stringWithFormat:@"州   %@",self.curKitchen.state] forState:UIControlStateNormal];
        [cell addSubview:self.btnState];
        [self.btnCity setTitle:[NSString stringWithFormat:@"城市   %@",self.curKitchen.city] forState:UIControlStateNormal];
        [cell addSubview:self.btnCity];
        
        UILabel *labPostcode = [[UILabel alloc] initWithFrame:CGRectMake(35, 110, 50, 40)];
        labPostcode.text = @"邮编";
        labPostcode.textColor = [UIColor colorWithHexString:@"666666"];
        labPostcode.font = [UIFont systemFontOfSize:16];
        [cell addSubview:labPostcode];
        self.postcodeField.text = self.curKitchen.postCode;
        [cell addSubview:self.postcodeField];
    }
//    else if (indexPath.row == 5) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
//        [cell addSubview:[self creatViewWithTitle:@"*  厨房特色"]];
//
//        TagsViewCell *tagCell = [TagsViewCell cellWithTableView:tableView];
//        tagCell.tagsFrame = self.tagsFrame;
//        CGRect frame = tagCell.frame;
//        frame.origin.y = 30;
//        tagCell.frame = frame;
//        [cell addSubview:tagCell];
//        
//    }
    else if (indexPath.row == 5) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  配送方式"]];
        [cell addSubview:self.btnSelfTake];
        [cell addSubview:self.btnKitchenSend];
        self.btnSelfTake.selected = self.curKitchen.canPickup;
        self.btnKitchenSend.selected = self.curKitchen.canDeliver;
        
//        UILabel *labDesc = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, screen_width - 40, 50)];
//        labDesc.text = @"您的厨房直线距离3公里内可以由平台为您配送，您还需要至少选择1项其他就餐方式";
//        labDesc.textColor = [UIColor colorWithHexString:@"666666"];
//        labDesc.font = [UIFont systemFontOfSize:13];
//        labDesc.numberOfLines = 0;
//        [cell addSubview:labDesc];
    }else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  厨房故事"]];
        self.storyTextView.text = self.curKitchen.kitchenStory;
        [cell addSubview:self.storyTextView];
    }
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 30 + 10 + (screen_width - 10 * 5) / 4 + 10;
            break;
        case 4:
            height = 150;
            break;
        case 5:
            height = 70;
            break;
        case 6:
            height = 142;
            break;
//        case 5:
//            height = 30 + [self.tagsFrame tagsHeight];
//            break;
        default:
            height = 70;
            break;
    }
    return height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.streetField resignFirstResponder];
    [self.postcodeField resignFirstResponder];
    [self.storyTextView resignFirstResponder];
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"meishi"];
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //    if (_photos.count <= index) {
    //        return nil;
    //    }
    //    NSDictionary *dic = _photos[index];
    //    return [NSURL URLWithString:dic[@"url"]];
    return nil;
}

//删除图片
-(void)deletePhotoForIndex:(NSInteger)index{
    //    if (_photos.count > index) {
    //        [self deletePhoto:@[_photos[index]]];
    //        [_photos removeObjectAtIndex:index];
    //        browser.currentImageIndex = index;
    //    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        browser = [[SDPhotoBrowser alloc] init];
        browser.isClient = NO;
        browser.sourceImagesContainerView = self.view; // 原图的父控件
        browser.imageCount = 4; // 图片总数
        //        browser.currentImageIndex = cell.touchPicLocation;
        //        NSLog(@"点击第%ld张",(long)cell.touchPicLocation);
        browser.delegate = self;
        [browser show];
    }
}

#pragma mark - save
- (void)saveKitchen:(id)sender
{
    if (self.curKitchen.canPickup == 0 && self.curKitchen.canDeliver == 0) {
        [YRToastView showMessage:@"请选择一种配送方式" inView:self.view];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:(CheckValidString(self.curKitchen.kitchenId) ? self.curKitchen.kitchenId:@"") forKey:@"Id"];
    [param setObject:(CheckValidString(self.curKitchen.name) ? self.curKitchen.chefName:@"") forKey:@"Name"];
    [param setObject:(CheckValidString(self.curKitchen.chefName) ? self.curKitchen.chefName:@"") forKey:@"ChefName"];
    NSString *strGender = @"";
    if (self.btnMale.selected) {
        strGender = @"男";
    }else{
        strGender = @"女";
    }
    [param setObject:strGender forKey:@"ChefGender"];
    [param setObject:(CheckValidString(self.streetField.text) ? self.streetField.text:@"") forKey:@"AddressLine1"];
    [param setObject:(CheckValidString(self.curKitchen.addressLine2) ? self.curKitchen.addressLine2:@"") forKey:@"AddressLine2"];
    NSString *strCity = self.btnCity.titleLabel.text;
    NSString *preStr = @"城市   ";
    strCity = [strCity substringFromIndex:preStr.length - 1];
    [param setObject:(CheckValidString(strCity) ? strCity:@"") forKey:@"City"];
    NSString *strState = self.btnState.titleLabel.text;
    preStr = @"州   ";
    strState = [strState substringFromIndex:preStr.length - 1];
    

    NSDictionary *stateDict = [ELEBaseInfoTool stateDict];
    NSString *state = @"";
//    if ([stateDict objectForKey:strState]) {
//        state = stateDict[strState];
//    }
    
    for (NSString *key in stateDict.allKeys) {
        NSString *real= [NSString stringWithString:key];
        NSString *str = [strState stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([real isEqualToString:str]) {
            state = [stateDict objectForKey:real];
        }
    }
    
    [param setObject:(CheckValidString(state) ? state:@"") forKey:@"State"];
    [param setObject:(CheckValidString(self.postcodeField.text) ? self.postcodeField.text:@"") forKey:@"Postcode"];
    [param setObject:(CheckValidString(self.curKitchen.broadcastMessage) ? self.curKitchen.broadcastMessage:@"") forKey:@"BroadcastMessage"];
    NSString *canDeliver = @"";
    if (self.curKitchen.canDeliver == 0) {
        canDeliver = @"false";
    }else{
        canDeliver = @"true";
    }
    NSString *canPickup = @"";
    if (self.curKitchen.canPickup == 0) {
        canPickup = @"false";
    }else{
        canPickup = @"true";
    }
    [param setObject:@(self.curKitchen.latitude) forKey:@"Latitude"];
    [param setObject:@(self.curKitchen.longitude) forKey:@"Longitude"];
    [param setObject:canPickup forKey:@"CanPickup"];
    [param setObject:canDeliver forKey:@"CanDeliver"];
    [param setObject:self.storyTextView.text forKey:@"KitchenStory"];
    
    WS(ws);
    [[WKNetworkManager sharedAuthManager] POST:@"v1/Kitchen/Update" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        [ws.navigationController popViewControllerAnimated:YES];
        [YRToastView showMessage:@"保存成功" inView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark- Add Pic Delegate Methods
- (void)didAddButtonClick:(WKKitchenCoverCell*)tableViewCell{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSInteger KitchenId = [[WKKeyChain load:[NSString stringWithFormat:@"%@_KitchenId",kAPPSecurityStoreKey]] integerValue];
    [YRToastView show:@"" inView:self.view type:YRToastTypeLoading];
    for (int i = 0 ; i <photos.count; i++) {
        //上传图片
        //  UIImage *image = [UIImage imageNamed:@""];
        //  NSData *data = UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        NSDictionary *param = @{@"ImageFile":fileName,@"KitchenId":@(KitchenId)};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        WKUserInfo *account = [WKKeyChain loadUserInfo:kAPPSecurityStoreKey];
        NSString *accessToken = account.accessToken;
        NSString *tokenType = account.tokenType;
        NSString *authorization = [NSString stringWithFormat:@"%@ %@",tokenType,accessToken];
        if (authorization.length > 0) {
            [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"authorization"];
        }
  
        [manager POST:@"https://api.woeatapp.com/v1/Kitchen/UploadKitchenImage" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(photos[i], 1.0f);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image %d",i] fileName:fileName mimeType:@"image/jpg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [YRToastView hide];
            __typeof(self) weakSelf = self;

            if ( [responseObject isKindOfClass:[NSString class]]) {
                NSLog(@"response %@",responseObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"发送成功"); 
                    if (i == photos.count -1) {
                        [YRToastView showMessage:@"上传成功" inView:self.view];
                        [weakSelf.kitchenTableView reloadData];
                    }
                });
            }else if([responseObject isKindOfClass:[NSDictionary class]]){
//                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *result = responseObject;
                if ([result objectForKey:@"Url"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"发送成功");
                        if (i == photos.count -1) {
                            NSDictionary *dic =  @{@"Image":@{@"Url":result[@"Url"]}};
                            [weakSelf.curKitchen.images addObject:dic];
                            [YRToastView showMessage:@"上传成功" inView:self.view];
                            [weakSelf.kitchenTableView reloadData];
                        }
                    });
                }
           
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"图片上传 %@",error.description);
            [YRToastView hide];
        }];
    }
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


@end
