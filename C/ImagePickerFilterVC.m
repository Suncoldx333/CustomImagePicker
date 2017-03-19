//
//  ImagePickerFilterVC.m
//  SWCampus
//
//  Created by 11111 on 2017/3/7.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "ImagePickerFilterVC.h"
#import "SWCHelpCenter.h"
#import "HorizontalFlowLayout.h"
#import "FilterListCell.h"

#define FILTERCOLLECTIONHEIGHT ScreenHeight - 64.5 - ScreenWidth - 40.5
#define FILTERCOLLECTIONCELLWIDTH ScreenWidth / 375.000 * 100.000

@interface ImagePickerFilterVC ()

@property (nonatomic,strong) UIView *chosenImageBGView;
@property (nonatomic,strong) UIImageView *chosenImage;
@property (nonatomic,strong) UICollectionView *filterCollectionView;
@property (nonatomic,strong) NSMutableArray<NSMutableDictionary *> *filterTypeArr;
@property (nonatomic,strong) NSIndexPath *lastChosenIndex;
@property (nonatomic) BOOL firstApply;
@property (nonatomic,strong) CIContext *context;
@property (nonatomic,strong) NSData *originalImageData;

@end

@implementation ImagePickerFilterVC

@synthesize customNav,bottomView;

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

-(CIContext *)context{
    if (_context == nil) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

#pragma mark -初始化数据
-(void)initData{
    
    self.firstApply = YES;
    
    NSMutableArray<NSString *> *nameArr = [[NSMutableArray alloc] initWithObjects:@"原图",@"单色",@"色调",@"黑白",@"褪色",@"铬黄",@"冲印",@"岁月",@"怀旧", nil];
    self.filterTypeArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 9; i++) {
        if (i == 0) {
            NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] init];
            [nameDic setObject:[nameArr firstObject] forKey:@"name"];
            [nameDic setObject:@"1" forKey:@"color"];
            [self.filterTypeArr addObject:nameDic];
        }else{
            NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] init];
            [nameDic setObject:[nameArr objectAtIndex:i] forKey:@"name"];
            [nameDic setObject:@"0" forKey:@"color"];
            [self.filterTypeArr addObject:nameDic];
        }
    }
    
}

#pragma mark -初始化界面
-(void)initUI{
    
    self.view.backgroundColor = hexColor(0xffffff);
    
    //导航栏
    customNav = [[TopicCustomNav alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44.5)];
    customNav.delegate = self;
    customNav.rightTitle = @"image";
    customNav.centerLabel.text = @"拍摄照片";
    customNav.leftIcon = @"3030FilterReturn";
    [self.view addSubview:customNav];
    
    //选中的照片
    self.chosenImageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.5, ScreenWidth, ScreenWidth)];
    self.chosenImageBGView.clipsToBounds = YES;
    self.chosenImageBGView.backgroundColor = hexColor(0xffffff);
    [self.view addSubview:self.chosenImageBGView];
    
    self.chosenImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    self.chosenImage.contentMode = UIViewContentModeScaleAspectFit;
    self.chosenImage.clipsToBounds = YES;
    self.chosenImage.userInteractionEnabled = NO;
    [self.chosenImageBGView addSubview:self.chosenImage];
    
    //滤镜
    HorizontalFlowLayout *layout = [[HorizontalFlowLayout alloc]init];
    self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.5 + ScreenWidth, ScreenWidth, FILTERCOLLECTIONHEIGHT) collectionViewLayout:layout];
    self.filterCollectionView.showsHorizontalScrollIndicator = NO;
    [self.filterCollectionView registerClass:[FilterListCell class] forCellWithReuseIdentifier:@"filterCell"];
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;
    self.filterCollectionView.backgroundColor = hexColor(0xffffff);
    [self.view addSubview:self.filterCollectionView];
    
    //底部按钮
    bottomView = [[ImagePickerBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40.5, ScreenWidth, 40.5)];
    bottomView.delegate = self;
    bottomView.bottomViewTypeOpen = 1;
    [self.view addSubview:bottomView];
}

#pragma mark -公有方法
//替换选中的照片
-(void)fillBGViewWith:(NSData *)imageData{
    self.originalImageData = imageData;
    UIImage *chosenImage = [[UIImage alloc] initWithData:imageData];
    self.chosenImage.image = chosenImage;
    self.chosenImage.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
}

