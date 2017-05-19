//
//  WKEditMenuController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2015/10/27.
//  Copyright © 2015年 com.woeat-inc. All rights reserved.
//

#import "WKEditMenuController.h"
#import "WKMenuCoverCell.h"
#import "AddPhotoDelegate.h"
#import "SDPhotoBrowser.h"
#import "TZImagePickerController.h"
#import "WKMenuModel.h"

@interface WKEditMenuController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AddPhotoDelegate,SDPhotoBrowserDelegate,TZImagePickerControllerDelegate,UITextViewDelegate>{
    SDPhotoBrowser *browser;
    NSString *imageId;
    UILabel *countLabel;
}


@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UITextField *menuNameField;
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UITextField *availabilityField;

@property (nonatomic, strong) UIButton *btnDeleteMenu;
@property (nonatomic, strong) NSMutableArray *pics;
@property (nonatomic, strong) UITextView *storyField;

@property (nonatomic, strong) UIButton *btnSelfTake;
@property (nonatomic, strong) UIButton *btnKitchenSend;
@property (nonatomic, strong) UISwitch *reserveSwitch;
@end

@implementation WKEditMenuController

- (void)loadView
{
    [super loadView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.menuTableView];
    _pics = [NSMutableArray new];

    if (_isAddItem) {
        self.title = @"添加菜品";
    }else{
        self.title = @"编辑菜品";
        //[self.view addSubview:self.btnDeleteMenu];
        [_pics addObject:_model.PortraitImageUrl];
    }
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveMenu:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)menuTableView
{
    if (_menuTableView == nil) {
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY - 40) style:UITableViewStylePlain];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.separatorColor = [UIColor lightGrayColor];
        _menuTableView.tableFooterView = [[UIView alloc] init];
        if ([_menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_menuTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _menuTableView;
}

- (UITextField *)menuNameField
{
    if (_menuNameField == nil) {
        _menuNameField = [[UITextField alloc] initWithFrame:CGRectMake(36, 30, screen_width - 40, 40)];
        _menuNameField.placeholder = @"创建后不可修改";
        _menuNameField.delegate = self;
        if (!_isAddItem) {
            _menuNameField.text = _model.Name;
            _menuNameField.enabled = NO;
        }
    }
    return _menuNameField;
}

- (UITextField *)availabilityField
{
    if (_availabilityField == nil) {
        _availabilityField = [[UITextField alloc] initWithFrame:CGRectMake(36, 30, screen_width - 40, 40)];
        _availabilityField.placeholder = @"请输入一天可以提供几份";
        _availabilityField.delegate = self;
        if (!_isAddItem) {
            _availabilityField.text = [NSString stringWithFormat:@"%ld",(long)_model.DailyAvailability];
        }
    }
    return _availabilityField;
}

- (UISwitch *)reserveSwitch
{
    if (_reserveSwitch == nil) {
        _reserveSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(36, 30, screen_width - 40, 40)];
        _reserveSwitch.backgroundColor = [UIColor clearColor];
        [_reserveSwitch addTarget:self action:@selector(reserveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reserveSwitch;
}

- (UITextField *)priceField
{
    if (_priceField == nil) {
        _priceField = [[UITextField alloc] initWithFrame:CGRectMake(36, 30, screen_width - 40, 40)];
        _priceField.placeholder = @"创建后不可修改";
        _priceField.delegate = self;
        if (!_isAddItem) {
            _priceField.text = [NSString stringWithFormat:@"%.2f",_model.UnitPrice];
        }
    }
    return _priceField;
}

- (UITextView *)storyField
{
    if (_storyField == nil) {
        _storyField = [[UITextView alloc] initWithFrame:CGRectMake(32, 30, screen_width - 40, 180)];
    }
    if (!_isAddItem) {
        _storyField.text = _model.Description;
    }
    _storyField.font = [UIFont systemFontOfSize:15];
    _storyField.delegate =self;
    return _storyField;
}


- (UIButton *)btnDeleteMenu
{
    if (_btnDeleteMenu == nil) {
        _btnDeleteMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, screen_height - 40, screen_width, 40)];
        [_btnDeleteMenu setTitle:@"删除菜品" forState:UIControlStateNormal];
        [_btnDeleteMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDeleteMenu setBackgroundColor:CommonGoldColor];
        [_btnDeleteMenu addTarget:self action:@selector(deleteCurrentMenu:)forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDeleteMenu;
}

-(void)reserveAction:(UISwitch *)sender{
    
}

- (UIView *)creatViewWithTitle:(NSString *)title
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7" andAlpha:1.0];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width - 40, 30)];
    labTitle.text = title;
    labTitle.textColor = [UIColor blackColor];
    [backView addSubview:labTitle];
    return backView;
}

- (UIView *)creatFirstLineViewWithTitle:(NSString *)title
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7" andAlpha:1.0];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width - 40, 30)];
    labTitle.text = title;
    labTitle.textColor = [UIColor blackColor];
    [backView addSubview:labTitle];
    return backView;
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
        WKMenuCoverCell *menuCoverCell = [[WKMenuCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCoverCell"];
        menuCoverCell.delegate = self;
        [menuCoverCell loadImages:self.pics];
        cell = menuCoverCell;
    }else if (indexPath.row == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  菜品名称"]];
        [cell addSubview:self.menuNameField];
    
    }else if (indexPath.row == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  价格"]];
        [cell addSubview:self.priceField];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 80, 30, 60, 40)];
        label.text = @"美元/份";
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:15];


    }else if (indexPath.row == 3) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  库存"]];
        [cell addSubview:self.availabilityField];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 80, 30, 60, 40)];
        label.text = @"份/天";
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:15];


    }else if (indexPath.row == 4) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  类型"]];
        [cell addSubview:self.btnSelfTake];
        [cell addSubview:self.btnKitchenSend];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 170, 30, 150, 40)];
        label.text = @"最多设置4道招牌菜";
