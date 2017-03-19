//
//  ImagePickerView.m
//  SWCampus
//
//  Created by 11111 on 2017/3/8.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickerView.h"
#import "ImagePickerCell.h"

#define COLLECTIONLISTHEIGHT ScreenHeight - 70.5 - 40.5
#define HorizontalBoundray 8.000 / 15.000 * ScreenWidth
#define VerticalBoundray 4.000 / 5.000 * ScreenWidth

@implementation ImagePickerView

@synthesize chosenImageBGView,chosenImage;
@synthesize albumCollectionView;
@synthesize photoAssetArr;
@synthesize photoManage;
@synthesize lastIndex;
@synthesize isPickViewUp;
@synthesize shadowView;
@synthesize preFrame,curFrame;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initUI];
        
    }
    return self;
}

-(void)initData{
    isPickViewUp = NO;
    photoManage = [PhotoTool sharePhotoTool];
    photoAssetArr = [[NSMutableArray alloc] init];
}

-(void)initUI{
    chosenImageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    chosenImageBGView.clipsToBounds = YES;
    chosenImageBGView.backgroundColor = hexColor(0xffffff);
    UITapGestureRecognizer *bgTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)];
    [chosenImageBGView addGestureRecognizer:bgTap];
    [self addSubview:chosenImageBGView];
    
    chosenImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    chosenImage.contentMode = UIViewContentModeScaleAspectFill;
    chosenImage.clipsToBounds = YES;
    chosenImage.userInteractionEnabled = YES;
    [chosenImageBGView addSubview:chosenImage];
    
    UIPanGestureRecognizer *chosenImagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanInView:)];
    [chosenImage addGestureRecognizer:chosenImagePan];
    
    UIPinchGestureRecognizer *chosenImagePin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imagePinInView:)];
    [chosenImage addGestureRecognizer:chosenImagePin];
//
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    shadowView.backgroundColor = [hexColor(0x333333) colorWithAlphaComponent:0];
    shadowView.userInteractionEnabled = NO;
    shadowView.hidden = YES;
    [chosenImageBGView addSubview:shadowView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenWidth + 0.5, ScreenWidth, ScreenHeight - 70.5 - 40.5) collectionViewLayout:flowLayout];
    [albumCollectionView registerClass:[ImagePickerCell class]
                   forCellWithReuseIdentifier:@"ImagePickerCell"];
    albumCollectionView.backgroundColor = hexColor(0xffffff);
    albumCollectionView.dataSource = self;
    albumCollectionView.delegate = self;
    albumCollectionView.scrollEnabled = NO;
    [self addSubview:albumCollectionView];
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
    preFrame = chosenImage.frame;
    
    if (lastIndex && lastIndex.row != indexPath.row) {
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
    PHAsset *asset = [photoAssetArr objectAtIndex:indexPath.row];
    cell.imageCellTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    if (indexPath.row == 0) {
        cell.frontView.hidden = NO;
        lastIndex = indexPath;
    }else{
        cell.frontView.hidden = YES;
    }
    [photoManage createImageBy:asset
                          In:[photoManage geiSizeAbout:asset]
                    andBlock:^(NSData *data, NSDictionary *info) {
                        cell.imageInPHAsset = [[UIImage alloc] initWithData:data];
                    }];
    return cell;
    
}

