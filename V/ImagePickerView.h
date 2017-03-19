//
//  ImagePickerView.h
//  SWCampus
//
//  Created by 11111 on 2017/3/8.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PhotoTool.h"
#import "SWCHelpCenter.h"

@interface ImagePickerView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *chosenImageBGView;
@property (nonatomic,strong) UIImageView *chosenImage;
@property (nonatomic,strong) UICollectionView *albumCollectionView;

@property (nonatomic,strong) NSMutableArray<PHAsset *> *photoAssetArr;
@property (nonatomic,strong) NSMutableArray<PHAsset *> *givenArr;
@property (nonatomic,strong) PhotoTool *photoManage;
@property (nonatomic,strong) NSIndexPath *lastIndex;
@property (nonatomic) BOOL isPickViewUp;
@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic) CGRect preFrame;
@property (nonatomic) CGRect curFrame;

-(NSData *)cutImageInBgView;

@end
