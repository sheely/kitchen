//
//  WKMenuCoverCell.m
//  WOEATAPP-KITCHEN
//
//  Created by tamony on 2016/10/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "WKMenuCoverCell.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+WebCache.h"
@implementation WKMenuCoverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:[self creatViewWithTitle:@"* 菜品照片（最多4张）"]];
    }
    return self;
}

- (void)loadImages:(NSArray *)images
{
    NSInteger maxCount = images.count + 1;
    if (maxCount > 4) {
        maxCount = 4;
    }
    for (NSInteger i = 0; i < maxCount; i++) {
        CGFloat width = (screen_width - 10 * 5) / 4;
        CGFloat originX = 10 + i * (width + 10);
        

        if (images.count > 0 && i < images.count) {
            NSString *url = images[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 40, width, width)];
            if (url.length > 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed];
                
            }else{
                [imageView setImage:[UIImage imageNamed:@"meishi"]];
            }
            [self addSubview:imageView];
        }else{
            UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(originX, 40, width, width)];
            [addButton setBackgroundColor:[UIColor lightGrayColor]];
            [addButton setImage:[UIImage imageNamed:@"ic_my_addpic"] forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(addPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addButton];
        }
        
    }
}

- (UIView *)creatViewWithTitle:(NSString *)title
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7" andAlpha:1.0];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width - 40, 30)];
    labTitle.text = title;
    labTitle.textColor = [UIColor blackColor];
    [backView addSubview:labTitle];
    return backView;
}


-(void)setPhotos:(NSArray *)photos{
    
    _photos = photos;
    for (int i = 0 ; i< 4; i++) {
        UIImageView *imageview = (UIImageView*)[self viewWithTag:2000 + i + 1];
        if (imageview) {
            [imageview setImage:[UIImage imageNamed:@""]];
        }
    }
    for (int i = 0 ; i< _photos.count; i++) {
        UIImageView *imageview = (UIImageView*)[self viewWithTag:2000 + i + 1];
        [imageview setImage:[UIImage imageNamed:photos[i]]];
        [imageview setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"ic_ht_default_small_loading_error"]];
    }
    //    [self layoutIfNeeded];
}

-(void)addPhotoAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMenuAddButtonClick:)]) {
        [self.delegate didMenuAddButtonClick:self];
    }
}


@end
