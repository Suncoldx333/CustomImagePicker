//
//  ImagePickerCell.h
//  SWCampus
//
//  Created by 11111 on 2017/3/3.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerCell : UICollectionViewCell

@property (nonatomic,strong) UIImage *imageInPHAsset;
@property (nonatomic,strong) UIImageView *imageviewInPHAsset;
@property (nonatomic,strong) UIView *frontView;
@property (nonatomic,strong) NSString *imageCellTag;

@end
