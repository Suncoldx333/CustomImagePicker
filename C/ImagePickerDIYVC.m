//
//  ImagePickerDIYVC.m
//  SWCampus
//
//  Created by 11111 on 2017/3/2.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickerDIYVC.h"
#import <Photos/Photos.h>
#import "ImagePickerCell.h"
#import "AlbumListView.h"
#import "SWCHelpCenter.h"
#import "ImagePickerFilterVC.h"

#define HorizontalBoundray 8.000 / 15.000 * ScreenWidth
#define VerticalBoundray 4.000 / 5.000 * ScreenWidth

@interface ImagePickerDIYVC ()<AlbumListViewDelegate>

@property (nonatomic,strong) UICollectionView *libPicsCollectionView;
@property (nonatomic) BOOL photoLibjurisdiction; //相册访问权限
@property (nonatomic,strong) NSMutableArray<PHAsset *> *photoAssetArr;
@property (nonatomic,strong) UIImageView *chosenImage;
@property (nonatomic,strong) NSString *albumName;
@property (nonatomic,strong) AlbumListView *listView;
@property (nonatomic) CGRect preFrame;
@property (nonatomic) CGRect curFrame;
@property (nonatomic,strong) UIView *chosenImageBgView;
@property (nonatomic) BOOL showListView;  //当前展示的是相册列表

@end

@implementation ImagePickerDIYVC

@synthesize photoTool;
@synthesize lastIndex;
@synthesize customNav,bottomView;
@synthesize pickView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.chosenImage removeFromSuperview];
}

#pragma mark -初始化数据
-(void)initData{
    //相册管理
    photoTool = [PhotoTool sharePhotoTool];
    self.photoLibjurisdiction = [photoTool getPhotoAblumJurisdictionStatus];
    
    //获取第一个相册数据对象
    PhotoAlbumModel *firstModel = [[photoTool getPhotoAblumList] objectAtIndex:0];
    
    for (PhotoAlbumModel *model in [photoTool getPhotoAblumList]) {
        NSString *name = model.ablumName;
        NSLog(@"name=%@",name);
    }
    
    //第一个相册内的所有照片数据
    PHAssetCollection *firstCollection = firstModel.assetCollection;
    self.photoAssetArr = [[photoTool getAllAssetIn:firstCollection ByAscending:NO] mutableCopy];
    
    //第一个相册的名字
    self.albumName = firstModel.ablumName;
}

#pragma mark -初始化界面
-(void)initUI{
    
    self.view.backgroundColor = hexColor(0xe6e6e6);
    
    //导航栏
    customNav = [[TopicCustomNav alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44.5)];
    customNav.delegate = self;
    customNav.rightTitle = @"image";
    customNav.centerLabel.attributedText = [self createAlbumNameAtrr:self.albumName inOpen:YES];
    customNav.centerView.userInteractionEnabled = YES;
    [self.view addSubview:customNav];
    
    CGFloat collectionHeight = ScreenHeight - 70.5 - 40.5;
    pickView = [[ImagePickerView alloc] initWithFrame:CGRectMake(0, 64.5, ScreenWidth, ScreenWidth + 0.5 + collectionHeight)];
    [self.view addSubview:pickView];
    pickView.givenArr = self.photoAssetArr;
    
    //选中的图片
    self.chosenImageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 0.5, ScreenWidth, ScreenWidth)];
    self.chosenImageBgView.clipsToBounds = YES;
    self.chosenImageBgView.backgroundColor = hexColor(0xffffff);
//    [self.view addSubview:self.chosenImageBgView];
    
    self.chosenImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    self.chosenImage.contentMode = UIViewContentModeScaleAspectFill;
    self.chosenImage.clipsToBounds = YES;
    self.chosenImage.userInteractionEnabled = YES;
    PHAsset *asset = [self.photoAssetArr objectAtIndex:0];
    [photoTool createImageBy:asset
                          In:[photoTool geiSizeAbout:asset]
                    andBlock:^(NSData *data, NSDictionary *info) {
                        UIImage *originalImage = [[UIImage alloc] initWithData:data];
                        self.chosenImage.image = [self changeImageFrame:originalImage];
                        [self.chosenImage sizeToFit];
                        
                        self.chosenImage.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
                        NSLog(@"x=%f,y=%f,w=%f,h=%f",self.chosenImage.frame.origin.x,self.chosenImage.frame.origin.y,self.chosenImage.frame.size.width,self.chosenImage.frame.size.height);
                        self.preFrame = self.chosenImage.frame;
                    }];