#pragma mark -私有方法
//添加图片的滤镜效果
-(UIImage *)filterImage:(UIImage *)originalImage InType:(NSInteger)type{
    CIFilter *filter;
    switch (type) {
        case 1:
            filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
            break;
        case 2:
            filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
            break;
        case 3:
            filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
            break;
        case 4:
            filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
            break;
        case 5:
            filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
            break;
        case 6:
            filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
            break;
        case 7:
            filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
            break;
        case 8:
            filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
            break;
        default:
            break;
    }
    
    
    NSData *data = UIImageJPEGRepresentation(originalImage, 1.0);
    CIImage *inputImage = [CIImage imageWithData:data];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    //生成outputImage时间很长，考虑转移到其他地方
    CIImage *outputImage = filter.outputImage;
    CGImageRef cgImge = [self.context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [[UIImage alloc] initWithCGImage:cgImge];
    return newImage;
}

//更换选中图片的滤镜效果
-(void)changeChosenImageFilter:(NSInteger)type{
    
    UIImage *changeImage = [UIImage imageWithData:self.originalImageData];
    
    if (type == 0) {
        self.chosenImage.image = changeImage;
    }else{
        self.chosenImage.image = [self filterImage:changeImage InType:type];
    }
}

#pragma mark -控件代理
//导航栏点击左侧返回
-(void)leftIconClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏点击右侧返回
-(void)rightIconClick{
    NSLog(@"right");
}

#pragma mark -CollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 9;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.filterImage = self.chosenImage.image;
    }else{
        cell.filterImage = [self filterImage:self.chosenImage.image InType:indexPath.section];
    }
    cell.cellIndex = indexPath.section;
    
    cell.filterNameLabel.text = [[self.filterTypeArr objectAtIndex:indexPath.section] objectForKey:@"name"];
    NSString *colorType = [[self.filterTypeArr objectAtIndex:indexPath.section] objectForKey:@"color"];
    if (colorType.intValue == 1) {
        cell.filterNameLabel.textColor = hexColor(0x333333);
    }else if (colorType.intValue == 0){
        cell.filterNameLabel.textColor = hexColor(0xb2b2b2);
    }
    
    if (indexPath.section == 0 && self.firstApply) {
        self.firstApply = NO;
        self.lastChosenIndex = indexPath;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(FILTERCOLLECTIONCELLWIDTH, FILTERCOLLECTIONHEIGHT);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(15, FILTERCOLLECTIONHEIGHT);
    }
    return CGSizeMake(5, FILTERCOLLECTIONHEIGHT);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 8) {
        return CGSizeMake(15, FILTERCOLLECTIONHEIGHT);
    }
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterListCell *cell = (FilterListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.filterNameLabel.textColor = hexColor(0x333333);
    NSString *cellName = cell.filterNameLabel.text;
    
    [self changeChosenImageFilter:indexPath.section];
    
    //修改title颜色
    NSMutableArray<NSMutableDictionary *> *changedArr = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *nameDic in self.filterTypeArr) {
        NSMutableDictionary *changedNameDic = [nameDic mutableCopy];
        if ([[nameDic objectForKey:@"name"] isEqualToString:cellName]) {
            [changedNameDic setObject:@"1" forKey:@"color"];
        }else{
            [changedNameDic setObject:@"0" forKey:@"color"];
        }
        [changedArr addObject:changedNameDic];
    }

    self.filterTypeArr = [changedArr mutableCopy];
    
    NSInteger chosenIndex = cell.cellIndex;
    CGFloat x = collectionView.contentOffset.x;
    bool listNeedScroll = NO;
    
    NSInteger headIndex = (x - 12.5) / 105;
    NSInteger footIndex = (x + ScreenWidth - 12.5) / 105;
    if (headIndex < chosenIndex && chosenIndex < footIndex) {
        listNeedScroll = NO;
    }else{
        listNeedScroll = YES;
    }
    
    if (listNeedScroll) {
        CGFloat newX = 0;
        if (headIndex == chosenIndex) {
            if (chosenIndex == 0) {
                newX = 0;
            }else{
                newX = 10 + chosenIndex * 105;
            }
        }else if (chosenIndex == footIndex){
            newX = 10 + (chosenIndex + 1) * 105 + 5 - ScreenWidth;
        }
        [collectionView setContentOffset:CGPointMake(newX, 0) animated:YES];
    }
    
    if (self.lastChosenIndex && self.lastChosenIndex.section != indexPath.section) {
        FilterListCell *lastCell = (FilterListCell *)[collectionView cellForItemAtIndexPath:self.lastChosenIndex];
        lastCell.filterNameLabel.textColor = hexColor(0xb2b2b2);
    }
    
    self.lastChosenIndex = indexPath;
}

@end
