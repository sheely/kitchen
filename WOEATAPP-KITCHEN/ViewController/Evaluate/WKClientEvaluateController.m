//
//  WKClientEvaluateController.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKClientEvaluateController.h"
#import "WKWatiReplyCell.h"
#import "WKReplyClientController.h"
#import "WKEvaluate.h"
#import "WEGlobalData.h"

@interface WKClientEvaluateController ()<UITableViewDataSource,UITableViewDelegate,WKWatiReplyCellDelegate>

@property (nonatomic, strong) UITableView *evaluateTableView;
@property (nonatomic, strong) UIButton *btnWaitReply;
@property (nonatomic, strong) UIButton *btnGoodEva;
@property (nonatomic, strong) UIButton *btnMediumEva;
@property (nonatomic, strong) UIButton *btnBadEva;
@property (nonatomic, strong) NSMutableArray *waitEvaluateArray;
@property (nonatomic, strong) NSMutableArray *positiveEvaluateArray;
@property (nonatomic, strong) NSMutableArray *mediumEvaluateArray;
@property (nonatomic, strong) NSMutableArray *badEvaluateArray;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSString *strEvaluateType;//待回复、好评、中评、差评

@end

@implementation WKClientEvaluateController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _waitEvaluateArray = [NSMutableArray array];
    _positiveEvaluateArray = [NSMutableArray array];
    _mediumEvaluateArray = [NSMutableArray array];
    _badEvaluateArray = [NSMutableArray array];
    self.strEvaluateType = @"wait";

    [self.view addSubview:self.btnWaitReply];
    [self.view addSubview:self.btnGoodEva];
    [self.view addSubview:self.btnMediumEva];
    [self.view addSubview:self.btnBadEva];
    [self.view addSubview:self.evaluateTableView];
    self.title = @"饭友评价";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestAllCommentList];
}