//    [self.chosenImageBgView addSubview:self.chosenImage];
    
    UIPanGestureRecognizer *chosenImagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePan:)];
    [self.chosenImage addGestureRecognizer:chosenImagePan];
    
    UIPinchGestureRecognizer *chosenImagePin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imagePin:)];
    [self.chosenImage addGestureRecognizer:chosenImagePin];
    
    //图库图片
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGFloat photoLine = ceil(self.photoAssetArr.count/4);
    CGFloat cellHeight = (ScreenWidth - 3)/4;
    CGFloat collectionViewheight = photoLine * cellHeight + (photoLine - 1) * 1;
    self.libPicsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 0.5 + ScreenWidth + 0.5, ScreenWidth, collectionViewheight) collectionViewLayout:flowLayout];
    [self.libPicsCollectionView registerClass:[ImagePickerCell class]
                   forCellWithReuseIdentifier:@"ImagePickerCell"];
    self.libPicsCollectionView.backgroundColor = hexColor(0xffffff);
    self.libPicsCollectionView.dataSource = self;
    self.libPicsCollectionView.delegate = self;
    self.libPicsCollectionView.scrollEnabled = NO;
//    [self.view addSubview:self.libPicsCollectionView];
    
    //底部选择按钮
    bottomView = [[ImagePickerBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40.5, ScreenWidth, 40.5)];
    bottomView.delegate = self;
    bottomView.bottomViewTypeOpen = 0;
    [self.view addSubview:bottomView];
    
    //相册列表
    self.listView = [[AlbumListView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64.5)];
    self.listView.givenArr = [[photoTool getPhotoAblumList] mutableCopy];
    self.listView.delegate = self;
    [self.view addSubview:self.listView];
}

#pragma mark -私有方法
//选中的图片拖动事件
-(void)imagePan:(UIPanGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    
    CGPoint oldPoint = imageView.center;
    CGPoint newPoint = [sender translationInView:self.chosenImageBgView];

    CGFloat newX = oldPoint.x + newPoint.x;
    CGFloat newY = oldPoint.y + newPoint.y;
    
    if (newX > width/2) {
        if (width > ScreenWidth) {
            newX = width/2;
        }else{
            if (newX > ScreenWidth - width/2) {
                newX = ScreenWidth - width/2;
            }
        }
    }else if (newX < ScreenWidth - width/2){
        if (width > ScreenWidth) {
            newX = ScreenWidth - width/2;
        }else{
            newX = width/2;
        }
    }
    
    if (newY > height/2){
        if (height > ScreenWidth) {
            newY = height/2;
        }else{
            if (newY > ScreenWidth - height/2) {
                newY = ScreenWidth - height/2;
            }
        }
    }else if (newY < ScreenWidth - height/2){
        if (height > ScreenWidth) {
            newY = ScreenWidth - height/2;
        }else{
            newY = height/2;
        }
    }
    
    imageView.center = CGPointMake(newX, newY);
    [sender setTranslation:CGPointZero inView:self.chosenImageBgView];
    
    self.preFrame = imageView.frame;
}

