//
//  WEKitchenPictureViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/1.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEKitchenPictureViewController.h"
#import "WEUtil.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"
#import "UIImageView+WebCache.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "WENetUtil.h"
#import "WEModelCommon.h"


#define BUTTON_TAG_START 100

#define OFFSET_X  30

@interface WEKitchenPictureViewController ()
{
    UITableView *_tableView;
    UIView *_waitView;
    NSMutableArray *_localImages;
    NSMutableArray *_localImageIds;
    UIBarButtonItem *_rightItem;
}
@end

@implementation WEKitchenPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _localImages = [NSMutableArray new];
    _localImageIds = [NSMutableArray new];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    _rightItem = rightItem;
    
    self.title = @"厨房图片";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UIImage *img = [UIImage imageNamed:@"icon_tip"];
    UIImageView *imgView = [UIImageView new];
    imgView.image = img;
    [superView addSubview:imgView];
    float scale = 0.5;
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(15);
        make.left.equalTo(superView.left).offset(OFFSET_X);
        make.width.equalTo(img.size.width*scale);
        make.height.equalTo(img.size.height*scale);
    }];
    
    UILabel *tip = [UILabel new];
    tip.textColor = [UIColor blackColor];
    tip.font = [UIFont boldSystemFontOfSize:14];
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    [superView addSubview:tip];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.top).offset(-5);
        make.left.equalTo(imgView.right).offset(10);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(tip.font.lineHeight*3+2);
    }];
    tip.text = @"厨房图片用于饭友端APP，在您的厨房顶部滚动显示，您最多可以选择4张厨房图片。\n厨房图片的建议尺寸为1080 * 300像素";
    
    UIImage *img1 = [UIImage imageNamed:@"icon_warning"];
    UIImageView *imgView1 = [UIImageView new];
    imgView1.image = img1;
    [superView addSubview:imgView1];
    float scale1 = 0.5;
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip.bottom).offset(15);
        make.left.equalTo(superView.left).offset(OFFSET_X);
        make.width.equalTo(img.size.width*scale1);
        make.height.equalTo(img.size.height*scale1);
    }];
    
    UILabel *tip1 = [UILabel new];
    tip1.textColor = [UIColor blackColor];
    tip1.font = [UIFont boldSystemFontOfSize:14];
    tip1.backgroundColor = [UIColor clearColor];
    tip1.numberOfLines = 0;
    [superView addSubview:tip1];
    [tip1 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imgView1.bottom).offset(2);
        make.left.equalTo(imgView1.right).offset(10);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(tip1.font.lineHeight*2+1);
    }];
    tip1.text = @"厨房图片提交后不可再编辑。如果要变更厨房图片，请联系WOEAT客服";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip1.bottom).offset(20);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _tableView = tableView;
    
    UIView *wait = [UIView new];
    wait.backgroundColor = UICOLOR(255,255,255);
    [superView addSubview:wait];
    [wait makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(superView.bottom);
    }];
    _waitView = wait;
    superView = wait;
    
    UIImageView *logo = [UIImageView new];
    UIImage *img2 = [UIImage imageNamed:@"wait_approved"];
    logo.image = img2;
    [superView addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX).offset(0);
        make.top.equalTo(self.mas_topLayoutGuide).offset([WEUtil getScreenHeight]*0.15);
        make.width.equalTo(img2.size.width);
        make.height.equalTo(img2.size.height);
    }];
    
    UILabel *title = [UILabel new];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = UICOLOR(200, 200, 200);
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    [superView addSubview:title];
    [title sizeToFit];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(logo.bottom).offset([WEUtil getScreenHeight]*0.08);
    }];
    title.text = @"您的图片已经提交，我们正在审核";
    
#if 0
    //test
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    for(int i=0; i<model.Images.count; i++) {
        WEModelGetMyKitchenImages *img = [model.Images objectAtIndex:i];
         [WENetUtil RemoveKitchenImageWithKitchenId:model.Kitchen.Id
                                            ImageId:img.Image.Id
                                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                                
                                            } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                
                                            }];
        
    }
    
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    if (model.Kitchen.KitchenImagesReviewed && !model.Images.count) {
        _waitView.hidden = NO;
    } else {
        _waitView.hidden = YES;
    }
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

