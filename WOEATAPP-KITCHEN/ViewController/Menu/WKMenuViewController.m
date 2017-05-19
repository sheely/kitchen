//
//  WKMenuViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKMenuViewController.h"
#import "WKMenuSettingCell.h"
#import "WKEditMenuController.h"
#import "WKMenuModel.h"
#import "WEMenuEditViewController.h"

@interface WKMenuViewController ()<UITableViewDataSource,UITableViewDelegate,WKMenuSettingCellDelegate>
{
    NSString *_deleteItemId;
}
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WKMenuViewController

- (void)loadView
{
    [super loadView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"菜品管理";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#F7D598" andAlpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addNewMenu:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMenuList];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self.view addSubview:self.menuTableView];
}

-(void)getMenuList{
    
    [_dataArray removeAllObjects];
    
    [[WKNetworkManager sharedAuthManager] GET:@"v1/Item/GetAllMyItemList" responseInMainQueue:YES parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取所有菜品信息 -- %@",responseObject);

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                NSArray *itemList = responseObject[@"ItemList"];
                for (NSDictionary *item in itemList) {
                    WKMenuModel *model = [[WKMenuModel alloc]init];
                    model.Name = item[@"Name"];
                    model.Id = item[@"Id"];
                    model.PortraitImageUrl = item[@"PortraitImageUrl"];
                    model.UnitPrice = [item[@"UnitPrice"] floatValue];
                    model.Description = item[@"Description"];
                    model.IsActive = [item[@"IsActive"] integerValue];
                    model.IsFeatured = [item[@"IsFeatured"] integerValue];
                    model.KitchenId = [item[@"KitchenId"] integerValue];
                    model.DailyAvailability = [item[@"DailyAvailability"] integerValue];
                    model.DisplayOrder = [item[@"DisplayOrder"] integerValue];

                    [_dataArray addObject:model];
                }
                
            }
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.menuTableView reloadData];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取所有菜品错误 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
}



- (UITableView *)menuTableView
{
    if (_menuTableView == nil) {
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY) style:UITableViewStylePlain];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _menuTableView.separatorColor = [UIColor lightGrayColor];
        _menuTableView.tableFooterView = [[UIView alloc] init];
        if ([_menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_menuTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _menuTableView;
}

#pragma mark- tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    WKMenuSettingCell *menuCell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if (menuCell == nil) {
        menuCell = [[WKMenuSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
    menuCell.delegate = self;
    menuCell.model = _dataArray[indexPath.row];
    cell = menuCell;
    
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILongPressGestureRecognizer * longPressGesture =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark- cell delegate
- (void)editMenu:(NSString *)itemId
{
    NSInteger itemid = [itemId integerValue];
    //WKEditMenuController *editMenu = [[WKEditMenuController alloc] init];
    //editMenu.isAddItem = NO;
    //editMenu.itemId = itemid;
    WEMenuEditViewController *editMenu = [WEMenuEditViewController new];
    editMenu.itemId = [NSString stringWithFormat:@"%d", itemId.integerValue];
    [self.navigationController pushViewController:editMenu animated:YES];
}

- (void)editMenuWithModel:(WKMenuModel *)model{
    //WKEditMenuController *editMenu = [[WKEditMenuController alloc] init];
    //editMenu.isAddItem = NO;
    //editMenu.itemId = [model.Id integerValue];
    //editMenu.model = model;
    WEMenuEditViewController *editMenu = [WEMenuEditViewController new];
    editMenu.itemId = [NSString stringWithFormat:@"%d", model.Id.integerValue];
    [self.navigationController pushViewController:editMenu animated:YES];
}


- (void)deleteMenu:(NSString *)itemId
{
    NSInteger itemid = [itemId integerValue];
    NSDictionary *param = @{@"ItemId":@(itemid)};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/Item/DeleteItem" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YRToastView showMessage:@"删除成功" inView:self.view];
            [self getMenuList];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"删除错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
    
}

- (void)activateMenu:(NSString *)itemId{
    NSInteger itemid = [itemId integerValue];
    NSDictionary *param = @{@"ItemId":@(itemid)};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/Item/Activate" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YRToastView showMessage:@"上架成功" inView:self.view];
            [self getMenuList];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上架错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
}

- (void)deActivateMenu:(NSString *)itemId{
    
    NSInteger itemid = [itemId integerValue];
    NSDictionary *param = @{@"ItemId":@(itemid)};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/Item/Deactivate" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YRToastView showMessage:@"下架成功" inView:self.view];
            [self getMenuList];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"下架菜品错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
}


- (void)addNewMenu:(id)sender
{
    //WKEditMenuController *editMenu = [[WKEditMenuController alloc] init];
    //editMenu.isAddItem = YES;
    WEMenuEditViewController *editMenu = [WEMenuEditViewController new];
    [self.navigationController pushViewController:editMenu animated:YES];
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:_menuTableView];
        NSIndexPath * indexPath = [_menuTableView indexPathForRowAtPoint:location];
        UITableViewCell *cell = recognizer.view;
        if (indexPath) {
            WKMenuModel *model = _dataArray[indexPath.row];
            _deleteItemId = model.Id;
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"删除菜品"
                                          otherButtonTitles:nil];
            [actionSheet showInView:self.view];
            
        }
    }
}

-(void) actionSheet :(UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if ( buttonIndex == [actionSheet destructiveButtonIndex]) {
        if (_deleteItemId) {
            [self deleteMenu:_deleteItemId];
        }
    }
    _deleteItemId = nil;
    
}
@end
