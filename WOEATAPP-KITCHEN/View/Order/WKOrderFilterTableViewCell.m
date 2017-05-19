//
//  WKOrderFilterTableViewCell.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/10/23.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKOrderFilterTableViewCell.h"

@interface WKOrderFilterTableViewCell ()


@end

@implementation WKOrderFilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _aNewOrderBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    _takenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    _finishedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);

    _payBackBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);

    _packUpBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);

    _dispatchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);

    _orderTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);

    _eatingTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);


}
- (IBAction)newOrderBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _takenBtn.selected = NO;
    _finishedBtn.selected = NO;
    _payBackBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"NEW";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }
}

- (IBAction)takenOrderBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _aNewOrderBtn.selected = NO;
    _finishedBtn.selected = NO;
    _payBackBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"ACCEPTED";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }
}
- (IBAction)finishedOrderBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _aNewOrderBtn.selected = NO;
    _takenBtn.selected = NO;
    _payBackBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"COMPLETED";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }
}
- (IBAction)paybackBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _aNewOrderBtn.selected = NO;
    _takenBtn.selected = NO;
    _finishedBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"REFUNDING";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }
}
- (IBAction)selfPickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _dispatchBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"PICKUP";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }

}
- (IBAction)dispatchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _packUpBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"DELIVER";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }

}

- (IBAction)orderTime:(UIButton *)sender {
    sender.selected = !sender.selected;
    _eatingTimeBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"TIME_ORDERED";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }

}
- (IBAction)eatingTime:(UIButton *)sender {
    sender.selected = !sender.selected;
    _orderTimeBtn.selected = NO;
    NSString *status = @"";
    if (sender.selected) {
        status = @"TIME_REQUESTED";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderStatus:)]) {
        [self.delegate orderStatus:status];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