- (void)save:(UIButton *)button
{
    if (!_localImageIds.count) {
        [self showErrorHud:@"请先添加图片"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在提交图片，请稍后...";
    [hud show:YES];
    
    [WENetUtil LinkKitchenImagesWithImageIdList:_localImageIds
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            hud.labelText = @"提交成功";
                                            hud.delegate = self;
                                            [hud hide:YES afterDelay:1.5];
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                            hud.labelText = errorMsg;
                                            [hud hide:YES afterDelay:1.5];
                                        }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    if (model.Images.count) {
        self.navigationItem.rightBarButtonItem= nil;
        self.navigationController.navigationItem.rightBarButtonItem = nil;

        
        return model.Images.count;
    } else {
        self.navigationItem.rightBarButtonItem= _rightItem;
        self.navigationController.navigationItem.rightBarButtonItem = _rightItem;
        
        return _localImages.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    
    UIImageView *imgView = [UIImageView new];
    [superView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom).offset(-20);
    }];
    
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    if (model.Images.count > indexPath.row) {
        WEModelGetMyKitchenImages *img = [model.Images objectAtIndex:indexPath.row];
        NSString *url = img.Image.Url;
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    } else {
        imgView.image = _localImages[indexPath.row];
        UIButton *button = [UIButton new];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_delete_circle"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(delButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = BUTTON_TAG_START;
        [superView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.top).offset(5);
            make.right.equalTo(imgView.right).offset(-5);
            make.width.equalTo(25);
            make.height.equalTo(25);
        }];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WEUtil getScreenWidth] * 300 / 1080.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    if (model.Images.count) {
        return 0;
    }
    if (_localImages.count == 4) {
        return 0;
    }
    return 45;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [UIButton new];
    button.backgroundColor = UICOLOR(248, 212, 152);
    [button setTitle:@"+ 添加新图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(addTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addTapped:(UIButton *)button
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4-_localImages.count delegate:self];
    imagePickerVc.photoWidth = 1080;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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
            
        } else {
            [WEGlobalData sharedInstance].cacheMyKitchen = model;
        }
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"错误信息 -> %@",errorMsg);
        [_tableView reloadData];
    }];
    
}

- (void)updateUI
{
    [_tableView reloadData];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在保存图片，请稍后...";
    [hud show:YES];
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    
    __block int successCount = 0;
    __block int failCount = 0;
    if (isSelectOriginalPhoto) {
        for (int i = 0 ; i <assets.count; i++) {
            id asset = [assets objectAtIndex:i];
            [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo,NSDictionary *info){
                [WENetUtil UploadWithImage:photo
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSDictionary *dict = (NSDictionary *)responseObject;
                                       int imgId = [[dict objectForKey:@"Id"] intValue];
                                       if (!imgId) {
                                           failCount++;
                                       } else {
                                           successCount++;
                                           hud.labelText = [NSString stringWithFormat:@"正在上传图片%d/%d，请稍后...",
                                                            successCount, assets.count];
                                           [_localImageIds addObject:@(imgId)];
                                           [_localImages addObject:photo];
                                       }
                                       if (successCount + failCount == assets.count) {
                                            [hud hide:YES];
                                            [self updateUI];
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                       failCount++;
                                       if (successCount + failCount == assets.count) {
                                           [hud hide:YES];
                                           [self updateUI];
                                       }
                                   }];
                
                
            }];
        }

    } else {
        for (int i = 0 ; i <photos.count; i++) {
            [WENetUtil UploadWithImage:photos[i]
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSDictionary *dict = (NSDictionary *)responseObject;
                                   int imgId = [[dict objectForKey:@"Id"] intValue];
                                   if (!imgId) {
                                       failCount++;
                                   } else {
                                       successCount++;
                                       hud.labelText = [NSString stringWithFormat:@"正在上传图片%d/%d，请稍后...",
                                                        successCount, photos.count];
                                       [_localImageIds addObject:@(imgId)];
                                       [_localImages addObject:photos[i]];
                                   }
                                   if (successCount + failCount == assets.count) {
                                       [hud hide:YES];
                                       [self updateUI];
                                   }
                               } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                   failCount++;
                                   if (successCount + failCount == assets.count) {
                                       [hud hide:YES];
                                       [self updateUI];
                                   }
                               }];
            
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)delButtonTapped:(UIButton *)button
{
    int index = button.tag - BUTTON_TAG_START;
    [_localImages removeObjectAtIndex:index];
    [_localImageIds removeObjectAtIndex:index];
    [_tableView reloadData];
}

@end
