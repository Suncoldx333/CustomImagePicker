//
//  FilterListCell.m
//  SWCampus
//
//  Created by 11111 on 2017/3/8.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "FilterListCell.h"

@implementation FilterListCell

@synthesize filterImageView,filterNameLabel;
@synthesize cellIndex;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.contentView.clipsToBounds = YES;
    CGFloat cellWidth = ceil(ScreenWidth / 375.000 * 100.000);
    
    CGFloat labelY = ((ScreenHeight - 64.5 - ScreenWidth - 40.5) - 12.5 - 10 - cellWidth)/2;
    
    filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, cellWidth, 10)];
    filterNameLabel.textColor = hexColor(0x333333);
    filterNameLabel.font = [UIFont systemFontOfSize:10];
    filterNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:filterNameLabel];
    
    filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelY + 10  + 12.5, cellWidth, cellWidth)];
    filterImageView.contentMode = UIViewContentModeScaleAspectFill;
    filterImageView.clipsToBounds = YES;
    [self.contentView addSubview:filterImageView];
    
}

-(void)setFilterImage:(UIImage *)filterImage{
    _filterImage = filterImage;
    filterImageView.image = _filterImage;
}

@end
