//
//  WEMenuEditViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/2.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEMenuEditViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "TNRadioButtonGroup.h"
#import "WEGlobalData.h"
#import "WEModelGetItem.h"
#import "WEModelCommon.h"
#import "UIImageView+WebCache.h"
#import "UITextView+Placeholder.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "WESingleWebViewController.h"
#import "WKWebBrowserViewController.h"

@interface WEMenuEditViewController ()
{
    UITableView *_tableView;
    
    UITextField *_nameField;
    UITextField *_priceField;
    UITextField *_countField;
    UITextView *_descTextView;
    TNRadioButtonGroup *_group;
    UITextView *_textView;
    UILabel *_countLabel;

    NSString *_name;
    double _price;
    int _count;
    NSString *_desc;
    BOOL _isFeature;
    BOOL _needPreOrder;
    BOOL _isActive;
    NSString *_imgUrl;
    UIImage *_waitUploadImage;
}
@end

@implementation WEMenuEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.view.backgroundColor = UICOLOR(255,255,255);
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveMenu:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *superView = self.view;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    
    [self loadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_itemId.length) {
        self.title = @"编辑菜品";
    } else {
        self.title = @"添加菜品";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)loadData
{
    if (!_itemId.length) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取菜品信息，请稍后...";
    [hud show:YES];
    
    [WENetUtil GetItemWithItemId:_itemId
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             NSDictionary *dict = (NSDictionary *)responseObject;
                             JSONModelError* error = nil;
                             WEModelGetItem *model = [[WEModelGetItem alloc] initWithDictionary:dict error:&error];
                             if (error) {
                                 NSLog(@"error %@", error);
                             }
                             if (!model.IsSuccessful) {
                                 hud.labelText = model.ResponseMessage;
                                 [hud hide:YES afterDelay:1.5];
                                 return;
                             }
                            
                             [hud hide:YES afterDelay:0];
                             _name = model.Item.Name;
                             _price = model.Item.UnitPrice;
                             _count = model.Item.DailyAvailability;
                             _desc = model.Item.Description;
                             _isFeature = model.Item.IsFeatured;
                             _needPreOrder = model.Item.NeedPreorder;
                             _isActive = model.Item.IsActive;
                             _imgUrl = model.Item.PortraitImageUrl;
                             [_tableView reloadData];
                         }
                         failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                             hud.labelText = errorMsg;
                             [hud hide:YES afterDelay:1.5];
                         }];
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

- (BOOL)isValidImageUrl:(NSString *)url
{
    if (url.length) {
        if (![url hasSuffix:@"=0"]) {
            return YES;
        }
    }
    return NO;
}

- (void)saveWaitUploadImage
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    [WENetUtil UploadItemImageWithImage:_waitUploadImage
                                 ItemId:_itemId
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    _waitUploadImage = nil;
                                    NSDictionary *dict = (NSDictionary *)responseObject;
                                    _imgUrl = [dict objectForKey:@"Url"];
                                    if ([self isValidImageUrl:_imgUrl]) {
                                        hud.labelText = @"保存成功";
                                        [_tableView reloadData];
                                        [hud hide:YES afterDelay:1];
                                    } else {
                                        hud.labelText = @"保存失败";
                                        [_tableView reloadData];
                                        [hud hide:YES afterDelay:1];
                                    }
                                    
                                } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                    _waitUploadImage = nil;
                                    hud.labelText = errorMsg;
                                    [_tableView reloadData];
                                    [hud hide:YES afterDelay:1];
                                }];
}

