//
//  WKTodayOrderViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/11/2.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKTodayOrderViewController.h"
#import "WKOrderType0TableViewCell.h"
#import "WKOrderType1TableViewCell.h"
#import "WKOrderType2TableViewCell.h"
#import "WKOrderFilterTableViewCell.h"
#import "WKOrderTableHeaderView.h"
#import "WKOrderDetailViewController.h"
#import "FilterDelegate.h"

#import "OrderModel.h"

@interface WKTodayOrderViewController ()<WKOrderGroupHeaderViewDelegate,FilterDelegate>{
    BOOL isExpend;
    NSInteger pageIndex;
    NSString *OrderStatus;
    NSString *DispatchMethod;
    NSString *OrderBy;
    NSString *OrderDir;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) WKOrderTableHeaderView *headerView;
@end


@implementation WKTodayOrderViewController

- (void)loadView
{
    [super loadView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndex = 0;
    
    
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor orangeColor];
    
//    [_tableView registerClass:[WKOrderType0TableViewCell class] forCellReuseIdentifier:@"WKOrderType0TableViewCell"];
//    [_tableView registerClass:[WKOrderType1TableViewCell class] forCellReuseIdentifier:@"WKOrderType1TableViewCell"];
//    [_tableView registerClass:[WKOrderType2TableViewCell class] forCellReuseIdentifier:@"WKOrderType2TableViewCell"];
//    [_tableView registerClass:[WKOrderFilterTableViewCell class] forCellReuseIdentifier:@"WKOrderFilterTableViewCell"];

    _dataArray = [[NSMutableArray alloc]init];
    [self getOrderList];

    
//    NSArray *array = @[@1,@0,@2];
//    [_dataArray addObjectsFromArray:array];
    isExpend = NO;
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self getOrderList];

}


-(void)getOrderList{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }else{
        [_dataArray removeAllObjects];
    }
    self.dayStyle = 0;
    NSString *urlPath = @"";
    if (self.dayStyle == 0) {
        urlPath = @"GetOrderListToday";
    }else if (self.dayStyle == 1){
        urlPath = @"GetOrderListToday";
    }else{
        urlPath = @"GetOrderListToday";

    }
    
    NSDictionary *param = @{@"PageFilter":@(pageIndex),
                            @"OrderStatus":OrderStatus?OrderStatus:@"",
                            @"DispatchMethod":DispatchMethod?DispatchMethod:@"",
                            @"OrderBy":OrderBy?OrderBy:@"",
                            @"OrderDir":OrderDir?OrderDir:@"ASC",
                            };
    [[WKNetworkManager sharedAuthManager] POST:[NSString stringWithFormat:@"v1/SalesOrderKitchen/%@",urlPath] responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"IsSuccessful"] integerValue] == 1) {
                    NSArray *orderList = responseObject[@"OrderList"];
                    
                    if (orderList.count == 0) {
                        [YRToastView showMessage:@"没有找到符合条件的订单" inView:self.view];
                    }
                    for (NSDictionary *dict in orderList) {
                        OrderModel *model = [[OrderModel alloc] initWithDictionary:dict error:nil];
                        [_dataArray addObject:model];
                        [_tableView reloadData];
                    }
                    
                }
                
            }
            
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView showMessage:error.description inView:self.view];
    }];
}


#pragma mark---------UITableViewDataSource, UITableViewDelegate 代理方法


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return isExpend?1:0;
    }else{
        return _dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heightOfRow = 100.0;
    if (indexPath.section == 0) {
        return 216;
    }else{
        NSInteger type = [self orderType:_dataArray[indexPath.row]];
        
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
            default:
                break;
        }
    }
    
    return heightOfRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        WKOrderFilterTableViewCell *filterCell =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderFilterTableViewCell" forIndexPath:indexPath];
        filterCell.delegate = self;
        filterCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return filterCell;
    }else{
        OrderModel *model = nil;
        if (_dataArray.count > indexPath.row) {
            model = _dataArray[indexPath.row];
        }
        NSInteger type = [self orderType:model];
        
        switch (type) {
            case 0://退款中
            {
                WKOrderType0TableViewCell *cell0 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType0TableViewCell" forIndexPath:indexPath];
                cell0.model = model;
                cell0.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell0;
            }
                break;
            case 1://新订单
            {
                WKOrderType1TableViewCell *cell1 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType1TableViewCell" forIndexPath:indexPath];
                cell1.model = model;
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell1;
            }
                break;
            case 2://未配送
            {
                WKOrderType2TableViewCell *cell2 =  [tableView dequeueReusableCellWithIdentifier:@"WKOrderType2TableViewCell" forIndexPath:indexPath];
                cell2.model = model;

                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell2;
            }
                break;
            default:
                break;
        }
        
    }
    return nil;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (!_headerView) {
            _headerView = [[WKOrderTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 36)];
            _headerView.delegate = self;
            _headerView.orderModel = _orderModel;
            _headerView.isExpend = isExpend;
            _headerView.backgroundColor = [UIColor grayColor];
            _headerView.tag = 0; //
        }
        return _headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 36;
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    OrderModel *Model = _dataArray[indexPath.row];
    NSInteger type = [self orderType:Model];
    WKOrderDetailViewController *detail =  [[UIStoryboard orderStoryboard] instantiateViewControllerWithIdentifier:@"WKOrderDetailViewController"];
    detail.model = Model;
    detail.orderType = type;
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark - headerView的代理方法
- (void)OrderHeaderViewDidClickBtn:(WKOrderTableHeaderView *)headerView{
    isExpend = _headerView.isExpend;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:headerView.tag];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
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
    
//    COMPLETED	已完成
//    TO_BE_COMMENTTED 待评论
//    DISPATCHED 已派送
//    ACCEPTED 已接单
//    REJECTED 已拒单
//    PAID 已付款
//    UNPAID 待付款
//    UNSUBMITTED 待提交
    
    if (model.IsFullyPaid && !model.IsDispatched) {
        type = 2;
    }
    if (model.IsSubmitted && !model.IsAccepted) {
        type = 1;
    }
    return type;
}
- (void)orderStatus:(NSString *)status{
    
    OrderStatus = status;
    [self getOrderList];
    [_tableView reloadData];
}

- (void)dispatchMethod:(NSString *)status{
    
    DispatchMethod = status;
    [self getOrderList];
    [_tableView reloadData];

}

- (void)orderBy:(NSString *)status{
    
    OrderBy = status;
    [self getOrderList];
    [_tableView reloadData];

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