- (UITableView *)evaluateTableView
{
    if (_evaluateTableView == nil) {
        CGFloat originY = CGRectGetMaxY(self.btnWaitReply.frame) + 10;
        _evaluateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, screen_width, screen_height - originY) style:UITableViewStylePlain];
        _evaluateTableView.dataSource = self;
        _evaluateTableView.delegate = self;
        _evaluateTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _evaluateTableView.separatorColor = [UIColor lightGrayColor];
        _evaluateTableView.tableFooterView = [[UIView alloc] init];
        if ([_evaluateTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_evaluateTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _evaluateTableView;
}

- (UIButton *)btnWaitReply
{
    if (_btnWaitReply == nil) {
        CGFloat originX = 10;
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10;
        CGFloat width = (screen_width - 20) / 4.0;
        _btnWaitReply = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, 40)];
        _btnWaitReply.titleLabel.numberOfLines = 0;
        _btnWaitReply.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btnWaitReply setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
        _btnWaitReply.tag = 1001;
        NSString *string = @"待回复\n0";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:15.0],NSFontAttributeName,
                                       [UIColor blackColor],NSForegroundColorAttributeName,nil];
        NSRange range = [string rangeOfString:@"待回复"];
        [attributeString addAttributes:attributeDict range:range];
        
        attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                         [UIColor redColor],NSForegroundColorAttributeName,nil];
        range = [string rangeOfString:@"0"];
        [attributeString addAttributes:attributeDict range:range];
        _btnWaitReply.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnWaitReply.layer.borderWidth = 1.0;
        [_btnWaitReply setAttributedTitle:attributeString forState:UIControlStateNormal];
        [_btnWaitReply addTarget:self action:@selector(chooseEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnWaitReply;
}

- (UIButton *)btnGoodEva
{
    if (_btnGoodEva == nil) {
        CGFloat originX = CGRectGetMaxX(self.btnWaitReply.frame);
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10;
        CGFloat width = (screen_width - 20) / 4.0;
        _btnGoodEva = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, 40)];
        _btnGoodEva.titleLabel.numberOfLines = 0;
        _btnGoodEva.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnGoodEva.tag = 1002;
        NSString *string = @"好评\n0";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                       [UIColor blackColor],NSForegroundColorAttributeName,nil];
        NSRange range = [string rangeOfString:@"好评"];
        [attributeString addAttributes:attributeDict range:range];
        
        attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                         [UIColor redColor],NSForegroundColorAttributeName,nil];
        range = [string rangeOfString:@"0"];
        [attributeString addAttributes:attributeDict range:range];
        
        _btnGoodEva.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnGoodEva.layer.borderWidth = 1.0;

        [_btnGoodEva setAttributedTitle:attributeString forState:UIControlStateNormal];
        [_btnGoodEva addTarget:self action:@selector(chooseEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnGoodEva;
}

- (UIButton *)btnMediumEva
{
    if (_btnMediumEva == nil) {
        CGFloat originX = CGRectGetMaxX(self.btnGoodEva.frame);
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10;
        CGFloat width = (screen_width - 20) / 4.0;
        _btnMediumEva = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, 40)];
        _btnMediumEva.titleLabel.numberOfLines = 0;
        _btnMediumEva.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnMediumEva.tag = 1003;
        NSString *string = @"中评\n0";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:15.0],NSFontAttributeName,
                                       [UIColor blackColor],NSForegroundColorAttributeName,nil];
        NSRange range = [string rangeOfString:@"中评"];
        [attributeString addAttributes:attributeDict range:range];
        
        attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                       [UIColor redColor],NSForegroundColorAttributeName,nil];
        range = [string rangeOfString:@"0"];
        [attributeString addAttributes:attributeDict range:range];
        
        _btnMediumEva.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnMediumEva.layer.borderWidth = 1.0;

        [_btnMediumEva setAttributedTitle:attributeString forState:UIControlStateNormal];
        [_btnMediumEva addTarget:self action:@selector(chooseEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMediumEva;
}

- (UIButton *)btnBadEva
{
    if (_btnBadEva == nil) {
        CGFloat originX = CGRectGetMaxX(self.btnMediumEva.frame);
        CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10;
        CGFloat width = (screen_width - 20) / 4.0;
        _btnBadEva = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, 40)];
        [_btnBadEva setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        _btnBadEva.titleLabel.numberOfLines = 0;
        _btnBadEva.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnBadEva.tag = 1004;
        NSString *string = @"差评\n0";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                       [UIColor blackColor],NSForegroundColorAttributeName,nil];
        NSRange range = [string rangeOfString:@"差评"];
        [attributeString addAttributes:attributeDict range:range];
        
        attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                         [UIColor redColor],NSForegroundColorAttributeName,nil];
        range = [string rangeOfString:@"0"];
        [attributeString addAttributes:attributeDict range:range];

        _btnBadEva.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnBadEva.layer.borderWidth = 1.0;
        [_btnBadEva setAttributedTitle:attributeString forState:UIControlStateNormal];
        [_btnBadEva addTarget:self action:@selector(chooseEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBadEva;
}

- (void)updateButtonTitle
{
    [self updateButtonTitle:self.btnWaitReply type:@"待回复" count:self.waitEvaluateArray.count];
    [self updateButtonTitle:self.btnGoodEva type:@"好评" count:self.positiveEvaluateArray.count];
    [self updateButtonTitle:self.btnMediumEva type:@"中评" count:self.mediumEvaluateArray.count];
    [self updateButtonTitle:self.btnBadEva type:@"差评" count:self.badEvaluateArray.count];
}

- (void)updateButtonTitle:(UIButton *)button type:(NSString *)type count:(NSInteger)count
{
    NSString *string = [NSString stringWithFormat:@"%@\n%ld",type,(long)count];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                   [UIColor blackColor],NSForegroundColorAttributeName,nil];
    NSRange range = [string rangeOfString:type];
    [attributeString addAttributes:attributeDict range:range];
    
    attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                     [UIColor redColor],NSForegroundColorAttributeName,nil];
    range = [string rangeOfString:[NSString stringWithFormat:@"%ld",(long)count]];
    [attributeString addAttributes:attributeDict range:range];
    [button setAttributedTitle:attributeString forState:UIControlStateNormal];
}

- (void)requestAllCommentList
{
    WKUserInfo *account = [WKKeyChain loadUserInfo:kAPPSecurityStoreKey];
    WEGlobalData *data = [WEGlobalData sharedInstance];
    NSString *kitchenId = data.cacheMyKitchen.Kitchen.Id;
    
    
    //待回复
    [self requestCommentList:@"v1/Comment/GeKitchenCommentListToReply"
                      userId:kitchenId.integerValue
                        type:@"WAIT"];
    //好评
    [self requestCommentList:@"v1/Comment/GeKitchenCommentListPositive"
                      userId:kitchenId.integerValue
                        type:@"POSITIVE"];
    //中评
    [self requestCommentList:@"v1/Comment/GeKitchenCommentListNeutral"
                      userId:kitchenId.integerValue
                        type:@"NEUTRAL"];
    //差评
    [self requestCommentList:@"v1/Comment/GeKitchenCommentListNegative"
                      userId:kitchenId.integerValue
                        type:@"NEGATIVE"];
}

