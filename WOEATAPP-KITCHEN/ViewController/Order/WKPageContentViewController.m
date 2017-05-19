//
//  WKPageContentViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/25.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKPageContentViewController.h"
#import "WKPageContentDetailViewController.h"
#import "NSDate+Time.h"
#import "ToCookModel.h"

@interface WKPageContentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WKPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];
    [self getToCookList];

    [self.view addSubview:self.tableView];
    [self creatHeaderView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)getToCookList{
    [_dataArray removeAllObjects];
    
    NSString *todayTime = [NSDate stringWithDate:[NSDate date]];
    NSDictionary *param = @{@"BusinessHourId":@(_dayTimeId),@"Date":todayTime};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/SalesOrderKitchen/GetItemToCookList" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"IsSuccessful"] integerValue] == 1) {
            NSLog(@"获取菜品信息成功 %@",responseObject);
            NSArray *cookList = responseObject[@"ItemToCookList"];
            for (NSDictionary *dict in cookList) {
                ToCookModel *model = [[ToCookModel alloc] initWithDictionary:dict error:nil];
                [_dataArray addObject:model];
            }
            [_tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取要做的菜错误 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];

}

-(void)creatHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = self.pageTitle;
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView).offset(30),
        make.centerY.equalTo(headerView),
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
    return _dataArray.count;
    
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
    ToCookModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.ItemName;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - 60, 10, 80, 15)];
    label.text = [NSString stringWithFormat:@"%ld",(long)model.Quantity];
    label.font = [UIFont boldSystemFontOfSize:16];
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ToCookModel *model = _dataArray[indexPath.row];

    WKPageContentDetailViewController *detail = [[WKPageContentDetailViewController alloc] init];
    detail.pageTitle = self.pageTitle;
    detail.itemId = model.ItemId;
    detail.model = model;
    detail.BusinessHourId = _dayTimeId;
    [self.navigationController pushViewController:detail animated:YES];

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
