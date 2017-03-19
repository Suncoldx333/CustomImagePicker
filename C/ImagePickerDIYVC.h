//
//  ImagePickerDIYVC.h
//  SWCampus
//
//  Created by 11111 on 2017/3/2.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoTool.h"
#import "SwiftModule-Swift.h"
#import "PhotoAlbumModel.h"
#import "ImagePickerView.h"

@interface ImagePickerDIYVC : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver,topicCustomNavDelegate,ImagePickerBottomViewDelegate>

@property (nonatomic,strong) PhotoTool *photoTool;
@property (nonatomic,strong) NSIndexPath *lastIndex;
@property (nonatomic,strong) TopicCustomNav *customNav;
@property (nonatomic,strong) ImagePickerBottomView *bottomView;
@property (nonatomic,strong) ImagePickerView *pickView;

@end
