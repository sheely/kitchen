//
//  WKPersionalViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/24.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKPersionalViewController.h"
#import "TZImagePickerController.h"
#import "WKUser.h"

@interface WKPersionalViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *personTable;
@property (nonatomic, strong) UITextField *firstNameField;
@property (nonatomic, strong) UITextField *familyNameField;
@property (nonatomic, strong) UIButton *btnMale;
@property (nonatomic, strong) UIButton *btnFemale;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgPersonAvatar;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) WKUser *curUser;

@end

@implementation WKPersionalViewController

- (void)loadView
{
    [super loadView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人信息";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(savePersonalInfo:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.personTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.curUser = [[WKUser alloc] init];
    [self fetchUserInfo];
}

- (UITableView *)personTable
{
    if (_personTable == nil) {
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _personTable = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY) style:UITableViewStylePlain];
        _personTable.dataSource = self;
        _personTable.delegate = self;
        _personTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _personTable.separatorColor = [UIColor lightGrayColor];
        _personTable.tableFooterView = [[UIView alloc] init];
        if ([_personTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [_personTable setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _personTable;
}

- (UIImageView *)imgPersonAvatar
{
    if (_imgPersonAvatar == nil) {
        _imgPersonAvatar = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width - 100) / 2, 10, 100, 100)];
        _imgPersonAvatar.backgroundColor = [UIColor lightGrayColor];
        _imgPersonAvatar.userInteractionEnabled = YES;
        [_imgPersonAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadAvatar)]];
    }
    return _imgPersonAvatar;
}


- (UITextField *)familyNameField
{
    if (_familyNameField == nil) {
        _familyNameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 5, screen_width - 40, 30)];
        _familyNameField.placeholder = @"您的姓名";
        _familyNameField.delegate = self;
    }
    return _familyNameField;
}

- (UITextField *)firstNameField
{
    if (_firstNameField == nil) {
        _firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(screen_width / 2 + 20, 5, screen_width / 2 - 20, 30)];
        _firstNameField.placeholder = @"您的名";
        _firstNameField.delegate = self;
    }
    return _firstNameField;
}

- (UIButton *)btnMale
{
    if (_btnMale == nil) {
        _btnMale = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
        _btnMale.tag = 1000;
        [_btnMale setTitle:@"男" forState:UIControlStateNormal];
        [_btnMale setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnMale setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnMale setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnMale setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_btnMale addTarget:self action:@selector(maleChanged:) forControlEvents:UIControlEventTouchUpInside];
        _btnMale.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    }
    return _btnMale;
}

- (UIButton *)btnFemale
{
    if (_btnFemale == nil) {
        _btnFemale = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 60, 40)];
        _btnFemale.tag = 1001;
        [_btnFemale setTitle:@"女" forState:UIControlStateNormal];
        [_btnFemale setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnFemale setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnFemale setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnFemale setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        _btnFemale.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        [_btnFemale addTarget:self action:@selector(maleChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFemale;
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

- (void)uploadAvatar
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)fetchUserInfo{
    NSDictionary *param = @{};
    WS(ws);
    [[WKNetworkManager sharedAuthManager] POST:@"v1/User/GetMyDetails" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = (NSDictionary *)responseObject[@"User"];
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                    ws.curUser.userId = [result[@"id"] stringValue];
                    ws.curUser.avatarIcon = result[@"PortraitImageUrl"];
                    ws.curUser.familyName = result[@"DisplayName"];
//                    ws.curUser.firstName = result[@"FirstName"];
                    ws.curUser.gender = result[@"Gender"];
                    [ws.personTable reloadData];
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];
    
}

- (void)savePersonalInfo:(id)sender
{
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.familyNameField.text forKey:@"DisplayName"];
    NSString *strGender = @"";
    if (self.btnMale.selected) {
        strGender = @"男";
    }else{
        strGender = @"女";
    }
    [param setObject:strGender forKey:@"Gender"];
    
    [[WKNetworkManager sharedAuthManager] POST:@"v1/User/UpdateUserDetails" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
//                    [ws.navigationController popViewControllerAnimated:YES];
                    [YRToastView showMessage:@"保存成功" inView:self.view];

                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];
}

- (void)updateAvatarImage:(NSString *)imageId
{
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:imageId forKey:@"ImageId"];
    
    [[WKNetworkManager sharedAuthManager] POST:@"v1/User/UpdateUserImage" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                    [ws.navigationController popViewControllerAnimated:YES];
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];
}
#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [YRToastView show:@"" inView:self.view type:YRToastTypeLoading];
    WS(ws);
    for (int i = 0 ; i <photos.count && i < 1; i++) {
        self.imgPersonAvatar.image = photos[i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        NSDictionary *param = @{@"ImageFile":fileName};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
        
        [manager POST:@"https://api.woeatapp.com/v1/Image/Upload" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(photos[i], 1.0f);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image %d",i] fileName:fileName mimeType:@"image/jpg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [YRToastView hide];
            if ( [responseObject isKindOfClass:[NSDictionary class]]) {
                [ws updateAvatarImage:responseObject[@"Id"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"图片上传 %@",error.description);
            [YRToastView hide];
        }];
    }
}

- (void)testUploadImage
{
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
        if ( [responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"response %@",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片上传 %@",error.description);
    }];
}

#pragma mark- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
        [cell addSubview:self.imgPersonAvatar];
        [self.imgPersonAvatar sd_setImageWithURL:[NSURL URLWithString:self.curUser.avatarIcon] placeholderImage:nil];
        cell.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    }else if (indexPath.row == 1){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        cell.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];

        UILabel *labDesc1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width - 40, 30)];
        labDesc1.text = @"*  姓名";
        [cell addSubview:labDesc1];
//        
//        UILabel *labDesc2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width / 2 + 20, 0, screen_width / 2 - 20, 30)];
//        labDesc2.text = @"*名";
//        [cell addSubview:labDesc2];
    }else if (indexPath.row == 2){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        cell.backgroundColor = [UIColor colorWithHexString:@"ffffff"];

        self.familyNameField.text = self.curUser.familyName;
        [cell addSubview:self.familyNameField];
//        self.firstNameField.text = self.curUser.firstName;
//        [cell addSubview:self.firstNameField];
    }else if (indexPath.row == 3){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell3"];
        cell.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];

        UILabel *labDesc1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width / 2 - 20, 30)];
        labDesc1.text = @"*  性别";
        [cell addSubview:labDesc1];
    }else if (indexPath.row == 4){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell4"];
        cell.backgroundColor = [UIColor colorWithHexString:@"ffffff"];

        if ([self.curUser.gender isEqualToString:@"男"]) {
            self.btnMale.selected = YES;
            self.btnFemale.selected = NO;
        }else{
            self.btnMale.selected = NO;
            self.btnFemale.selected = YES;
        }
        [cell addSubview:self.btnMale];
        [cell addSubview:self.btnFemale];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 120;
            break;
        case 1:
        case 3:
            height = 30;
            break;
        case 2:
        case 4:
            height = 40;
            break;
        default:
            height = 30;
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