//        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:15];


        [cell addSubview:label];
    }else if (indexPath.row == 5) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  需要提前一天预订"]];
        [cell addSubview:self.reserveSwitch];
    }else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
        [cell addSubview:[self creatViewWithTitle:@"*  菜品描述"]];
        [cell addSubview:self.storyField];
        countLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 170, -5, 150, 40)];
        
        NSInteger count = 140 - _storyField.text.length;
        countLabel.text = [NSString stringWithFormat:@"还可以输入%ld字",(long)count];
        countLabel.font = [UIFont systemFontOfSize:15];
        countLabel.textColor = [UIColor lightGrayColor];
        //        label.backgroundColor = [UIColor redColor];
        countLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:countLabel];
        
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
        case 6:
            height = 200;
            break;

        default:
            height = 70;
            break;
    }
    return height;
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

- (void)saveMenu:(id)sender
{
    __weak typeof (self) weakSelf = self;
    NSDictionary *param = nil;
    NSString *urlPath = @"";
    NSString *successDesc = @"";

    if (_isAddItem) {
        param = @{@"Name":_menuNameField.text?_menuNameField.text:@"",
                  @"UnitPrice":_priceField.text?_priceField.text:@"",
                  @"DailyAvailability":_availabilityField.text?_availabilityField.text:@"",
                  @"Description":_storyField.text?_storyField.text:@"",
                  @"IsFeatured":@(_model.IsFeatured),
                  @"CanPreorder":@0,
                  @"NeedPreorder":@0,
                  @"DisplayOrder":@0,
                  @"IsActive":@(_model.IsActive),
                  @"ImageIds":imageId?imageId:@""
                  };
        urlPath = @"v1/Item/AddItem";
        successDesc = @"添加成功";
        
    }else{
//        NSInteger kitchenId = [[WKKeyChain load:[NSString stringWithFormat:@"%@_KitchenId",kAPPSecurityStoreKey]] integerValue];
        param = @{@"Id":@(_itemId),
                  @"KitchenId":@(_model.KitchenId),
                  @"Name":_menuNameField.text?_menuNameField.text:@"",
                  @"UnitPrice":_priceField.text?_priceField.text:@"",
                  @"DailyAvailability":_availabilityField.text?_availabilityField.text:@"",
                  @"Description":_storyField.text?_storyField.text:@"",
                  @"IsFeatured":@(_model.IsFeatured),
                  @"CanPreorder":@0,
                  @"NeedPreorder":@0,
                  @"DisplayOrder":@0,
                  @"IsActive":@(_model.IsActive),
                  @"ImageIds":@[]

                  };
        urlPath = @"v1/Item/UpdateItem";
        successDesc = @"编辑成功";

    }
    [[WKNetworkManager sharedAuthManager] POST:urlPath responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
//                [YRToastView showMessage:successDesc inView:self.view];
                [YRToastView showMessage:@"操作成功" inView:self.view];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [YRToastView showMessage:@"操作失败" inView:self.view];
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"添加编辑菜品错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
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
                    NSLog(@"add时图片上传成功");
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];
}


