//
//  ImagePickerFilterVC.h
//  SWCampus
//
//  Created by 11111 on 2017/3/7.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "BaseViewController.h"
#import "SwiftModule-Swift.h"
#import <CoreImage/CoreImage.h>

@interface ImagePickerFilterVC : BaseViewController<topicCustomNavDelegate,ImagePickerBottomViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) TopicCustomNav *customNav;
@property (nonatomic,strong) ImagePickerBottomView *bottomView;

-(void)fillBGViewWith:(NSData *)imageData;

@end