- (void)requestCommentList:(NSString *)path
                    userId:(NSInteger)userId
                      type:(NSString *)type
{

//    NSDictionary *param = @{@"ModelFilter":@{@"ObjectType":@"SALES_ORDER",@"UserId":@(userId)},
//                            @"PageFilter":@{@"PageIndex":@(self.pageIndex),@"Pagesize":@(15)}};
    //NSDictionary *param = @{@"ModelFilter":@{@"ObjectType":@"SALES_ORDER"},
      //                     @"PageFilter":@{@"PageIndex":@(self.pageIndex),@"Pagesize":@(15)}};
    NSDictionary *param = @{@"PageIndex":@(self.pageIndex),@"Pagesize":@(15)};
    [[WKNetworkManager sharedAuthManager] POST:path responseInMainQueue:YES parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *resultArray = responseObject[@"CommentList"];
                if (resultArray.count > 0) {
                    for (NSDictionary *dic in resultArray) {
                        WKEvaluate *evaluate = [[WKEvaluate alloc] init];
                        evaluate.evaluateId = dic[@"Id"];
                        evaluate.objectId = dic[@"ObjectId"];
                        evaluate.objectType = dic[@"ObjectType"];
                        evaluate.fromUserId = dic[@"ByUserId"];
                        evaluate.type = dic[@"Positive"];
                        evaluate.message = dic[@"Message"];
                        evaluate.createTime = dic[@"TimeCreated"];
                        evaluate.userName = dic[@"UserDisplayName"];
                        evaluate.userAvatarID = dic[@"UserPortraitId"];
                        evaluate.userAvatar = dic[@"UserPortraitUrl"];
                        evaluate.replyMessage = dic[@"Reply"];
                        if ([type isEqualToString:@"WAIT"]) {
                            [self.waitEvaluateArray addObject:evaluate];
                        }else if ([type isEqualToString:@"POSITIVE"]) {
                            [self.positiveEvaluateArray addObject:evaluate];
                        }else if ([type isEqualToString:@"NEUTRAL"]) {
                            [self.mediumEvaluateArray addObject:evaluate];
                        }else if ([type isEqualToString:@"NEGATIVE"]) {
                            [self.badEvaluateArray addObject:evaluate];
                        }
                    }
                }
            }
            [self updateButtonTitle];
            [self.evaluateTableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息 -> %@",error);
        [YRToastView hide];
        
    }];
}

#pragma mark- button event
- (void)chooseEvaluate:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    switch (tag) {
        case 1001:
            self.strEvaluateType = @"wait";
            [self.btnWaitReply setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
            [self.btnGoodEva setBackgroundColor:[UIColor whiteColor]];
            [self.btnMediumEva setBackgroundColor:[UIColor whiteColor]];
            [self.btnBadEva setBackgroundColor:[UIColor whiteColor]];
            break;
        case 1002:
            self.strEvaluateType = @"positive";
            [self.btnWaitReply setBackgroundColor:[UIColor whiteColor]];
            [self.btnGoodEva setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
            [self.btnMediumEva setBackgroundColor:[UIColor whiteColor]];
            [self.btnBadEva setBackgroundColor:[UIColor whiteColor]];
            break;
        case 1003:
            self.strEvaluateType = @"medium";
            [self.btnWaitReply setBackgroundColor:[UIColor whiteColor]];
            [self.btnGoodEva setBackgroundColor:[UIColor whiteColor]];
            [self.btnMediumEva setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
            [self.btnBadEva setBackgroundColor:[UIColor whiteColor]];
            break;
        default:
            self.strEvaluateType = @"bad";
            [self.btnWaitReply setBackgroundColor:[UIColor whiteColor]];
            [self.btnGoodEva setBackgroundColor:[UIColor whiteColor]];
            [self.btnMediumEva setBackgroundColor:[UIColor whiteColor]];
            [self.btnBadEva setBackgroundColor:[UIColor colorWithHexString:@"#8B8663" andAlpha:1.0]];
            break;
    }
    [self.evaluateTableView reloadData];
}

#pragma mark- tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.strEvaluateType isEqualToString:@"wait"]) {
        return self.waitEvaluateArray.count;
    }else if ([self.strEvaluateType isEqualToString:@"positive"]) {
        return self.positiveEvaluateArray.count;
    }else if ([self.strEvaluateType isEqualToString:@"medium"]) {
        return self.mediumEvaluateArray.count;
    }else{// if ([self.strEvaluateType isEqualToString:@"bad"])
        return self.badEvaluateArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    WKWatiReplyCell *replyCell = [[WKWatiReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"replyCell"];
    replyCell.delegate = self;
    cell = replyCell;
    WKEvaluate *evaluate;
    if ([self.strEvaluateType isEqualToString:@"wait"]) {
        evaluate = self.waitEvaluateArray[indexPath.row];
    }else if ([self.strEvaluateType isEqualToString:@"positive"]) {
        evaluate = self.positiveEvaluateArray[indexPath.row];
    }else if ([self.strEvaluateType isEqualToString:@"medium"]) {
        evaluate = self.mediumEvaluateArray[indexPath.row];
    }else{// if ([self.strEvaluateType isEqualToString:@"bad"])
        evaluate = self.badEvaluateArray[indexPath.row];
    }
    [replyCell loadData:evaluate];
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)replyClientEvaluate:(WKEvaluate *)evaluate
{
    WKReplyClientController *replyController = [[WKReplyClientController alloc]init];
    replyController.evaluate = evaluate;
    [self.navigationController pushViewController:replyController animated:YES];
}
@end