- (void)saveMenu:(UIButton *)button
{
    if (!_name.length) {
        [self showErrorHud:@"请填写菜品名字"];
        return;
    }
    if (!_price) {
        [self showErrorHud:@"请填写菜品价格"];
        return;
    }
    if (!_count) {
        [self showErrorHud:@"请填写菜品数量"];
        return;
    }
    if (!_desc.length) {
        [self showErrorHud:@"请填写菜品描述"];
        return;
    }
    
    WEModelGetMyKitchen *kitchen = [WEGlobalData sharedInstance].cacheMyKitchen;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在保存菜品信息，请稍后...";
    [hud show:YES];
    if (_itemId.length) {
        [WENetUtil UpdateItemWithId:_itemId
                          KitchenId:kitchen.Kitchen.Id
                               Name:_name
                       DisplayOrder:0
                        Description:_desc
                          UnitPrice:[NSString stringWithFormat:@"%.2f", _price]
                  DailyAvailability:_count
                         IsFeatured:_isFeature
                        CanPreorder:_needPreOrder
                       NeedPreorder:_needPreOrder
                           IsActive:_isActive
                           ImageIds:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                NSDictionary *dict = (NSDictionary *)responseObject;
                                JSONModelError* error = nil;
                                WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                if (error) {
                                    NSLog(@"error %@", error);
                                }
                                if (!res.IsSuccessful) {
                                    hud.labelText = res.ResponseMessage;
                                    [hud hide:YES afterDelay:1.5];
                                    return;
                                }
                                if (!_waitUploadImage) {
                                    hud.labelText = @"保存成功";
                                    [hud hide:YES afterDelay:1];
                                } else {
                                    [self saveWaitUploadImage];
                                }
                                
                            }
                            failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                hud.labelText = errorMsg;
                                [hud hide:YES afterDelay:1.5];
                            }];

    } else {
        [WENetUtil AddItemWithName:_name
                      DisplayOrder:0
                       Description:_desc
                         UnitPrice:[NSString stringWithFormat:@"%.2f", _price]
                 DailyAvailability:_count
                        IsFeatured:_isFeature
                       CanPreorder:_needPreOrder
                      NeedPreorder:_needPreOrder
                          IsActive:NO
                          ImageIds:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *dict = (NSDictionary *)responseObject;
                               JSONModelError* error = nil;
                               WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                               if (error) {
                                   NSLog(@"error %@", error);
                               }
                               if (!res.IsSuccessful) {
                                   hud.labelText = res.ResponseMessage;
                                   [hud hide:YES afterDelay:1.5];
                                   return;
                               }
                               _itemId = [[dict objectForKey:@"Item"] objectForKey:@"Id"];
                               if (!_waitUploadImage) {
                                   hud.labelText = @"保存成功";
                                   [hud hide:YES afterDelay:1.0];
                               } else {
                                   [self saveWaitUploadImage];
                               }

                           } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                               hud.labelText = errorMsg;
                               [hud hide:YES afterDelay:1.5];
                           }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    float offsetX = 20;
    float offsetX1 = 32;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    
    NSString *titles[] = {@"*  菜品照片", @"*  菜品名称", @"*  价格", @"*  库存", @"*  类型", @"*  需要提前一天预订", @"*  菜品描述"};
    
    if (indexPath.row == 0) {
        UIView *header = [UIView new];
        header.backgroundColor = UICOLOR(247, 247, 247);
        [superView addSubview:header];
        [header makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = titles[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(header.centerY);
        }];
        
        UILabel *tip = [UILabel new];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = @"最佳尺寸300×300";
        tip.font = [UIFont systemFontOfSize:13];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = UICOLOR(180, 180, 180);
        [superView addSubview:tip];
        [tip sizeToFit];
        [tip makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(10);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(label.centerY);
        }];
        
        UIButton *button = [UIButton new];
        [button setTitle:@"菜品审核要求" forState:UIControlStateNormal];
        [button setTitleColor:UICOLOR(140, 134, 100) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [button addTarget:self action:@selector(itemRequire:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        [button sizeToFit];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-10);
            make.centerY.equalTo(label.centerY);
        }];
        
        UIImageView *imgView = [UIImageView new];
        [superView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX1);
            make.top.equalTo(header.bottom).offset(15);
            make.width.equalTo(imgView.height);
            make.bottom.equalTo(superView.bottom).offset(-15);
        }];
        
        UIButton *addButton = [UIButton new];
        [addButton setBackgroundColor:UICOLOR(247, 247, 247)];
        [addButton setImage:[UIImage imageNamed:@"ic_my_addpic"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:addButton];
        [addButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.left);
            make.top.equalTo(imgView.top);
            make.width.equalTo(imgView.width);
            make.height.equalTo(imgView.height);
        }];
        
        UIButton *removeButton = [UIButton new];
        [removeButton setTitle:@"撤销 >" forState:UIControlStateNormal];
        removeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [removeButton setTitleColor:UICOLOR(180, 180, 180) forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector(delPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:removeButton];
        [removeButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-offsetX);
            make.centerY.equalTo(imgView.centerY);
        }];
        
    
        if ([self isValidImageUrl:_imgUrl]) {
            addButton.hidden = YES;
            NSURL *url = [NSURL URLWithString:_imgUrl];
            [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
            removeButton.hidden = NO;
        } else if (_waitUploadImage){
            addButton.hidden = YES;
            imgView.image = _waitUploadImage;
            removeButton.hidden = NO;
            
        } else {
            imgView.hidden = YES;
            removeButton.hidden = YES;
        }
    
    } else if (indexPath.row == 1) {
        UIView *header = [UIView new];
        header.backgroundColor = UICOLOR(247, 247, 247);
        [superView addSubview:header];
        [header makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = titles[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(header.centerY);
        }];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
        field.backgroundColor = [UIColor clearColor];
        field.delegate = self;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.font = [UIFont systemFontOfSize:13];
        field.textColor = [UIColor blackColor];
        field.keyboardType = UIKeyboardTypeDefault;
        field.clearButtonMode = UITextFieldViewModeNever;
        field.placeholder = @"创建后不可更改";
        [superView addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX1);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(header.bottom);
            make.bottom.equalTo(superView.bottom);
        }];
        _nameField = field;
        _nameField.text = _name;
        
    } else if (indexPath.row == 2) {
        UIView *header = [UIView new];
        header.backgroundColor = UICOLOR(247, 247, 247);
        [superView addSubview:header];
        [header makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = titles[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(header.centerY);
        }];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
        field.backgroundColor = [UIColor clearColor];
        field.delegate = self;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.font = [UIFont systemFontOfSize:13];
        field.textColor = [UIColor blackColor];
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.clearButtonMode = UITextFieldViewModeNever;
        field.placeholder = @"价格";
        [superView addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX1);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(header.bottom);
            make.bottom.equalTo(superView.bottom);
        }];
        _priceField = field;
        _priceField.text = [NSString stringWithFormat:@"%.2f", _price];
        
        UILabel *tip = [UILabel new];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = @"美元/份";
        tip.font = [UIFont systemFontOfSize:13];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = UICOLOR(180, 180, 180);
        [superView addSubview:tip];
        [tip sizeToFit];
        [tip makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.right).offset(-offsetX);
            make.centerY.equalTo(field.centerY);
        }];
    
    } else if (indexPath.row == 3) {
        UIView *header = [UIView new];
        header.backgroundColor = UICOLOR(247, 247, 247);
        [superView addSubview:header];
        [header makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = titles[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(header.centerY);
        }];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
        field.backgroundColor = [UIColor clearColor];
        field.delegate = self;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.font = [UIFont systemFontOfSize:13];
        field.textColor = [UIColor blackColor];
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.clearButtonMode = UITextFieldViewModeNever;
        field.placeholder = @"请输入一天可以提供几份";
        [superView addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX1);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(header.bottom);
            make.bottom.equalTo(superView.bottom);
        }];
        _countField = field;
        _countField.text = [NSString stringWithFormat:@"%d", _count];
        
        UILabel *tip = [UILabel new];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = @"份/天";
        tip.font = [UIFont systemFontOfSize:13];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = UICOLOR(180, 180, 180);
        [superView addSubview:tip];
        [tip sizeToFit];
        [tip makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.right).offset(-offsetX);
            make.centerY.equalTo(field.centerY);
        }];
    
    } else if (indexPath.row == 4) {
        UIView *header = [UIView new];
        header.backgroundColor = UICOLOR(247, 247, 247);
        [superView addSubview:header];
        [header makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = titles[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(header.centerY);
        }];
        
        UIView *holder = [UIView new];
        holder.backgroundColor = [UIColor clearColor];
        [superView addSubview:holder];
        [holder makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(header.bottom);
            make.bottom.equalTo(superView.bottom);
        }];
        
        TNImageRadioButtonData *data1 = [TNImageRadioButtonData new];
        data1.labelFont = [UIFont systemFontOfSize:13];
        data1.labelActiveColor = [UIColor lightGrayColor];
        data1.labelPassiveColor = [UIColor lightGrayColor];
        data1.labelText = @"招牌菜";
        data1.identifier = @"0";
        data1.selected = _isFeature;
        data1.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
        data1.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
        data1.labelOffset = 5;
        
        TNImageRadioButtonData *data2 = [TNImageRadioButtonData new];
        data2.labelFont = [UIFont systemFontOfSize:13];
        data2.labelActiveColor = [UIColor lightGrayColor];
        data2.labelPassiveColor = [UIColor lightGrayColor];
        data2.labelText = @"普通菜";
        data2.identifier = @"1";
        data2.selected = !_isFeature;
        data2.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
        data2.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
        data2.labelOffset = 5;
        
        TNRadioButtonGroup *group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[data1, data2] layout:TNRadioButtonGroupLayoutHorizontal];
        group.marginBetweenItems = 30;
        group.identifier = @"group";
        [group create];
        group.position = CGPointMake(offsetX1, 10);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentCheckGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:group];
        [group update];
        _group = group;
        [holder addSubview:_group];
        
        UILabel *tip = [UILabel new];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = @"最多设置4道招牌菜";
        tip.font = [UIFont systemFontOfSize:13];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = UICOLOR(180, 180, 180);
        [superView addSubview:tip];
        [tip sizeToFit];
        [tip makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.right).offset(-offsetX);
            make.centerY.equalTo(_group.centerY);
        }];
        
    } else if (indexPath.row == 5) {
        UIView *header = [UIView new];
        header.backgroundColor = UICOLOR(247, 247, 247);
        [superView addSubview:header];
        [header makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = titles[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(header.centerY);
        }];
        
        UISwitch *sw = [UISwitch new];
        [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [superView addSubview:sw];
        [sw makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX1);
            make.width.equalTo(80);
            make.top.equalTo(header.bottom).offset(10);
            make.bottom.equalTo(superView.bottom).offset(-1);
        }];
        sw.on = _needPreOrder;
        
    } else if (indexPath.row == 6) {
        UIView *header = [UIView new];
        header.backgroundColor = UICOLOR(247, 247, 247);
        [superView addSubview:header];
        [header makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = titles[indexPath.row];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(0);
            make.centerY.equalTo(header.centerY);
        }];
        
        UILabel *tip = [UILabel new];
        tip.backgroundColor = [UIColor clearColor];
        tip.font = [UIFont systemFontOfSize:13];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = UICOLOR(180, 180, 180);
        [superView addSubview:tip];
        [tip sizeToFit];
        [tip makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.right).offset(-offsetX);
            make.centerY.equalTo(label.centerY);
        }];
        int count = _desc.length;
        tip.text = [NSString stringWithFormat:@"还可输入%d字", 140-count];
        _countLabel = tip;
        
        UITextView *textView = [UITextView new];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = UICOLOR(68,68,68);
        textView.font = [UIFont systemFontOfSize:13];
        textView.delegate = self;
        [superView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.bottom).offset(10);
            make.left.equalTo(superView.left).offset(offsetX1);
            make.right.equalTo(superView.right).offset(-15);
            make.bottom.equalTo(superView.bottom).offset(-15);
            
        }];
        textView.placeholder = @"填写菜品的独特做法、风味、特殊描述等";
        textView.placeholderColor = UICOLOR(170, 170, 170);
        _textView = textView;
        if(_desc.length) {
            _textView.text = _desc;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float heights[] = {140, 60, 60, 60, 65, 80, 200};
    return heights[indexPath.row];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSString *text = textField.text;
    if (textField == _nameField) {
        _name = text;
    } else if (textField == _priceField) {
        _price = text.doubleValue;
    }  else if (textField == _countField) {
        _count = text.integerValue;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _nameField) {
        _name = newText;
    } else if (textField == _priceField) {
        _price = newText.doubleValue;
    }  else if (textField == _countField) {
        _count = newText.integerValue;
    }
    
    return YES;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int newLen = textView.text.length - range.length + text.length;
    if (newLen > 140) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    _desc = textView.text;
    _countLabel.text = [NSString stringWithFormat:@"还可输入%d字", 140-_desc.length];
}

