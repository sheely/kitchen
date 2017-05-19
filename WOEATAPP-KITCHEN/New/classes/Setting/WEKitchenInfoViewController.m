//
//  WEKitchenInfoViewController.m
//  WOEATAPP-KITCHEN
//
//  Created by liubin on 17/1/31.
//  Copyright © 2017年 com.woeat-inc. All rights reserved.
//

#import "WEKitchenInfoViewController.h"
#import "WEUtil.h"
#import "WEModelGetMyKitchen.h"
#import "WEGlobalData.h"

#define OFFSET_X  30

@interface WEKitchenInfoViewController ()
{
    UITableView *_tableView;
}
@end

@implementation WEKitchenInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"厨房信息";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UIImage *img = [UIImage imageNamed:@"icon_warning"];
    UIImageView *imgView = [UIImageView new];
    imgView.image = img;
    [superView addSubview:imgView];
    float scale = 0.5;
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(15);
        make.left.equalTo(superView.left).offset(OFFSET_X);
        make.width.equalTo(img.size.width*scale);
        make.height.equalTo(img.size.height*scale);
    }];
    
    UILabel *tip = [UILabel new];
    tip.textColor = [UIColor blackColor];
    tip.font = [UIFont boldSystemFontOfSize:13];
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    [superView addSubview:tip];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgView.centerY);
        make.left.equalTo(imgView.right).offset(5);
        make.right.equalTo(superView.right).offset(-50);
        make.height.equalTo(tip.font.lineHeight*2+1);
    }];
    tip.text = @"厨房信息提交后不可编辑。如果要变更厨房信息，请联系WOEAT客服重新审核";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.bottom).offset(20);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _tableView = tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    WEModelGetMyKitchen *model = [WEGlobalData sharedInstance].cacheMyKitchen;
    
    if (indexPath.section < 3) {
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UICOLOR(180, 180, 180);
        label.font = [UIFont systemFontOfSize:15];
        [superView addSubview:label];
        [label sizeToFit];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(OFFSET_X);
            make.centerY.equalTo(superView.centerY);
        }];
        
        if (indexPath.section == 0) {
            label.text = model.Kitchen.Name;
        } else if (indexPath.section == 1) {
            label.text = model.Kitchen.ChefUsername;
        } else if (indexPath.section == 2) {
            label.text = model.Kitchen.ChefGender;
        }
    
    } else {
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UICOLOR(180, 180, 180);
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        [superView addSubview:label];
        [label sizeToFit];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(OFFSET_X);
            make.centerY.equalTo(superView.centerY);
        }];
        NSString *s = [NSString stringWithFormat:@"%@\n%@,%@\n%@",
                       model.Kitchen.AddressLine1, model.Kitchen.City, model.Kitchen.State,model.Kitchen.Postcode];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:s];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 10; //设置行间距
        paragraphStyle.hyphenationFactor = 1.0;
        paragraphStyle.firstLineHeadIndent = 0.0;
        paragraphStyle.paragraphSpacingBefore = 0.0;
        paragraphStyle.headIndent = 0;
        paragraphStyle.tailIndent = 0;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [s length])];
        label.attributedText = attributedString;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 100;
    }
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(247, 247, 247);
    float height = [self tableView:_tableView heightForHeaderInSection:0];
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth],height);
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:13];
    label.frame = CGRectMake(OFFSET_X, 0, 200, height);
    [bg addSubview:label];
    if (section == 0) {
        label.text = @"厨房名称";
    } else if (section == 1) {
        label.text = @"大厨昵称";
    } else if (section == 2) {
        label.text = @"大厨性别";
    } else if (section == 3) {
        label.text = @"厨房地址";
    }
    return bg;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
