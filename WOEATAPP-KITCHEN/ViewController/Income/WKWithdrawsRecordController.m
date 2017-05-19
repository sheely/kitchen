//
//  WKWithdrawsRecordController.m
//  WOEATAPP-KITCHEN
//
//  Created by 咸菜 on 2017/1/7.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WKWithdrawsRecordController.h"
#import "WKWithdrawsRecordCell.h"
#import "CashOutModel.h"
#import "OrderModel.h"
#import "WKOrderDetailViewController.h"

@interface WKWithdrawsRecordController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL isMonthRecord ;
}

@property (nonatomic, strong) UITableView *recordTableView;
@property (nonatomic, strong) NSMutableArray *recordArray;

@end

@implementation WKWithdrawsRecordController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    _recordArray = [NSMutableArray array];
    [self.view addSubview:self.recordTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.recordDic) {
        NSInteger year = [self.recordDic[@"Year"] integerValue];
        NSInteger month = [self.recordDic[@"Month"] integerValue];
        [self requestRecordWithMonth:month year:year];
        self.title = [NSString stringWithFormat:@"%ld年%ld月",(long)year,(long)month];

        isMonthRecord = YES;
    }else{
        isMonthRecord = NO;
        self.title = @"提现记录";
        [self requestWithdrawsRecord];
    }
}

- (UITableView *)recordTableView
{
    if (_recordTableView == nil) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
        _recordTableView.dataSource = self;
        _recordTableView.delegate = self;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _recordTableView.separatorColor = [UIColor lightGrayColor];
        _recordTableView.tableFooterView = [[UIView alloc] init];
        if ([_recordTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_recordTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _recordTableView;
}

- (void)requestRecordWithMonth:(NSInteger)month year:(NSInteger)year
{
//    https://api.woeatapp.com/v1/Kitchen/GetKitchenOrdersByMonth?Year=2017&Month=1
    [_recordArray removeAllObjects];

    WS(ws);
    NSDictionary *param = @{@"Year":@(year),@"Month":@(month)};
    [[WKNetworkManager sharedAuthManager] GET:@"v1/Kitchen/GetKitchenOrdersByMonth" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                    NSArray *orderList = responseObject[@"OrderList"];
                    for (NSDictionary *dict in orderList) {
                        OrderModel *model = [[OrderModel alloc] initWithDictionary:dict error:nil];
                        [_recordArray addObject:model];
                        [_recordTableView reloadData];
                    }
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
    }];

}

- (void)requestWithdrawsRecord
{
    [_recordArray removeAllObjects];
    NSDictionary *param = @{};
    WS(ws);
    [[WKNetworkManager sharedAuthManager] GET:@"v1/TransactionCashOutRequest/GetCashOutRequestList" responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"IsSuccessful"] integerValue] == 1) {
                    NSArray *list = responseObject[@"CashOutRequestList"];
                    
                    for (NSDictionary *dict in list) {
                        CashOutModel *model = [[CashOutModel alloc] initWithDictionary:dict error:nil];
                        [_recordArray addObject:model];
                    }
                    [ws.recordTableView reloadData];
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
    }];
}
#pragma mark- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    WKWithdrawsRecordCell *recordCell = [[WKWithdrawsRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recordCell"];
    recordCell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (isMonthRecord) {
        OrderModel *model = _recordArray[indexPath.row];
        recordCell.cellType = 1;
        [recordCell loadMonthData:model];
        recordCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else{
        CashOutModel *model = _recordArray[indexPath.row];
        recordCell.cellType = 2;
        recordCell.accessoryType = UITableViewCellAccessoryNone;
        [recordCell loadData:model];

    }
    cell = recordCell;
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isMonthRecord) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        OrderModel *Model = _recordArray[indexPath.row];
        NSInteger type = [self orderType:Model];
        WKOrderDetailViewController *detail =  [[UIStoryboard orderStoryboard] instantiateViewControllerWithIdentifier:@"WKOrderDetailViewController"];
        detail.model = Model;
        detail.orderType = type;
        [self.navigationController pushViewController:detail animated:YES];

    }
}

-(NSInteger)orderType:(OrderModel *)model{
    NSInteger type = 2;
    
    if (model.IsFullyPaid && !model.IsDispatched) {
        type = 2;
    }
    if (model.IsSubmitted && !model.IsAccepted) {
        type = 1;
    }
    return type;
}

@end
