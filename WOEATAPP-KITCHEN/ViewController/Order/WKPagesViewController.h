//
//  ELEPagesViewController.h
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/25.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiplePagesViewControllerDelegate <NSObject>
- (void)pageChangedTo:(NSInteger)pageIndex;
@end

@interface WKPagesViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, weak) id<MultiplePagesViewControllerDelegate> delegate;
- (void)addViewController:(UIViewController*)viewController;
- (void)removeViewController:(NSUInteger)viewControllerIndex;

@end
