//
//  AlbumListView.m
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "AlbumListView.h"
#import "AlbumListCell.h"

@implementation AlbumListView

@synthesize albumTableView;
@synthesize dataArr;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    dataArr = [[NSMutableArray alloc] init];
    
    self.backgroundColor = hexColor(0xffffff);
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64.5);
    
    albumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ViewHeight(self)) style:UITableViewStyleGrouped];
    albumTableView.backgroundColor = hexColor(0xffffff);
    albumTableView.delegate = self;
    albumTableView.dataSource = self;
    albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:albumTableView];
    
}

-(void)enterAnimation{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = CGRectMake(0, 64.5, ScreenWidth, ScreenHeight - 64.5);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"done");
                         [self.delegate listEnterAnimatinDone];
                     }];
}

-(void)exitAnimation{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64.5);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"done");
                         [self.delegate listExitAnimatinDone];
                     }];
}

-(void)setGivenArr:(NSMutableArray<PhotoAlbumModel *> *)givenArr{
    _givenArr = givenArr;
    dataArr = [givenArr mutableCopy];
    [albumTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == dataArr.count - 1) {
        return 15;
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"albumListCell";
    AlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[AlbumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = [dataArr objectAtIndex:indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *albumTag = cell.albumTag;
    [self.delegate AlbumListCellClick:albumTag];
    [self exitAnimation];

}

@end
