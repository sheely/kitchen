//
//  MainUserCommentViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/2/17.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "MainUserCommentViewController.h"
#import "WETwoLineSegmentControl.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "WEModelGeKitchenCommentListPositive.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "MainUserCommentCell.h"
#import "WEUserCommentReplyViewController.h"

#define PAGE_COUNT 10

@interface MainUserCommentViewController ()
{
    WETwoLineSegmentControl *_segment;
    UITableView *_tableView;
    
    NSMutableArray *_commentListArray[4];
    int _curPage[4];//from 1
}
@end

@implementation MainUserCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"饭友评价";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float offsetX = 15;
    WETwoLineSegmentControl *segment = [[WETwoLineSegmentControl alloc] initWithItems:@[@"待回复", @"好评", @"中评",@"差评"]];
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [superView addSubview:segment];
    [segment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(42);
    }];
    segment.totalWidth = [WEUtil getScreenWidth] - 2 *offsetX;
    [segment setBottomLineArray:@[@"0", @"0", @"0", @"0"] superView:superView];
    _segment = segment;
    
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[MainUserCommentCell class] forCellReuseIdentifier:@"MainUserCommentCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.bottom).offset(5);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPull)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    for(int i=0; i<4; i++) {
//        if (i == _segment.selectedSegmentIndex) {
//            [self loadDataIfNeeded:i];
//        } else {
//            [self performSelector:@selector(loadDataSilent:) withObject:@(i) afterDelay:0.1];
//        }
//    }
    
    for(int i=0; i<4; i++) {
        if (i == _segment.selectedSegmentIndex) {
           [_tableView.mj_header beginRefreshing];
        } else {
            [self performSelector:@selector(loadDataSilent:) withObject:@(i) afterDelay:0];
        }
    }
}


- (void)initData
{
    for(int i=0; i<4; i++) {
        _curPage[i] = 1;
        _commentListArray[i] = [NSMutableArray new];
    }
}

- (void)updateHeaderCount
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
    for(int i=0; i<4; i++) {
        int row = 0;
        for(WEModelGeKitchenCommentListPositive *model in _commentListArray[i]) {
            row += model.CommentList.count;
        }
        [array addObject:[NSString stringWithFormat:@"%d", row]];
    }
    [_segment setBottomLineArray:array superView:self.view];
}

- (void)realLoadData:(int)index
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取评论，请稍后...";
    [hud show:YES];
    
    if (index == 0) {
        [WENetUtil GeKitchenCommentListToReplyWithPageIndex:_curPage[index]
                                                   Pagesize:PAGE_COUNT
                                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                                        JSONModelError* error = nil;
                                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                                        WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                        if (error) {
                                                            NSLog(@"error %@, model %p", error, model);
                                                        }
                                                        if (!model.IsSuccessful) {
                                                            hud.labelText = model.ResponseMessage;
                                                            [hud hide:YES afterDelay:1.5];
                                                            return;
                                                        }
                                                        
                                                        NSMutableArray *total = _commentListArray[index];
                                                        if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                            [total addObject:model];
                                                            _curPage[index]++;
                                                        } else {
                                                            NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                        }
                                                        
                                                        [_tableView reloadData];
                                                        [self updateHeaderCount];
                                                        [self updateAllLoadedState];
                                                    NSLog(@"GeKitchenCommentListToReplyWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                                        [hud hide:YES afterDelay:0];
                                                    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                        NSLog(@"failure %@", errorMsg);
                                                        hud.labelText = errorMsg;
                                                        [hud hide:YES afterDelay:1.5];
                                                    }];
        
    } else if (index == 1) {
        [WENetUtil GeKitchenCommentListPositiveWithPageIndex:_curPage[index]
                                                   Pagesize:PAGE_COUNT
                                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                                        JSONModelError* error = nil;
                                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                                        WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                        if (error) {
                                                            NSLog(@"error %@, model %p", error, model);
                                                        }
                                                        if (!model.IsSuccessful) {
                                                            hud.labelText = model.ResponseMessage;
                                                            [hud hide:YES afterDelay:1.5];
                                                            return;
                                                        }
                                                        
                                                        NSMutableArray *total = _commentListArray[index];
                                                        if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                            [total addObject:model];
                                                            _curPage[index]++;
                                                        } else {
                                                            NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                        }
                                                        
                                                        [_tableView reloadData];
                                                        [self updateHeaderCount];
                                                        [self updateAllLoadedState];
                                                        NSLog(@"GeKitchenCommentListPositiveWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                                        [hud hide:YES afterDelay:0];
                                                    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                        NSLog(@"failure %@", errorMsg);
                                                        hud.labelText = errorMsg;
                                                        [hud hide:YES afterDelay:1.5];
                                                    }];
    
    } else if (index == 2) {
        [WENetUtil GeKitchenCommentListNeutralWithPageIndex:_curPage[index]
                                                    Pagesize:PAGE_COUNT
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         JSONModelError* error = nil;
                                                         NSDictionary *dict = (NSDictionary *)responseObject;
                                                         WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                         if (error) {
                                                             NSLog(@"error %@, model %p", error, model);
                                                         }
                                                         if (!model.IsSuccessful) {
                                                             hud.labelText = model.ResponseMessage;
                                                             [hud hide:YES afterDelay:1.5];
                                                             return;
                                                         }
                                                         
                                                         NSMutableArray *total = _commentListArray[index];
                                                         if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                             [total addObject:model];
                                                             _curPage[index]++;
                                                         } else {
                                                             NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                         }
                                                         
                                                         [_tableView reloadData];
                                                         [self updateHeaderCount];
                                                         [self updateAllLoadedState];
                                                         NSLog(@"GeKitchenCommentListPositiveWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                                         [hud hide:YES afterDelay:0];
                                                     } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                         NSLog(@"failure %@", errorMsg);
                                                         hud.labelText = errorMsg;
                                                         [hud hide:YES afterDelay:1.5];
                                                     }];
        
    } else if (index == 3) {
        [WENetUtil GeKitchenCommentListNegativeWithPageIndex:_curPage[index]
                                                    Pagesize:PAGE_COUNT
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         JSONModelError* error = nil;
                                                         NSDictionary *dict = (NSDictionary *)responseObject;
                                                         WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                         if (error) {
                                                             NSLog(@"error %@, model %p", error, model);
                                                         }
                                                         if (!model.IsSuccessful) {
                                                             hud.labelText = model.ResponseMessage;
                                                             [hud hide:YES afterDelay:1.5];
                                                             return;
                                                         }
                                                         
                                                         NSMutableArray *total = _commentListArray[index];
                                                         if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                             [total addObject:model];
                                                             _curPage[index]++;
                                                         } else {
                                                             NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                         }
                                                         
                                                         [_tableView reloadData];
                                                         [self updateHeaderCount];
                                                         [self updateAllLoadedState];
                                                         NSLog(@"GeKitchenCommentListPositiveWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                                         [hud hide:YES afterDelay:0];
                                                     } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                         NSLog(@"failure %@", errorMsg);
                                                         hud.labelText = errorMsg;
                                                         [hud hide:YES afterDelay:1.5];
                                                     }];
    }


}