-(void)setGivenArr:(NSMutableArray<PHAsset *> *)givenArr{
    _givenArr = givenArr;
    photoAssetArr = [givenArr mutableCopy];
    [albumCollectionView reloadData];
    
    PHAsset *asset = [photoAssetArr objectAtIndex:0];
    [photoManage createImageBy:asset
                          In:[photoManage geiSizeAbout:asset]
                    andBlock:^(NSData *data, NSDictionary *info) {
                        UIImage *originalImage = [[UIImage alloc] initWithData:data];
                        chosenImage.image = [self changeImageFrame:originalImage];
                        [self.chosenImage sizeToFit];
                        self.chosenImage.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
                        NSLog(@"x=%f,y=%f,w=%f,h=%f",self.chosenImage.frame.origin.x,self.chosenImage.frame.origin.y,self.chosenImage.frame.size.width,self.chosenImage.frame.size.height);
                        preFrame = chosenImage.frame;
                    }];
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

-(void)bgViewTap:(UITapGestureRecognizer *)sender{
    CGFloat y = [sender locationInView:chosenImageBGView].y;
    if (y > ScreenWidth - 50) {
        if (isPickViewUp) {
            [self pickViewDownEvent];
        }else{
            [self pickViewUpEvent];
        }
    }
}

-(void)pickViewUpEvent{
    shadowView.hidden = NO;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = CGRectMake(0, 70 - ScreenWidth, ScreenWidth, ScreenWidth + 0.5 + COLLECTIONLISTHEIGHT);
                         shadowView.backgroundColor = [hexColor(0x333333) colorWithAlphaComponent:0.8];
                     }
                     completion:^(BOOL finished) {
                         isPickViewUp = YES;
                         chosenImage.userInteractionEnabled = NO;
                     }];
}

-(void)pickViewDownEvent{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = CGRectMake(0, 64.5, ScreenWidth, ScreenWidth + 0.5 + COLLECTIONLISTHEIGHT);
                         shadowView.backgroundColor = [hexColor(0x333333) colorWithAlphaComponent:0];
                     }
                     completion:^(BOOL finished) {
                         isPickViewUp = NO;
                         shadowView.hidden = YES;
                         chosenImage.userInteractionEnabled = YES;

                     }];
}

//选中的图片拖动事件
-(void)imagePanInView:(UIPanGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    
    CGPoint oldPoint = imageView.center;
    CGPoint newPoint = [sender translationInView:chosenImageBGView];
    
    CGFloat newX = oldPoint.x + newPoint.x;
    CGFloat newY = oldPoint.y + newPoint.y;
    
    if (newX > width/2) {
        if (width > ScreenWidth) {
            newX = width/2;
        }else{
            newX = oldPoint.x;
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
            newY = oldPoint.y;
        }
    }else if (newY < ScreenWidth - height/2){
        if (height > ScreenWidth) {
            newY = ScreenWidth - height/2;
        }else{
            newY = height/2;
        }
    }
    
    imageView.center = CGPointMake(newX, newY);
    [sender setTranslation:CGPointZero inView:chosenImageBGView];
    
    preFrame = imageView.frame;
}

//选中的图片缩小/放大事件
-(void)imagePinInView:(UIPinchGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    
    CGFloat width = preFrame.size.width * sender.scale;
    CGFloat height = preFrame.size.height * sender.scale;
    
    imageView.frame = CGRectMake(CGRectGetMidX(preFrame) - width / 2, CGRectGetMidY(preFrame) - height / 2, width, height);
    
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
                                 imageView.center = CGPointMake(ViewWidth(chosenImageBGView)/2, ViewWidth(chosenImageBGView)/2);
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
                                 imageView.center = CGPointMake(ViewWidth(chosenImageBGView)/2, ViewWidth(chosenImageBGView)/2);
                             }];
        }else{
            
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 imageView.frame = CGRectMake((ScreenWidth - width)/2, (ScreenWidth - height)/2, width, height);
                             }
                             completion:^(BOOL finished) {
                                 NSLog(@"done");
                             }];
            
        }
        
        preFrame = imageView.frame;
    }
}

-(NSData *)cutImageInBgView{
    
    CGFloat width = ceil(preFrame.size.width);
    CGFloat height = ceil(preFrame.size.height);
    
    CGFloat cutX = width > ScreenWidth ? 0 : (ScreenWidth - width)/2;
    CGFloat cutY = height > ScreenWidth ? 0 : (ScreenWidth - height)/2;
    CGFloat cutWidth = width > ScreenWidth ? ScreenWidth : width;
    CGFloat cutHeight = height > ScreenWidth ? ScreenWidth : height;

    UIImage *cuttedImage = [CommonUtils Screenshot:chosenImageBGView
                                              rect:CGRectMake(cutX, cutY, cutWidth, cutHeight)
                                         imageName:@"pick01"];
    NSData *data = UIImageJPEGRepresentation(cuttedImage, 1.0);
    
    return data;
}

@end
