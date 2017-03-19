//
//  PhotoAlbumModel.h
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoAlbumModel : NSObject

@property (nonatomic, copy) NSString *ablumName; //相册名字
@property (nonatomic, assign) NSInteger count; //该相册内相片数量
@property (nonatomic, strong) PHAsset *headImageAsset; //相册第一张图片
@property (nonatomic, strong) PHAssetCollection *assetCollection; //该相册集下所有照片

@end