- (void)reloadAllData:(int)index
{
    _curPage[index] = 1;
    [_commentListArray[index] removeAllObjects];
    [self updateAllLoadedState];
    [self realLoadData:index];
}

- (void)loadMoreData:(int)index
{
    [self realLoadData:index];
}

- (NSNumber *)isAllLoaded:(int)index
{
    NSMutableArray *total = _commentListArray[index];
    if(total.count) {
        WEModelGeKitchenCommentListPositive *model = [total lastObject];
        if (model.PageFilter.PageIndex >= model.PageFilter.TotalPages)
            return @YES;
    }
    return @NO;
}

- (BOOL)loadDataIfNeeded:(int)index
{
    NSMutableArray *total = _commentListArray[index];
    if(total.count) {
        [_tableView reloadData];
        [self updateHeaderCount];
        // [self loadDataSilent:index];
        //[self performSelector:@selector(loadDataSilent:) withObject:@(index) afterDelay:0.1];
        return YES;
    } else {
        [_tableView.mj_header beginRefreshing];
        return NO;
    }
}

- (void)loadDataSilent:(NSNumber *)n
{
    int index = n.integerValue;
    _curPage[index] = 1;
    [_commentListArray[index] removeAllObjects];
    [self updateAllLoadedState];
    
    if (index == 0) {
        [WENetUtil GeKitchenCommentListToReplyWithPageIndex:_curPage[index]
                                                   Pagesize:PAGE_COUNT
                                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                                        JSONModelError* error = nil;
                                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                                        WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                        if (error) {
                                                            NSLog(@"error %@, model %p", error, model);
                                                        }
                                                        if (!model.IsSuccessful) {
                                                            return;
                                                        }
                                                        
                                                        NSMutableArray *total = _commentListArray[index];
                                                        if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                            [total addObject:model];
                                                            _curPage[index]++;
                                                        } else {
                                                            NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                        }
                                                        
                                                        [_tableView reloadData];
                                                        [self updateHeaderCount];
                                                        [self updateAllLoadedState];
                                                        NSLog(@"GeKitchenCommentListToReplyWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                                    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                        NSLog(@"failure %@", errorMsg);
                                                    }];
        
    } else if (index == 1) {
        [WENetUtil GeKitchenCommentListPositiveWithPageIndex:_curPage[index]
                                                    Pagesize:PAGE_COUNT
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         JSONModelError* error = nil;
                                                         NSDictionary *dict = (NSDictionary *)responseObject;
                                                         WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                         if (error) {
                                                             NSLog(@"error %@, model %p", error, model);
                                                         }
                                                         if (!model.IsSuccessful) {
                                                             return;
                                                         }
                                                         
                                                         NSMutableArray *total = _commentListArray[index];
                                                         if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                             [total addObject:model];
                                                             _curPage[index]++;
                                                         } else {
                                                             NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                         }
                                                         
                                                         [_tableView reloadData];
                                                         [self updateHeaderCount];
                                                         [self updateAllLoadedState];
                                                         NSLog(@"GeKitchenCommentListPositiveWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                                       
                                                     } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                         NSLog(@"failure %@", errorMsg);
                                                
                                                     }];
        
    } else if (index == 2) {
        [WENetUtil GeKitchenCommentListNeutralWithPageIndex:_curPage[index]
                                                   Pagesize:PAGE_COUNT
                                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                                        JSONModelError* error = nil;
                                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                                        WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                        if (error) {
                                                            NSLog(@"error %@, model %p", error, model);
                                                        }
                                                        if (!model.IsSuccessful) {
                                        
                                                            return;
                                                        }
                                                        
                                                        NSMutableArray *total = _commentListArray[index];
                                                        if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                            [total addObject:model];
                                                            _curPage[index]++;
                                                        } else {
                                                            NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                        }
                                                        
                                                        [_tableView reloadData];
                                                        [self updateHeaderCount];
                                                        [self updateAllLoadedState];
                                                        NSLog(@"GeKitchenCommentListPositiveWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                                       
                                                    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                        NSLog(@"failure %@", errorMsg);
                                                    }];
        
    } else if (index == 3) {
        [WENetUtil GeKitchenCommentListNegativeWithPageIndex:_curPage[index]
                                                    Pagesize:PAGE_COUNT
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         JSONModelError* error = nil;
                                                         NSDictionary *dict = (NSDictionary *)responseObject;
                                                         WEModelGeKitchenCommentListPositive *model = [[WEModelGeKitchenCommentListPositive alloc] initWithDictionary:dict error:&error];
                                                         if (error) {
                                                             NSLog(@"error %@, model %p", error, model);
                                                         }
                                                         if (!model.IsSuccessful) {
                                                          
                                                             return;
                                                         }
                                                         
                                                         NSMutableArray *total = _commentListArray[index];
                                                         if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                             [total addObject:model];
                                                             _curPage[index]++;
                                                         } else {
                                                             NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                         }
                                                         
                                                         [_tableView reloadData];
                                                         [self updateHeaderCount];
                                                         [self updateAllLoadedState];
                                                         NSLog(@"GeKitchenCommentListPositiveWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                               
                                                     } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                         NSLog(@"failure %@", errorMsg);
                                                       
                                                     }];
    }
    
}

