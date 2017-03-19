//
//  AlbumListCell.h
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumModel.h"
#import "PhotoTool.h"

@interface AlbumListCell : UITableViewCell

@property (nonatomic,strong) PhotoAlbumModel *model;
@property (nonatomic,strong) UIImageView *firstImage;
@property (nonatomic,strong) UILabel *albumInfoLabel;
@property (nonatomic,strong) NSString *albumTag;

@end