- (void)commentCheckGroupUpdated:(NSNotification *)notification {
    NSString *iden = _group.selectedRadioButton.data.identifier;
    NSLog(@"group updated to %@", _group.selectedRadioButton.data.identifier);
    if ([iden integerValue]) {
        _isFeature = NO;
    } else {
        _isFeature = YES;
    }
}

- (void)switchAction:(UISwitch *)sw
{
    _needPreOrder = sw.isOn;
}

- (void)itemRequire:(id)sender
{
//    WESingleWebViewController *c = [WESingleWebViewController new];
//    c.titleString = @"菜品审核要求";
//    c.urlString = @"https://api.woeatapp.com/WebPage/View/KITCHEN_ITEM_RULE";
//    [self.navigationController pushViewController:c animated:YES];
    
    WKWebBrowserViewController *webBrowser = [[WKWebBrowserViewController alloc]init];
    webBrowser.url = @"https://api.woeatapp.com/WebPage/View/KITCHEN_ITEM_RULE";
    webBrowser.webTitle = @"菜品审核要求";
    [self.navigationController pushViewController:webBrowser animated:YES];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (!_itemId.length) {
        if (isSelectOriginalPhoto) {
            id asset = [assets objectAtIndex:0];
            [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo,NSDictionary *info){
                _waitUploadImage = photo;
            }];
        } else {
            _waitUploadImage = photos[0];
        }
        [_tableView reloadData];
        return;
    }
    
    
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在上传图片，请稍后...";
    [hud show:YES];
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    
    if (isSelectOriginalPhoto) {
        id asset = [assets objectAtIndex:0];
        [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo,NSDictionary *info){
            [WENetUtil UploadItemImageWithImage:photo
                                         ItemId:_itemId
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            NSDictionary *dict = (NSDictionary *)responseObject;
                                            _imgUrl = [dict objectForKey:@"Url"];
                                            if ([self isValidImageUrl:_imgUrl]) {
                                                hud.labelText = @"上传成功";
                                                [_tableView reloadData];
                                                [hud hide:YES afterDelay:1];
                                            } else {
                                                hud.labelText = @"上传失败";
                                                [_tableView reloadData];
                                                [hud hide:YES afterDelay:1];
                                            }
                                            
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                            hud.labelText = errorMsg;
                                            [_tableView reloadData];
                                            [hud hide:YES afterDelay:1];
                                        }];
            
           
        }];
        
        
    } else {
        [WENetUtil UploadItemImageWithImage:photos[0]
                                     ItemId:_itemId
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        _imgUrl = [dict objectForKey:@"Url"];
                                        if ([self isValidImageUrl:_imgUrl]) {
                                            hud.labelText = @"上传成功";
                                            [_tableView reloadData];
                                            [hud hide:YES afterDelay:1];
                                        } else {
                                            hud.labelText = @"上传失败";
                                            [_tableView reloadData];
                                            [hud hide:YES afterDelay:1];
                                        }
                                        
                                        
                                    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                        hud.labelText = errorMsg;
                                        [_tableView reloadData];
                                        [hud hide:YES afterDelay:1];
                                    }];
    }
    
}
    
- (void)addPhotoAction:(UIButton *)button
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.photoWidth = 1080;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)delPhotoAction:(UIButton *)button
{
    if (_waitUploadImage) {
        _waitUploadImage = nil;
        [_tableView reloadData];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在删除图片，请稍后...";
    [hud show:YES];
    
    [WENetUtil RemoveItemImageWithItemId:_itemId
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     NSDictionary *dict = (NSDictionary *)responseObject;
                                     JSONModelError* error = nil;
                                     WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                     if (error) {
                                         NSLog(@"error %@", error);
                                     }
                                     if (!res.IsSuccessful) {
                                         hud.labelText = res.ResponseMessage;
                                         [hud hide:YES afterDelay:1.5];
                                         return;
                                     }
                                     [hud hide:YES afterDelay:0];
                                     _imgUrl = nil;
                                     [_tableView reloadData];
                                 } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                     hud.labelText = errorMsg;
                                     [hud hide:YES afterDelay:1.5];
                                 }];
    
}

@end