//选中的图片缩小/放大事件
-(void)imagePin:(UIPinchGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    
    CGFloat width = self.preFrame.size.width * sender.scale;
    CGFloat height = self.preFrame.size.height * sender.scale;
    
    imageView.frame = CGRectMake(CGRectGetMidX(self.preFrame) - width / 2, CGRectGetMidY(self.preFrame) - height / 2, width, height);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if ((width > height && height < HorizontalBoundray) || (width > height && width < ScreenWidth)) {
            
            CGFloat newScale = HorizontalBoundray / imageView.frame.size.height;
            CGFloat newWidth = imageView.frame.size.width * newScale;
            CGFloat newHeight = imageView.frame.size.height * newScale;
            
            if (width < ScreenWidth) {
                CGFloat newScaleMore = ScreenWidth / imageView.frame.size.width;
                newWidth = imageView.frame.size.width * newScaleMore;
                newHeight = imageView.frame.size.height * newScaleMore;
                if (newHeight < HorizontalBoundray) {
                    newWidth = imageView.frame.size.width * newScale;
                    newHeight = imageView.frame.size.height * newScale;
                }
            }
            
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 imageView.frame = CGRectMake(CGRectGetMidX(imageView.frame) - newWidth / 2, CGRectGetMidY(imageView.frame) - newHeight / 2, newWidth, newHeight);
                             }
                             completion:^(BOOL finished) {
                                 NSLog(@"done");
                                 imageView.center = CGPointMake(ViewWidth(self.chosenImageBgView)/2, ViewWidth(self.chosenImageBgView)/2);
                             }];
        }else if ((width < height && width < VerticalBoundray) || (width < height && height < ScreenWidth)){
            CGFloat newScale = VerticalBoundray / imageView.frame.size.width;
            CGFloat newWidth = imageView.frame.size.width * newScale;
            CGFloat newHeight = imageView.frame.size.height * newScale;
            
            if (height < ScreenWidth) {
                CGFloat newScaleMore = ScreenWidth / imageView.frame.size.height;
                newWidth = imageView.frame.size.width * newScaleMore;
                newHeight = imageView.frame.size.height * newScaleMore;
                if (newWidth < VerticalBoundray) {
                    newWidth = imageView.frame.size.width * newScale;
                    newHeight = imageView.frame.size.height * newScale;
                }
            }
            
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 imageView.frame = CGRectMake(CGRectGetMidX(imageView.frame) - newWidth / 2, CGRectGetMidY(imageView.frame) - newHeight / 2, newWidth, newHeight);
                             }
                             completion:^(BOOL finished) {
                                 NSLog(@"done");
                                 imageView.center = CGPointMake(ViewWidth(self.chosenImageBgView)/2, ViewWidth(self.chosenImageBgView)/2);
                             }];
        }
        
        self.preFrame = imageView.frame;
    }
}

//导航栏中间富文本设置
-(NSMutableAttributedString *)createAlbumNameAtrr:(NSString *)name inOpen:(BOOL)state{
    NSString *title = [NSString stringWithFormat:@"%@ ",name];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSMutableDictionary *space = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:5.f],NSKernAttributeName, nil];
    
    [attr addAttributes:space range:NSMakeRange(title.length - 2, 1)];
    
    NSTextAttachment *imageAttch = [[NSTextAttachment alloc] init];
    if (state) {
        imageAttch.image = [UIImage imageNamed:@"1608OpenAlbum"];
    }else{
        imageAttch.image = [UIImage imageNamed:@"1608CloseAlbum"];
    }
    imageAttch.bounds = CGRectMake(0, 2.5, 8, 4);
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:imageAttch];
    
    [attr insertAttributedString:imageAttr atIndex:title.length - 1];
    return attr;
}

//修改选中的图片的尺寸
-(UIImage *)changeImageFrame:(UIImage *)curImage{
    UIImage *newImage;
    
    CGFloat width = curImage.size.width * 1.000;
    CGFloat height = curImage.size.height * 1.000;
    
    CGFloat minValue = width > height ? height : width;
    BOOL widthMin = width > height ? NO : YES;
    
    if (minValue > 200) {
        if (widthMin) {
            CGFloat newHeight = ceil(height / width * ScreenWidth);
            newImage = [SWCHelpCenter changeImage:curImage toSize:CGSizeMake(ScreenWidth, newHeight)];
        }else{
            CGFloat newWidth = ceil(width / height * ScreenWidth);
            newImage = [SWCHelpCenter changeImage:curImage toSize:CGSizeMake(newWidth, ScreenWidth)];
        }
    }else{
        CGFloat newOriginal = ceil(8.000 / 15.000 * ScreenWidth);
        if (widthMin) {
            CGFloat newHeight = ceil(height / width * newOriginal);
            newImage = [SWCHelpCenter changeImage:curImage toSize:CGSizeMake(newOriginal, newHeight)];
        }else{
            CGFloat newWidth = ceil(width / height * newOriginal);
            newImage = [SWCHelpCenter changeImage:curImage toSize:CGSizeMake(newWidth, newOriginal)];
        }
    }
    return newImage;
}

#pragma mark -控件代理
//导航栏左侧点击事件
-(void)leftIconClick{
    NSLog(@"left");
    if (!self.showListView) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self.listView exitAnimation];
    }
    
}

//导航栏中间点击事件
-(void)centerIconClick{
    
    if (!self.showListView) {
        
        [self.listView enterAnimation];
    }else{
        
        [self.listView exitAnimation];
    }

}

