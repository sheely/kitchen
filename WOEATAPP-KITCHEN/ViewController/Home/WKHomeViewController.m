//
//  WKHomeViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/19.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKHomeViewController.h"
#import "WKHeaderViewCell.h"
#import "WKMenuViewCell.h"
#import "WKOrderManagerViewController.h"
#import "WKIncomeViewController.h"
#import "WKKitchenViewController.h"
#import "WKMenuViewController.h"
#import "WKClientEvaluateController.h"
#import "WKHelpViewController.h"
#import "WKWebBrowserViewController.h"
#import "WKBusinessTimeManager.h"
#import "WKKitchenSale.h"
#import "WEModelGetMyKitchenSales.h"
#import "WENetUtil.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"
#import "WEKitchenSettingViewController.h"
#import "WEMainOrderViewController.h"
#import "WEIncomeViewController.h"
#import "MainUserCommentViewController.h"

@interface WKHomeViewController ()<UITableViewDataSource,UITableViewDelegate,WKHeaderViewCellDelegate>
{
    WEModelGetMyKitchenSales *_modelGetMyKitchenSales;
    NSTimer *_refreshTimer;
}
@property (nonatomic, strong) UITableView *homeTableView;
//@property (nonatomic, strong) UISwitch *btnShopSwitch;
@property (nonatomic, strong) UIButton *shopSwitchBtn;

@property (nonatomic, strong) UILabel *labTodayTurnover;
@property (nonatomic, strong) UILabel *labTotalMoney;
//@property (nonatomic, assign) CGFloat todayTurnOver;
//@property (nonatomic, assign) CGFloat totalMoney;
//@property (nonatomic, strong) WKKitchenSale *kicthenSale;

@end

@implementation WKHomeViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#3F3F40" andAlpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.homeTableView];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#3D3938" andAlpha:1.0];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEModelGetMyKitchen *kitchen = [WEGlobalData sharedInstance].cacheMyKitchen;
    if (kitchen.Kitchen.IsOpen) {
        self.shopSwitchBtn.selected = NO;
    } else {
        self.shopSwitchBtn.selected = YES;
    }
    
//    self.kicthenSale = [[WKKitchenSale alloc] init];
//    NSString *mobile = [WKKeyChain load:kMobilNumberKey];
//    if (!mobile || mobile.length == 0) {
//        return;
//    }
//    WS(ws);
//    NSDictionary *param = @{@"MobileNumber":mobile};
//    [[WKNetworkManager sharedAuthManager] GET:@"v1/Kitchen/GetMyKitchenSales" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                ws.kicthenSale.todayCookCount = [responseObject[@"CountOfItemsToCookToday"] integerValue];
//                ws.kicthenSale.todayOrderCount = [responseObject[@"CountOfOrderToday"] integerValue];
//                ws.kicthenSale.tomorrowOrderCount = [responseObject[@"CountOfOrderTomorrow"] integerValue];
//                ws.kicthenSale.totalMoney = [responseObject[@"TotalBalance"] integerValue];
//                ws.kicthenSale.todaySales = [responseObject[@"TotalSalesToday"] integerValue];
//                [ws.homeTableView reloadData];
//            }
//        });
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"错误信息 -> %@",error);
//        [YRToastView hide];
//        
//    }];
//    
//    __weak typeof (self) weakSelf = self;
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [weakSelf GetListForKitchen];
//    });
}

//-(void)GetListForKitchen{
//    [[WKNetworkManager sharedAuthManager] GET:@"v1/IntroSlider/GetListForKitchen" responseInMainQueue:YES parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"启动页responseObject %@",responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"获取启动页错误信息 -> %@",error);
//        
//    }];
//}

- (void)updateUI
{
    [_homeTableView reloadData];
}

