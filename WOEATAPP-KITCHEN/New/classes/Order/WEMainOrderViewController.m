//
//  WEMainOrderViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEMainOrderViewController.h"
#import "WEItemToCookViewController.h"
#import "WETodayOrderListViewController.h"
#import "WEOtherOrderListViewController.h"
#import "WMPageController.h"
#import "WEUtil.h"

@interface WEMainOrderViewController ()
{
    WMPageController *_pageController;
}
@end

@implementation WEMainOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"订单管理";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    NSArray *titles = @[@"要做的菜", @"今日订单", @"明日订单", @"其他订单"];
    NSArray *classes = @[[WEItemToCookViewController class], [WETodayOrderListViewController class], [WETodayOrderListViewController class], [WEOtherOrderListViewController class]];
    WMPageController *pageController = [[WMPageController alloc] initWithViewControllerClasses:classes andTheirTitles:titles];
    pageController.menuItemWidth = [WEUtil getScreenWidth]/4.0;
    pageController.postNotification = YES;
    pageController.bounces = YES;
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeNormal = 13;
    pageController.titleSizeSelected = 13;
    pageController.titleColorSelected = [UIColor whiteColor];
    pageController.titleColorNormal = UICOLOR(50, 50, 50);
    pageController.dataSource = self;
    pageController.delegate = self;
    pageController.menuHeight = 38;
    pageController.itemHeight = 38-4;
    pageController.itemTopSpace = 0;
    pageController.itemMargin = 0;
    pageController.menuViewContentMargin = 0;
    pageController.progressColor = UICOLOR(61,57,56);
    pageController.progressHeight = 4;
    pageController.progressViewBottomSpace = 0;
    pageController.menuBGColor = UICOLOR(255,255,255);
    pageController.selectIndex = _selectIndex;
    [superView addSubview:pageController.view];
    [self addChildViewController:pageController];
    [pageController.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _pageController = pageController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    if (index == 0) {
        WEItemToCookViewController *c = [WEItemToCookViewController new];
        return c;
    } else if (index == 1) {
        WETodayOrderListViewController *c = [WETodayOrderListViewController new];
        c.type = TodayOrderListViewController_Today;
        return c;
    } else if (index == 2) {
        WETodayOrderListViewController *c = [WETodayOrderListViewController new];
        c.type = TodayOrderListViewController_Tomorrow;
        return c;
    } else if (index == 3) {
        WEOtherOrderListViewController *c = [WEOtherOrderListViewController new];
        return c;
    }
    return nil;
}
//
//- (UIImageView *)badgeView:(WMPageController *)pageController atIndex:(NSInteger)index selected:(BOOL)isSelected
//{
//    UIImageView *v = [UIImageView new];
//    NSArray *normalImages = @[@"tab_icon_home_normal",   @"tab_icon_discover_normal",  @"tab_icon_order_normal", @"tab_icon_setting_normal"];
//    NSArray *selectImages = @[@"tab_icon_home_selected", @"tab_icon_discover_selected", @"tab_icon_order_selected", @"tab_icon_setting_selected"];
//    v.frame = CGRectMake(0, 10, 50, 50);
//    
//    if (isSelected) {
//        NSString *s = selectImages[index];
//        v.image = [UIImage imageNamed:s];
//    } else {
//        NSString *s = normalImages[index];
//        v.image = [UIImage imageNamed:s];
//    }
//    return v;
//}
//
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSLog(@"pageController didEnterViewController %@, info %@", viewController, info);
    if ([viewController isKindOfClass:[WETodayOrderListViewController class]]) {
        WETodayOrderListViewController *c = (WETodayOrderListViewController *)viewController;
        [c loadDataIfNeeded];
        
    } else if ([viewController isKindOfClass:[WEOtherOrderListViewController class]]) {
        WEOtherOrderListViewController *c = (WEOtherOrderListViewController *)viewController;
        [c loadDataIfNeeded];
    
    } else if ([viewController isKindOfClass:[WEItemToCookViewController class]]) {
        WEItemToCookViewController *c = (WEItemToCookViewController *)viewController;
        [c loadDataIfNeeded];
    }
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
