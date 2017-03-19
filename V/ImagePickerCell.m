//
//  ImagePickerCell.m
//  SWCampus
//
//  Created by 11111 on 2017/3/3.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickerCell.h"

@implementation ImagePickerCell

@synthesize imageviewInPHAsset;
@synthesize frontView;
@synthesize imageCellTag;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initUI{
    
    self.contentView.clipsToBounds = YES;
    self.backgroundColor = [hexColor(0xff4438) colorWithAlphaComponent:0.2];
    
    imageviewInPHAsset = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth - 3)/4, (ScreenWidth - 3)/4)];
    imageviewInPHAsset.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageviewInPHAsset];
    
    frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth - 3)/4, (ScreenWidth - 3)/4)];
    frontView.hidden = YES;
    frontView.backgroundColor = [hexColor(0xffffff) colorWithAlphaComponent:0.7];
    [self.contentView addSubview:frontView];
}

-(void)setImageInPHAsset:(UIImage *)imageInPHAsset{
    _imageInPHAsset = imageInPHAsset;
    imageviewInPHAsset.image = _imageInPHAsset;
}

@end
