//
//  WKOrderDetailViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/26.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKOrderDetailViewController.h"
#import "WKOrderType0TableViewCell.h"
#import "WKOrderType1TableViewCell.h"
#import "WKOrderType2TableViewCell.h"
#import "WKOrderFilterTableViewCell.h"
#import "WKOrderTableHeaderView.h"
#import "WKOrderType3TableViewCell.h"
#import "WKOrderType4TableViewCell.h"
#import "LineModel.h"

@interface WKOrderDetailViewController (){
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *lineArray;

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) WKOrderTableHeaderView *headerView;

@end

@implementation WKOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndex = 0;
    
    
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor orangeColor];
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title = @"订单详情";
    [self.view addSubview:self.tableView];
    
//    [self getTodayOrderList];
    [self creatFooter];
    _dataArray = [[NSMutableArray alloc]init];
//    _lineArray = [[NSMutableArray alloc]init];
    _lineArray = _model.Lines;
    
    NSArray *array = @[@(_orderType),@3,@4];
    [_dataArray addObjectsFromArray:array];
    [_tableView reloadData];
}
-(void)creatFooter{
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 90)];
    self.tableView.tableFooterView = footer;
    UIButton *accept = [UIButton new];
    accept.backgroundColor = [UIColor greenColor];
    [accept setTitle:@"接单" forState:UIControlStateNormal];
    [accept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [accept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];

    [accept.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [footer addSubview:accept];
    [accept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footer).offset(-50),
        make.centerY.equalTo(footer),
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
    }];
    accept.layer.cornerRadius = 3;
    accept.layer.masksToBounds = YES;
    
    UIButton *reject = [UIButton new];
    reject.backgroundColor = [UIColor redColor];
    [reject setTitle:@"拒单" forState:UIControlStateNormal];
    [reject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reject addTarget:self action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
    [reject.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [footer addSubview:reject];
    [reject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footer).offset(50),
        make.centerY.equalTo(footer),
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
    }];
    reject.layer.cornerRadius = 3;
    reject.layer.masksToBounds = YES;
    
    UIButton *refunds = [UIButton new];
    refunds.backgroundColor = [UIColor lightGrayColor];
    [refunds setTitle:@"退款" forState:UIControlStateNormal];
    [refunds setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refunds.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [footer addSubview:refunds];
    [refunds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footer),
        make.centerY.equalTo(footer).offset(38),
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
    }];
    refunds.layer.cornerRadius = 3;
    refunds.layer.masksToBounds = YES;
    
}

-(void)acceptAction:(id)sender{
    NSDictionary *param = @{@"OrderId":@(_model.Id)};
    [[WKNetworkManager sharedAuthManager] GET:@"v1/SalesOrderKitchen/AcceptOrder" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YRToastView showMessage:@"接单成功" inView:self.view];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
}

-(void)rejectAction:(id)sender{
    NSDictionary *param = @{@"OrderId":@(_model.Id)};
    [[WKNetworkManager sharedAuthManager] GET:@"v1/SalesOrderKitchen/RejectOrder" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YRToastView showMessage:@"拒单成功" inView:self.view];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
}

-(void)getTodayOrderList{
    
    NSDictionary *param = @{@"PageFilter":@(pageIndex)};
    [[WKNetworkManager sharedAuthManager] POST:@"v1/SalesOrderKitchen/GetOrderListToday" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
}


#pragma mark---------UITableViewDataSource, UITableViewDelegate 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    }else if (section == 1){
        return _lineArray.count;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heightOfRow = 100;
    NSInteger type = [_dataArray[indexPath.section] integerValue];
    switch (type) {
        case 0:
            return 74;
            break;
        case 1:
            return 117;
            break;
        case 2:
            return 164;
            break;
        case 3:
            return 40;
            break;
        case 4:
            return 80;
            break;
        default:
            break;
    }
    return heightOfRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger type = [_dataArray[indexPath.section] integerValue];
    switch (type) {
        case 0:
        {
            WKOrderType0TableViewCell *cell0 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType0TableViewCell" forIndexPath:indexPath];
            cell0.model = _model;
            cell0.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell0;
        }
            break;
        case 1:
        {
            WKOrderType1TableViewCell *cell1 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType1TableViewCell" forIndexPath:indexPath];
            cell1.model = _model;

            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell1;
        }
            break;
        case 2:
        {
            WKOrderType2TableViewCell *cell2 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType2TableViewCell" forIndexPath:indexPath];
            cell2.model = _model;

            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell2;
        }
            break;
        case 3:
        {
            WKOrderType3TableViewCell *cell3 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType3TableViewCell" forIndexPath:indexPath];

            NSDictionary *dict = _lineArray[indexPath.row];
            LineModel *lineModel = [[LineModel alloc] initWithDictionary:dict error:nil];
            cell3.lineModel = lineModel;
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
//            CGRect temp = cell3.cellHeader.frame;
//            if (indexPath.row == 0) {
//                temp.size.height = 36;
//                cell3.cellHeader.frame = temp;
//            }else{
//                temp.size.height = 0;
//                cell3.cellHeader.frame = temp;
////                cell3.cellHeader.hidden = YES;
//
//            }
            return cell3;
        }
            break;
        case 4:
        {
            WKOrderType4TableViewCell *cell4 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType4TableViewCell" forIndexPath:indexPath];
            cell4.model = _model;
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell4;
        }
            break;
        default:
            break;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        UIView* header = [[UIView alloc] init];
        
        header.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 90, 22)];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        if (section == 1) {
            titleLabel.text = @"订单内容";
        }else{
            titleLabel.text = @"饭友捎话";
        }
        [header addSubview:titleLabel];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 38;
    }
    return 0;
}

-(NSInteger)orderType:(OrderModel *)model{
    NSInteger type = 2;
    
    //        IsAccepted = 1;
    //        IsCommented = 0;
    //        IsDispatched = 0;
    //        IsFullyPaid = 1;
    //        IsPartiallyPaid = 0;
    //        IsReadyForDispatch = 0;
    //        IsReceived = 0;
    //        IsRejected = 0;
    //        IsSubmitted = 1;
    
    if (model.IsFullyPaid && !model.IsDispatched) {
        type = 2;
    }
    if (model.IsSubmitted && !model.IsAccepted) {
        type = 1;
    }
    return type;
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