- (void)loadKitchenSales
{
    [WENetUtil GetMyKitchenSalesWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyKitchenSales *model = [[WEModelGetMyKitchenSales alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _modelGetMyKitchenSales = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //[[WKBusinessTimeManager sharedManager] fetchBussinessTime];
    [self startRefresh];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self stopRefresh];
}

- (void)startRefresh
{
    if (!_refreshTimer) {
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                  target:self
                                                selector:@selector(timerFire:)
                                                userInfo:nil
                                                 repeats:YES];
        [_refreshTimer fire];
        
    }
}

- (void)stopRefresh
{
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}

-(void)timerFire:(id)userinfo {
    [self loadKitchenSales];
}


#pragma mark- init
- (UITableView *)homeTableView
{
    if (_homeTableView == nil) {
        CGFloat originY = 20;
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY) style:UITableViewStylePlain];
        _homeTableView.dataSource = self;
        _homeTableView.delegate = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.separatorColor = [UIColor lightGrayColor];
        _homeTableView.tableFooterView = [[UIView alloc] init];
        _homeTableView.scrollEnabled = NO;
        if ([_homeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_homeTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _homeTableView.backgroundColor = [UIColor colorWithHexString:@"#3F3F40" andAlpha:1.0];
    }
    return _homeTableView;
}

- (UIButton *)shopSwitchBtn
{
    if (_shopSwitchBtn == nil) {
        UIImage *imgOpen = [UIImage imageNamed:@"KitchenOpen"];
        UIImage *imgClose = [UIImage imageNamed:@"KitchenClosed"];
        float scale = 1;
        CGSize size = CGSizeMake(scale*imgOpen.size.width, scale*imgOpen.size.height);
        _shopSwitchBtn = [[UIButton alloc] initWithFrame:CGRectMake((screen_width - size.width) / 2, 10, size.width, size.height)];
        [_shopSwitchBtn setImage:imgOpen forState:UIControlStateNormal];
        [_shopSwitchBtn setImage:imgClose forState:UIControlStateSelected];
        _shopSwitchBtn.backgroundColor = [UIColor clearColor];
        [_shopSwitchBtn addTarget:self action:@selector(turnOnOff:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopSwitchBtn;
}

//- (UISwitch *)btnShopSwitch
//{
//    if (_btnShopSwitch == nil) {
//        _btnShopSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((screen_width - 60) / 2, 10, 60, 26)];
//        _btnShopSwitch.backgroundColor = [UIColor clearColor];
//        [_btnShopSwitch addTarget:self action:@selector(turnOnOffShop:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btnShopSwitch;
//}

- (UILabel *)labTodayTurnover
{
    if (_labTodayTurnover == nil) {
        _labTodayTurnover = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screen_width / 2.0, 60)];
        _labTodayTurnover.textAlignment = NSTextAlignmentCenter;
        _labTodayTurnover.textColor = [UIColor colorWithHexString:@"#BA0345" andAlpha:1.0];
        _labTodayTurnover.font = [UIFont systemFontOfSize:15];
        _labTodayTurnover.numberOfLines = 0;
    }
    return _labTodayTurnover;
}

- (UILabel *)labTotalMoney
{
    if (_labTotalMoney == nil) {
        _labTotalMoney = [[UILabel alloc] initWithFrame:CGRectMake(screen_width / 2.0, 10, screen_width / 2.0, 60)];
        _labTotalMoney.textAlignment = NSTextAlignmentCenter;
        _labTotalMoney.textColor = [UIColor colorWithHexString:@"#BA0345" andAlpha:1.0];
        _labTotalMoney.font = [UIFont systemFontOfSize:15];
        _labTotalMoney.numberOfLines = 0;
    }
    return _labTotalMoney;
}
#pragma mark- tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopSwitchCell"];
        [cell.contentView addSubview:self.shopSwitchBtn];
        cell.backgroundColor = [UIColor colorWithHexString:@"#3F3F40" andAlpha:1.0];
        
    }else if (indexPath.row == 1){
        WKHeaderViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        if (headerCell == nil) {
            headerCell = [[WKHeaderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeaderCell"];
        }
        headerCell.delegate = self;
        //headerCell.labCookNum.text = [NSString stringWithFormat:@"%ld",(long)self.kicthenSale.todayCookCount];
        //headerCell.labTodayOrderNum.text = [NSString stringWithFormat:@"%ld",(long)self.kicthenSale.todayOrderCount];
        //headerCell.labTomorrowOrderNum.text = [NSString stringWithFormat:@"%ld",(long)self.kicthenSale.tomorrowOrderCount];
        headerCell.labCookNum.text = [NSString stringWithFormat:@"%ld",(long)_modelGetMyKitchenSales.CountOfItemsToCookToday];
        headerCell.labTodayOrderNum.text = [NSString stringWithFormat:@"%ld",(long)_modelGetMyKitchenSales.CountOfOrderToday];
        headerCell.labTomorrowOrderNum.text = [NSString stringWithFormat:@"%ld",(long)_modelGetMyKitchenSales.CountOfOrderTomorrow];
        cell = headerCell;
    }else if (indexPath.row == 2){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TodayCell"];
        UIColor *color = [UIColor colorWithHexString:@"#333333" andAlpha:1.0];
        //NSString *str = [NSString stringWithFormat:@"$%ld",(long)self.kicthenSale.totalMoney];
        NSString *str = [NSString stringWithFormat:@"$%.2f",_modelGetMyKitchenSales.TotalSalesToday];
        NSString *string = [NSString stringWithFormat:@"今日营业额\n%@",str];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributeString addAttribute:NSForegroundColorAttributeName value:color range:[string rangeOfString:@"今日营业额"]];
        [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[string rangeOfString:@"今日营业额"]];
        self.labTotalMoney.attributedText = attributeString;

        //str = [NSString stringWithFormat:@"$%ld",(long)self.kicthenSale.todaySales];
        str = [NSString stringWithFormat:@"$%.2f",_modelGetMyKitchenSales.TotalBalance];
        string = [NSString stringWithFormat:@"钱箱总额\n%@",str];
        attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributeString addAttribute:NSForegroundColorAttributeName value:color range:[string rangeOfString:@"钱箱总额"]];
        [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[string rangeOfString:@"钱箱总额"]];
        self.labTodayTurnover.attributedText = attributeString;

        [cell.contentView addSubview:self.labTotalMoney];
        [cell.contentView addSubview:self.labTodayTurnover];
        cell.backgroundColor = [UIColor colorWithHexString:@"#DBD7CE" andAlpha:1.0];
    }else{
        WKMenuViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        if (menuCell == nil) {
            menuCell = [[WKMenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
        }
        NSString *leftMenuName = @"";
        NSString *rightMenuName = @"";
        NSString *leftMenuIconName = @"";
        NSString *rightMenuIconName = @"";
        NSInteger leftViewTag;
        NSInteger rightViewTag;
        if (indexPath.row == 3) {
            leftMenuName = @"订单管理";
            rightMenuName = @"我的收入";
            leftMenuIconName = @"icon_order";
            rightMenuIconName = @"icon_income";
            leftViewTag = 1000 + 1;
            rightViewTag = 1000 + 2;
        }else if(indexPath.row == 4){
            leftMenuName = @"厨房设置";
            rightMenuName = @"菜品设置";
            leftMenuIconName = @"icon_kitchen";
            rightMenuIconName = @"icon_dish";
            leftViewTag = 1000 + 3;
            rightViewTag = 1000 + 4;
        }else{
            leftMenuName = @"饭友评价";
            rightMenuName = @"帮助中心";
            leftMenuIconName = @"icon_comment";
            rightMenuIconName = @"icon_menu";
            leftViewTag = 1000 + 5;
            rightViewTag = 1000 + 6;
        }
        menuCell.labLeftMenu.text = leftMenuName;
        menuCell.labRightMenu.text = rightMenuName;
        menuCell.imgLeftMenu.image = [UIImage imageNamed:leftMenuIconName];
        menuCell.imgRightMenu.image = [UIImage imageNamed:rightMenuIconName];
        menuCell.imgLeftMenu.tag = leftViewTag;
        menuCell.imgRightMenu.tag = rightViewTag;
        menuCell.imgLeftMenu.userInteractionEnabled = YES;
        menuCell.imgRightMenu.userInteractionEnabled = YES;
        [menuCell.imgLeftMenu addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFunction:)]];
        [menuCell.imgRightMenu addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFunction:)]];
        cell = menuCell;
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
            height = 46;
            break;
        case 1:
            height = (screen_width - 30 * 4) / 3 + 50;
            break;
        case 2:
            height = 80;
            break;
        default:
            height = CellMenuHeight;
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - switch 开店/关店

