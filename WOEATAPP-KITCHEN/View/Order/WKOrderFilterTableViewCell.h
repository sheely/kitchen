//
//  WKOrderFilterTableViewCell.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/23.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDelegate.h"

@interface WKOrderFilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *aNewOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *takenBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *packUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *dispatchBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *eatingTimeBtn;
@property (nonatomic,weak) id<FilterDelegate> delegate;


@end
