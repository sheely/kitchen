//
//  WKOrderManagerViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/19.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKOrderManagerViewController.h"
#import "YRSegmentControl.h"
#import "UIButton+YRSegmentExt.h"
#import "WKToDoListViewController.h"
#import "WKTodayOrderViewController.h"
#import "WKTomorrowOrderViewController.h"
#import "WKFinishedOrderViewController.h"

@interface WKOrderManagerViewController ()<YRSegmentControlDelegate,UIScrollViewDelegate>{
    YRSegmentControl *_segmentControl;
    NSArray          *_segmentedArray;
    UIScrollView     *_contentView;
}

@property (nonatomic, strong)UIViewController *currentVC;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong) WKToDoListViewController *todoListVc;
@property (nonatomic, strong) WKTodayOrderViewController *todayListVc;
@property (nonatomic, strong) WKTomorrowOrderViewController *tomorrowListVc;
@property (nonatomic, strong) WKTodayOrderViewController *finishedListVc;

@end

@implementation WKOrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单管理";
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    WS(weakSelf)
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(60 + 64),
        make.bottom.equalTo(weakSelf.view),
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    
    [self setupSegmentControl];
    
 
    
}

-(UIViewController *)todoListVc{
    if (!_todoListVc) {
        _todoListVc = [[WKToDoListViewController alloc]init];
//        _todoListVc = [[UIStoryboard orderStoryboard] instantiateViewControllerWithIdentifier:@"WKToDoListViewController"];
    }
    return _todoListVc;
}

-(UIViewController *)todayListVc{
    if (!_todayListVc) {
        _todayListVc = [[UIStoryboard orderStoryboard] instantiateViewControllerWithIdentifier:@"WKTodayOrderViewController"];
        _todayListVc.dayStyle = 0;
    }
    return _todayListVc;
}

-(UIViewController *)tomorrowListVc{
    if (!_tomorrowListVc) {
        _tomorrowListVc = [[UIStoryboard orderStoryboard] instantiateViewControllerWithIdentifier:@"WKTomorrowOrderViewController"];
        _tomorrowListVc.dayStyle = 1;

    }
    return _tomorrowListVc;
}

-(UIViewController *)finishedListVc{
    if (!_finishedListVc) {
        _finishedListVc = [[UIStoryboard orderStoryboard] instantiateViewControllerWithIdentifier:@"WKTodayOrderViewController"];
        _finishedListVc.dayStyle = 2;

    }
    return _finishedListVc;
}



-(void)setupSegmentControl {
    _segmentedArray = @[@"要做的菜",@"今日订单",@"明日订单",@"已完成"];
    _segmentControl = [[YRSegmentControl alloc] initWithFrame:CGRectMake(20,64 + 20,self.view.frame.size.width-40,30)];
    
    _segmentControl.delegate               = self;
    _segmentControl.items                  = _segmentedArray;
    _segmentControl.fontSize               = 11;
    _segmentControl.backgroundColor        = [UIColor whiteColor];
    _segmentControl.unSelectedColor        = CommonGoldColor;
    _segmentControl.selectedColor          = [UIColor whiteColor];
    _segmentControl.selectedBackgroundImgName = nil;
    _segmentControl.selectedIndex          = _currentIndex;
    _segmentControl.bottomLineViewColor    = CommonGoldColor;
    _segmentControl.bottomLineViewHeight   = _segmentControl.frame.size.height;
    
    _segmentControl.segmentControlViewBlock = ^(YRSegmentControl *segmentControl,NSInteger btnIndex,NSArray *itemArray) {
        // 自定义
        UIButton *imageBtn = [UIButton getImageBtnWithWithType:UIButtonTypeCustom
                                                  titleBtnType:CImageAndTitleCoincide
                                                         title:itemArray[btnIndex]
                                                     titleFont:[UIFont systemFontOfSize:13]
                                           unSelectedImageName:@""
                                             selectedImageName:@""
                                           unSelectedTextColor:segmentControl.unSelectedColor
                                             selectedTextColor:segmentControl.selectedColor];
        UIEdgeInsets insets      = imageBtn.imageEdgeInsets;
        insets.bottom            = 0;
        imageBtn.imageEdgeInsets = insets;
        [imageBtn.layer setBorderWidth:1.0]; //边框宽度
        imageBtn.layer.borderColor = CommonGoldColor.CGColor;

        return imageBtn;
    };
    
    [self.view addSubview:_segmentControl];
}