//导航栏右侧点击事件
-(void)rightIconClick{
    NSLog(@"right");

    if (!self.showListView) {
        
        NSData *data = [pickView cutImageInBgView];
    
        ImagePickerFilterVC *filter = [[ImagePickerFilterVC alloc] init];
        filter.view.hidden = NO;
        [self.navigationController pushViewController:filter animated:YES];
        [filter fillBGViewWith:data];
        
    }else{
        
        NSLog(@"none");
    }
}

//底部图库按钮点击事件
-(void)albumIconClick{
    NSLog(@"album");
}

//底部拍照按钮点击事件
-(void)cameraIconClick{
    NSLog(@"camera");
}

//相册列表点击事件
-(void)AlbumListCellClick:(NSString *)albumTag{
    
    PhotoAlbumModel *chosenModel;
    
    for (PhotoAlbumModel *model in [photoTool getPhotoAblumList]) {
        if ([model.ablumName isEqualToString:albumTag]) {
            chosenModel = model;
            break;
        }
    }
    
    PHAssetCollection *chosenCollection = chosenModel.assetCollection;
    self.albumName = chosenModel.ablumName;
    
    self.photoAssetArr = [[photoTool getAllAssetIn:chosenCollection ByAscending:NO] mutableCopy];
    
    pickView.givenArr = self.photoAssetArr;
    
//    PHAsset *asset = [self.photoAssetArr objectAtIndex:0];
//    [photoTool createImageBy:asset
//                          In:[photoTool geiSizeAbout:asset]
//                    andBlock:^(NSData *data, NSDictionary *info) {
//                        UIImage *originalImage = [[UIImage alloc] initWithData:data];
//                        self.chosenImage.image = [self changeImageFrame:originalImage];
//                        [self.chosenImage sizeToFit];
//                        self.chosenImage.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
//                        NSLog(@"x=%f,y=%f,w=%f,h=%f",self.chosenImage.frame.origin.x,self.chosenImage.frame.origin.y,self.chosenImage.frame.size.width,self.chosenImage.frame.size.height);
//                        self.preFrame = self.chosenImage.frame;
//                    }];
//    [self.libPicsCollectionView reloadData];
    
}

//相册列表出现动画完成
-(void)listEnterAnimatinDone{
    self.showListView = YES;
    customNav.rightTitle = @" ";
    customNav.centerLabel.attributedText = [self createAlbumNameAtrr:self.albumName inOpen:NO];
}

//相册列表消失动画完成
-(void)listExitAnimatinDone{
    self.showListView = NO;
    customNav.rightTitle = @"image";
    customNav.centerLabel.attributedText = [self createAlbumNameAtrr:self.albumName inOpen:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImagePickerCell *cell = (ImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.frontView.hidden = NO;
    UIImage *cellImage = cell.imageInPHAsset;
    self.chosenImage.image = [self changeImageFrame:cellImage];
    [self.chosenImage sizeToFit];
    self.chosenImage.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
    NSLog(@"x=%f,y=%f,w=%f,h=%f",self.chosenImage.frame.origin.x,self.chosenImage.frame.origin.y,self.chosenImage.frame.size.width,self.chosenImage.frame.size.height);
    self.preFrame = self.chosenImage.frame;
    
    if (lastIndex) {
        ImagePickerCell *cellLast = (ImagePickerCell *)[collectionView cellForItemAtIndexPath:lastIndex];
        cellLast.frontView.hidden = YES;
    }
    
    lastIndex = indexPath;
    
}

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth - 3)/4, (ScreenWidth - 3)/4);
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(300, 0);
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.photoAssetArr.count > 0) {
        return self.photoAssetArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImagePickerCell" forIndexPath:indexPath];
    PHAsset *asset = [self.photoAssetArr objectAtIndex:indexPath.row];
    cell.imageCellTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    if (indexPath.row == 0) {
        cell.frontView.hidden = NO;
        lastIndex = indexPath;
    }else{
        cell.frontView.hidden = YES;
    }
    [photoTool createImageBy:asset
                          In:[photoTool geiSizeAbout:asset]
                    andBlock:^(NSData *data, NSDictionary *info) {
                        cell.imageInPHAsset = [[UIImage alloc] initWithData:data];
                    }];
    return cell;
    
}



@end
