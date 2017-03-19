//
//  AlbumListView.h
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumModel.h"

@protocol AlbumListViewDelegate <NSObject>

-(void)AlbumListCellClick:(NSString *)albumTag;
-(void)listEnterAnimatinDone;
-(void)listExitAnimatinDone;

@end

@interface AlbumListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *albumTableView;
@property (nonatomic,strong) NSMutableArray<PhotoAlbumModel *> *dataArr;
@property (nonatomic,strong) NSMutableArray<PhotoAlbumModel *> *givenArr;
@property (nonatomic,weak) id<AlbumListViewDelegate> delegate;

-(void)enterAnimation;
-(void)exitAnimation;

@end