- (void)deleteCurrentMenu:(id)sender
{
    __weak typeof (self) weakSelf = self;
    NSDictionary *param = @{@"ItemId":@(_itemId)};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/Item/DeleteItem" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YRToastView showMessage:@"删除成功" inView:self.view];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"下架错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];

}

- (UIButton *)btnSelfTake
{
    if (_btnSelfTake == nil) {
        _btnSelfTake = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 120, 40)];
        _btnSelfTake.tag = 1000;
        [_btnSelfTake setTitle:@"招牌菜" forState:UIControlStateNormal];
        _btnSelfTake.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnSelfTake.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        [_btnSelfTake setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnSelfTake setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnSelfTake setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnSelfTake setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_btnSelfTake addTarget:self action:@selector(sendStyleChanged:) forControlEvents:UIControlEventTouchUpInside];
        if (!_isAddItem) {
            if (_model.IsFeatured) {
                self.btnSelfTake.selected = YES;
            }
        }
    
    }
    return _btnSelfTake;
}

- (UIButton *)btnKitchenSend
{
    if (_btnKitchenSend == nil) {
        _btnKitchenSend = [[UIButton alloc] initWithFrame:CGRectMake(120, 30, 100, 40)];
        _btnKitchenSend.tag = 1001;
        [_btnKitchenSend setTitle:@"普通菜" forState:UIControlStateNormal];
        _btnKitchenSend.titleLabel.font = [UIFont systemFontOfSize:15];

        _btnKitchenSend.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        [_btnKitchenSend setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [_btnKitchenSend setImage:[UIImage imageNamed:@"check-sign"] forState:UIControlStateSelected];
        [_btnKitchenSend setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnKitchenSend setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_btnKitchenSend addTarget:self action:@selector(sendStyleChanged:) forControlEvents:UIControlEventTouchUpInside];
        if (!_isAddItem) {
            if (!_model.IsFeatured) {
                _btnKitchenSend.selected = YES;
            }
        }
    }
    return _btnKitchenSend;
}
- (void)sendStyleChanged:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    if (tag == 1000) {
        self.btnSelfTake.selected = YES;
        self.btnKitchenSend.selected = NO;
    }else{
        self.btnSelfTake.selected = NO;
        self.btnKitchenSend.selected = YES;
    }
}



#pragma mark- Add Pic Delegate Methods
- (void)didMenuAddButtonClick:(WKMenuCoverCell*)tableViewCell{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    NSInteger KitchenId = [[WKKeyChain load:[NSString stringWithFormat:@"%@_KitchenId",kAPPSecurityStoreKey]] integerValue];
    [YRToastView show:@"" inView:self.view type:YRToastTypeLoading];
    for (int i = 0 ; i <photos.count; i++) {
        //上传图片
        //  UIImage *image = [UIImage imageNamed:@""];
        //  NSData *data = UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
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
        NSDictionary *param = nil;
        NSString *url = @"";
        if (_isAddItem) {
            url = @"https://api.woeatapp.com/v1/Image/Upload";
            param = @{@"ImageFile":fileName};
        }else{
            url = @"https://api.woeatapp.com/v1/Item/UploadItemImage";
            param = @{@"ImageFile":fileName,@"ItemId":@(_itemId)};
        }
        
        [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
                        [weakSelf.menuTableView reloadData];
                    }
                });
            }else if([responseObject isKindOfClass:[NSDictionary class]]){
                //                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *result = responseObject;
                if ([result objectForKey:@"Url"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"发送成功");
                        if (i == photos.count -1) {
                            NSString *imgUrl = result[@"Url"];
                            [weakSelf.pics addObject:imgUrl];
                            [YRToastView showMessage:@"上传成功" inView:self.view];
                            [weakSelf.menuTableView reloadData];
                            if (_isAddItem) {
//                                [weakSelf updateAvatarImage:responseObject[@"Id"]];
                                imageId = responseObject[@"Id"];
                            }
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger surplus = 140 - [textView.text length] - range.length;
    if (surplus < 0 && range.length == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger surplus = 140 - [textView.text length];
    if (surplus < 0)
    {
        textView.text = [textView.text substringToIndex:140];
    }
    countLabel.text = [NSString stringWithFormat:@"还可以输入%ld字",surplus <= 0 ? 0 : surplus];
}




@end