-(void)turnOnOff:(UIButton *)sender{
    __block NSString *status =  nil;
    
    [WENetUtil SwitchOnOffWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyKitchen *model = [[WEModelGetMyKitchen alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        if (model.Kitchen.IsOpen) {
            self.shopSwitchBtn.selected = NO;
            status = @"开店成功";
        } else {
            self.shopSwitchBtn.selected = YES;
            status = @"关店成功";
        }
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.yOffset = -30;
        [self.view addSubview:hud];
        hud.labelText = status;
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.yOffset = -30;
        [self.view addSubview:hud];
        hud.labelText = errorMsg;
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
    }];
    
//    typeof(self) weakSelf = self;
//    [[WKNetworkManager sharedAuthManager] POST:@"v1/Kitchen/SwitchOnOff" responseInMainQueue:YES parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [YRToastView showMessage:status inView:weakSelf.view];
//        });
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"错误信息 -> %@",error);
//        [YRToastView showMessage:@"厨房状态切换失败" inView:weakSelf.view];
//        
//        
//    }];
}


//- (void)turnOnOffShop:(UISwitch *)sender
//{
//    __block NSString *status =  nil;
//    if (sender.on) {
//        status = @"开店成功";
//    }else{
//        status = @"关店成功";
//    }
//    typeof(self) weakSelf = self;
//    [[WKNetworkManager sharedAuthManager] POST:@"v1/Kitchen/SwitchOnOff" responseInMainQueue:YES parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [YRToastView showMessage:status inView:weakSelf.view];
//        });
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"错误信息 -> %@",error);
//        [YRToastView showMessage:@"厨房状态切换失败" inView:weakSelf.view];
//
//        
//    }];
//}