-(void)setupContentViews {
    float offY   = CGRectGetHeight(_segmentControl.frame) + _segmentControl.frame.origin.y;
    float width  = CGRectGetWidth(self.view.frame);
    float height = CGRectGetHeight(self.view.frame) - offY;
    
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offY, width, height)];
    _contentView.delegate = self;
    _contentView.scrollEnabled = YES;
    _contentView.pagingEnabled = YES;
    [_contentView setContentSize:CGSizeMake(width * _segmentedArray.count, CGRectGetHeight(_contentView.frame))];
    
    [self.view addSubview:_contentView];
    
    for (int i = 0; i < _segmentedArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        view.backgroundColor = [self randomColor];
        
        [_contentView addSubview:view];
    }
}

#pragma mark - Private
- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


/**
 *  初始化segmentControl
 */
- (UISegmentedControl *)setupSegment{
    NSArray *items = @[@"要做的菜", @"今日订单"];
    UISegmentedControl *sgc = [[UISegmentedControl alloc] initWithItems:items];
    sgc.selectedSegmentIndex = _currentIndex;
    [sgc setTitle:@"oneView" forSegmentAtIndex:0];
    [sgc setTitle:@"twoView" forSegmentAtIndex:1];
    [sgc addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    return sgc;
}

- (void)segmentChange:(UISegmentedControl *)sgc{
    //NSLog(@"%ld", sgc.selectedSegmentIndex);
    switch (sgc.selectedSegmentIndex) {
        case 0:
//            [self replaceFromOldViewController:self.secondVc toNewViewController:self.fristVc];
            break;
        case 1:
//            [self replaceFromOldViewController:self.fristVc toNewViewController:self.secondVc];
            break;
        default:
            break;
    }
}

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == _contentView) {
        //把这个动作放在这里，而不是scrollViewDidScroll，这样就使得点击造成的滑动，和拖拽（Drag）造成的滑动，都只会调用_segmentControl.selectedIndex一次。
        NSInteger remainder = (NSInteger)targetContentOffset->x % (NSInteger)CGRectGetWidth(scrollView.frame);   // 求余数保证整数倍的时候处理
        NSInteger page = (NSInteger)(targetContentOffset->x / CGRectGetWidth(scrollView.frame));
        if (remainder == 0) {
            _segmentControl.selectedIndex = page;
        }
    }
}


#pragma mark - JMSegmentControlDelegate
- (void)onValueChangeFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
//    [_contentView setContentOffset:CGPointMake(toIndex * CGRectGetWidth(self.view.frame), 0) animated:YES];
    
    for (UIViewController *ctr in self.childViewControllers) {
        [ctr removeFromParentViewController];
        [ctr.view removeFromSuperview];
    }
    
    NSLog(@"toIndex %ld",(long)toIndex);
    switch (toIndex) {
        case 0:{
            [self addChildViewControllerAndView:self.todoListVc];
        }
            break;
        case 1:{
            [self addChildViewControllerAndView:self.todayListVc];
        }
        case 2:{
            
            [self addChildViewControllerAndView:self.tomorrowListVc];
        }
        case 3:{
            [self addChildViewControllerAndView:self.finishedListVc];
        }
            
            break;
        default:
            break;
    }
}

-(void)addChildViewControllerAndView:(UIViewController *)vc{
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    WS(weakSelf)
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView),
        make.bottom.equalTo(weakSelf.scrollView),
        make.left.equalTo(weakSelf.scrollView);
        make.right.equalTo(weakSelf.scrollView);
    }];
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
