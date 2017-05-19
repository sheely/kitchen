//
//  WKPageContentDetailViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/25.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKPageContentDetailViewController.h"
#import "NSDate+Time.h"
#import "ToCookOrderModel.h"

@interface WKPageContentDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *orderArray;

@end

@implementation WKPageContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = @[@{@"date":@"订单 10000101 自取 12:00",@"money":@"13份"},
                   @{@"date":@"订单 10000101 自取 12:00",@"money":@"13份"},
                   @{@"date":@"订单 10000101 自取 12:00",@"money":@"90份"},
                   @{@"date":@"订单 10000101 自取 12:00",@"money":@"33份"}];
    [self getOrderList];

    _orderArray = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    [self creatHeaderView];
    [self creatFooterView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)getOrderList{
    [_orderArray removeAllObjects];
    NSString *todayTime = [NSDate stringWithDate:[NSDate date]];
    NSDictionary *param = @{@"BusinessHourId":@(_BusinessHourId),
                            @"ItemId":@(_itemId),
                            @"Date":todayTime
                            };
    
    [[WKNetworkManager sharedAuthManager] POST:@"v1/SalesOrderKitchen/GetItemToCookPerOrderList" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"IsSuccessful"] integerValue] == 1) {
            NSLog(@"获取菜品信息成功 %@",responseObject);
            NSArray *orderList = responseObject[@"ItemToCookPerOrderList"];
            for (NSDictionary *dict in orderList) {
                ToCookOrderModel *model = [[ToCookOrderModel alloc] initWithDictionary:dict error:nil];
                [_orderArray addObject:model];
            }

            [_tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取要做的菜错误 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
    
}


-(void)creatFooterView{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    UIButton *backBtn = [UIButton new];
    [backBtn setTitle:@"返回菜品列表" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView),
        make.centerY.equalTo(footerView),
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
    }];

    _tableView.tableFooterView = footerView;

}

-(void)creatHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    
//    UIButton *backBtn = [UIButton new];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:backBtn];
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(headerView).offset(15),
//        make.topMargin.equalTo(headerView).offset(6),
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(40);
//    }];
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = self.pageTitle;
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView).offset(15),
        make.topMargin.equalTo(headerView).offset(10),
        make.height.mas_equalTo(17);
    }];
    
    UILabel *foodLabel = [UILabel new];
    foodLabel.text = @"鱼香肉丝";
    foodLabel.backgroundColor = [UIColor clearColor];
    foodLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:foodLabel];
    [foodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(moneyLabel),
        make.topMargin.equalTo(moneyLabel).offset(25),
        make.height.mas_equalTo(17);
    }];
    
    UILabel *numLabel = [UILabel new];
    numLabel.text = @"13份";
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(headerView).offset(-20),
        make.centerY .equalTo(foodLabel),
        make.height.mas_equalTo(17);
    }];
    
    _tableView.tableHeaderView = headerView;
    
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark---------UITableViewDataSource, UITableViewDelegate 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orderArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ToCookOrderModel *model = _orderArray[indexPath.row];
    NSString *dispacth = @"";
    if ([model.DispatchMethod isEqualToString:@"DELIVER"]) {
        dispacth = @"送餐";
    }else if ([model.DispatchMethod isEqualToString:@"PICKUP "]){
        dispacth = @"自取";

    }
    cell.textLabel.text = [NSString stringWithFormat:@"订单%ld %@ %@",(long)model.SalesOrderId,dispacth,model.RequiredArrivalTime];
//    cell.textLabel.text = _dataArray[indexPath.row][@"date"];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - 50, 10, 80, 15)];
//    label.text = _dataArray[indexPath.row][@"money"];
    label.text = [NSString stringWithFormat:@"%ld份",(long)model.Quantity];
    label.font = [UIFont boldSystemFontOfSize:16];
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(void)backAction:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
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