#pragma mark - header menu delegate
- (void)didQueryCookMenu
{
    //要做的菜
    WEMainOrderViewController *orderManager = [[WEMainOrderViewController alloc]init];
    orderManager.selectIndex = 0;
    [self.navigationController pushViewController:orderManager animated:YES];

//    WKOrderManagerViewController *orderManager = [[WKOrderManagerViewController alloc]init];
//    orderManager.currentIndex = 0;
 //   [self.navigationController pushViewController:orderManager animated:YES];
}

- (void)didQueryTodayOrder
{
    //今日订单
    WEMainOrderViewController *orderManager = [[WEMainOrderViewController alloc]init];
    orderManager.selectIndex = 1;
    [self.navigationController pushViewController:orderManager animated:YES];

//    WKOrderManagerViewController *orderManager = [[WKOrderManagerViewController alloc]init];
//    orderManager.currentIndex = 1;
//    [self.navigationController pushViewController:orderManager animated:YES];
}

- (void)didQueryTomorrowOrder
{
    //明日订单
    WEMainOrderViewController *orderManager = [[WEMainOrderViewController alloc]init];
    orderManager.selectIndex = 2;
    [self.navigationController pushViewController:orderManager animated:YES];
//    WKOrderManagerViewController *orderManager = [[WKOrderManagerViewController alloc]init];
//    orderManager.currentIndex = 2;
//    [self.navigationController pushViewController:orderManager animated:YES];
}

- (void)enterFunction:(UITapGestureRecognizer *)recognizer
{
    NSInteger viewTag = recognizer.view.tag;
    switch (viewTag - 1000) {
        case 1:{
            //订单管理
            //WKOrderManagerViewController *orderManager = [[WKOrderManagerViewController alloc]init];
            WEMainOrderViewController *orderManager = [[WEMainOrderViewController alloc]init];
            orderManager.selectIndex = 0;
            [self.navigationController pushViewController:orderManager animated:YES];
        }
            break;
        case 2:{
            //我的收入
            WEIncomeViewController *incomeVc = [[WEIncomeViewController alloc]init];
            //WKIncomeViewController *incomeVc = [[WKIncomeViewController alloc]init];
            [self.navigationController pushViewController:incomeVc animated:YES];
        }
            break;
        case 3:{
            //厨房设置
            WEKitchenSettingViewController *ktchenController = [[WEKitchenSettingViewController alloc]init];
            //WKKitchenViewController *ktchenController = [[WKKitchenViewController alloc]init];
            [self.navigationController pushViewController:ktchenController animated:YES];
        }
            break;
        case 4:{
            //菜品设置
            WKMenuViewController *menuController = [[WKMenuViewController alloc]init];
            [self.navigationController pushViewController:menuController animated:YES];
        }
            break;
        case 5:{
            //饭友评价
            MainUserCommentViewController *c = [MainUserCommentViewController new];
            [self.navigationController pushViewController:c animated:YES];
            //WKClientEvaluateController *evaController = [[WKClientEvaluateController alloc]init];
            //[self.navigationController pushViewController:evaController animated:YES];
        }
            break;
        case 6:{
            //帮助中心
//            WKHelpViewController *helpController = [[WKHelpViewController alloc]init];
//            [self.navigationController pushViewController:helpController animated:YES];
            
            WKWebBrowserViewController *webBrowser = [[WKWebBrowserViewController alloc]init];
            webBrowser.url = @"https://api.woeatapp.com/WebPage/View/KITCHEN_HANDBOOK_INDEX";
            webBrowser.webTitle = @"帮助中心";
            [self.navigationController pushViewController:webBrowser animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
