//
//  FilterListCell.h
//  SWCampus
//
//  Created by 11111 on 2017/3/8.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterListCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *filterImageView;
@property (nonatomic,strong) UIImage *filterImage;
@property (nonatomic,strong) UILabel *filterNameLabel;
@property (nonatomic) NSInteger cellIndex;

@end
