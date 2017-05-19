//
//  WEOrderFilterView.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/5.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEOrderFilterView.h"
#import "WEUtil.h"
#import "WECheckButtonGroup.h"

@interface WEOrderFilterView()
{
    UITableView *_tableView;
    int _c1;
    int _c2;
    int _c3;
    WECheckButtonGroup *_g1;
    WECheckButtonGroup *_g2;
    WECheckButtonGroup *_g3;
}

@end

@implementation WEOrderFilterView

- (instancetype)init
{
    self = [super init];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIView *superView = self;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top).offset(0);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(superView.bottom);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *superView = cell.contentView;
    float offsetX = 20;
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        superView.backgroundColor = UICOLOR(247, 247, 247);
        UILabel *t1 = [UILabel new];
        t1.backgroundColor = [UIColor clearColor];
        t1.font = [UIFont systemFontOfSize:13];
        [superView addSubview:t1];
        [t1 sizeToFit];
        [t1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
        }];
        if (indexPath.row == 0) {
            t1.text = @"订单状态";
        } else if (indexPath.row == 2) {
            t1.text = @"就餐方式";
        } else if (indexPath.row == 4) {
            t1.text = @"排序方式";
        }
    
    } else if (indexPath.row == 1) {
        superView.backgroundColor = [UIColor whiteColor];
        WECheckButtonGroup *gState = [WECheckButtonGroup new];
        gState.type = WECheckButtonGroup_SINGLE_CAN_EMPTY;
        gState.checkedIndex = _c1;
        gState.selectImageName = @"checkbox_check";
        gState.unSelectImageName = @"checkbox_uncheck";
        gState.titleArray = @[@"新订单", @"已接单", @"已完成", @"退款中"];
        gState.buttonWidth = [WEUtil getScreenWidth] * 0.23;
        [gState setUp];
        [superView addSubview:gState];
        [gState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo([gState originSize].width);
            make.height.equalTo([gState originSize].height);
        }];
        _g1 = gState;

    } else if (indexPath.row == 3) {
        superView.backgroundColor = [UIColor whiteColor];
        WECheckButtonGroup *gState = [WECheckButtonGroup new];
        gState.type = WECheckButtonGroup_SINGLE_CAN_EMPTY;
        gState.checkedIndex = _c2;
        gState.selectImageName = @"checkbox_check";
        gState.unSelectImageName = @"checkbox_uncheck";
        gState.titleArray = @[@"饭友自取", @"家厨配送"];
        gState.buttonWidth = [WEUtil getScreenWidth] * 0.23;
        [gState setUp];
        [superView addSubview:gState];
        [gState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo([gState originSize].width);
            make.height.equalTo([gState originSize].height);
        }];
        _g2 = gState;
        
    } else if (indexPath.row == 5) {
        superView.backgroundColor = [UIColor whiteColor];
        WECheckButtonGroup *gState = [WECheckButtonGroup new];
        gState.type = WECheckButtonGroup_SINGLE_NOT_EMPTY;
        gState.checkedIndex = _c3;
        gState.selectImageName = @"icon_circle_check";
        gState.unSelectImageName = @"icon_circle_uncheck";
        gState.titleArray = @[@"下单时间", @"就餐时间"];
        gState.buttonWidth = [WEUtil getScreenWidth] * 0.23;
        [gState setUp];
        [superView addSubview:gState];
        [gState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo([gState originSize].width);
            make.height.equalTo([gState originSize].height);
        }];
        _g3 = gState;
        
    } else if (indexPath.row == 6) {
        UIButton *button = [UIButton new];
        button.backgroundColor = UICOLOR(199, 199, 203);
        [button setTitle:@"过滤" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.cornerRadius=4.0f;
        button.layer.masksToBounds=YES;
        button.layer.borderColor=[UIColor clearColor].CGColor;
        button.layer.borderWidth= 1.0f;
        [superView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(superView.top);
            make.width.equalTo(70);
            make.height.equalTo(25);
        }];
        [button addTarget:self action:@selector(okTap:) forControlEvents:UIControlEventTouchUpInside];
        
//        button = [UIButton new];
//        button.backgroundColor = UICOLOR(199, 199, 203);
//        [button setTitle:@"取消" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:13];
//        button.layer.cornerRadius=4.0f;
//        button.layer.masksToBounds=YES;
//        button.layer.borderColor=[UIColor clearColor].CGColor;
//        button.layer.borderWidth= 1.0f;
//        [superView addSubview:button];
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(superView.left).offset(offsetX+70+25);
//            make.top.equalTo(superView.top);
//            make.width.equalTo(70);
//            make.height.equalTo(25);
//        }];
//        [button addTarget:self action:@selector(cancelTap:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [UIView new];
        line.backgroundColor = UICOLOR(200, 200, 200);
        [superView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.bottom.equalTo(superView.bottom).offset(0);
            make.right.equalTo(superView.right);
            make.height.equalTo(0.5);
        }];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float heighs[] = {35, 45, 35, 45, 35, 45, 40};
    
    return heighs[indexPath.row];
}

- (void)refresh
{
    [_tableView reloadData];
}

- (void)setCheck1:(int)check1
{
    _c1 = check1;
    [self refresh];
}

- (void)setCheck2:(int)check2
{
    _c2 = check2;
    [self refresh];
}

- (void)setCheck3:(int)check3
{
    _c3 = check3;
    [self refresh];
}


- (int)check1
{
    return _g1.checkedIndex;
}

- (int)check2
{
    return _g2.checkedIndex;
}

- (int)check3
{
    return _g3.checkedIndex;
}

- (float)getHeight
{
    return _tableView.contentSize.height;
}


- (void)cancelTap:(UIButton *)button
{
    [_filterDelegate cancelButtonTapped:button];
}

- (void)okTap:(UIButton *)button
{
    [_filterDelegate okButtonTapped:button];
}

@end