- (void)downPull
{
    [self reloadAllData:_segment.selectedSegmentIndex];
    [_tableView.mj_header endRefreshing];
}

- (void)upPull
{
    if ([[self upPullFinished] boolValue]) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadMoreData:_segment.selectedSegmentIndex];
        [_tableView.mj_footer endRefreshing];
    }
    
}

- (NSNumber *)upPullFinished
{
    return [self isAllLoaded:_segment.selectedSegmentIndex];
}

- (void)updateAllLoadedState
{
    if (![[self upPullFinished] boolValue]) {
        [_tableView.mj_footer resetNoMoreData];
    } else {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)segmentValueChanged:(id)sender
{
    [self updateAllLoadedState];
    [self loadDataIfNeeded:_segment.selectedSegmentIndex];
}

- (id)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    for(WEModelGeKitchenCommentListPositive *model in _commentListArray[_segment.selectedSegmentIndex]) {
        row -= model.CommentList.count;
        if (row < 0) {
            return model.CommentList[row + model.CommentList.count];
        }
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row = 0;
    for(WEModelGeKitchenCommentListPositive *model in _commentListArray[_segment.selectedSegmentIndex]) {
        row += model.CommentList.count;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"MainUserCommentCell";
    MainUserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[MainUserCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    if (_segment.selectedSegmentIndex == 0) {
        cell.showReplyButton = YES;
    } else {
        cell.showReplyButton = NO;
    }
    cell.controller = self;
    id model = [self getModelAtIndexPath:indexPath];
    [cell setData:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self getModelAtIndexPath:indexPath];
    return [MainUserCommentCell getHeightWithData:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)replyButtonTapped:(MainUserCommentCell *)cell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath) {
        WEUserCommentReplyViewController *c = [WEUserCommentReplyViewController new];
        id model = [self getModelAtIndexPath:indexPath];
        c.model = model;
        [self.navigationController pushViewController:c animated:YES];
    }
   
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
