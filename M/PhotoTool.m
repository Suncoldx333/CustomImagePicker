//
//  PhotoTool.m
//  SWCampus
//
//  Created by 11111 on 2017/3/3.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "PhotoTool.h"

@implementation PhotoTool

static PhotoTool *sharePhotoTool = nil;
+ (instancetype)sharePhotoTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [[self alloc] init];
    });
    return sharePhotoTool;
}

-(BOOL)getPhotoAblumJurisdictionStatus{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}


- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumByAscending:(BOOL)ascending{
    
    NSMutableArray<PHAsset *> *assetArr = [[NSMutableArray alloc] init];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [assetArr addObject:asset];
    }];
    
    return assetArr;
}

-(void)createImageBy:(PHAsset *)asset In:(CGSize)size andBlock:(void (^)(NSData *, NSDictionary *))completion{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    
    PHImageRequestID requestId = -1;
    
    requestId = [[PHCachingImageManager defaultManager]
                 requestImageDataForAsset:asset
                                  options:option
                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                completion(imageData,info);
                            }];
    
}

-(CGSize)geiSizeAbout:(PHAsset *)asset{
    
    CGFloat width = [[NSNumber numberWithUnsignedInteger:asset.pixelWidth] floatValue];
    CGFloat height = [[NSNumber numberWithUnsignedInteger:asset.pixelHeight] floatValue];
    
    CGSize givenSize = CGSizeMake(width, height);
    return givenSize;
}

- (NSArray<PhotoAlbumModel *> *)getPhotoAblumList
{
    NSMutableArray<PhotoAlbumModel *> *photoAblumList = [[NSMutableArray alloc] init];
    
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        //过滤掉视频和最近删除
        if(collection.assetCollectionSubtype != 202 && collection.assetCollectionSubtype < 212){
            
            NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
            
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                 NSUInteger idx,
                                                 BOOL * _Nonnull stop) {
                if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
                    [assets addObject:obj];
                }
            }];
            
            if (assets.count > 0) {
                PhotoAlbumModel *ablum = [[PhotoAlbumModel alloc] init];
                ablum.ablumName = collection.localizedTitle;
                ablum.count = assets.count;
                ablum.headImageAsset = assets.firstObject;
                ablum.assetCollection = collection;
                [photoAblumList addObject:ablum];
            }
        }
    }];
    
    //获取用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                         subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                         options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection,
                                             NSUInteger idx,
                                             BOOL * _Nonnull stop) {
        NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
        
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
                [assets addObject:obj];
            }
        }];
        if (assets.count > 0) {
            PhotoAlbumModel *ablum = [[PhotoAlbumModel alloc] init];
            ablum.ablumName = collection.localizedTitle;
            ablum.count = assets.count;
            ablum.headImageAsset = assets.firstObject;
            ablum.assetCollection = collection;
            [photoAblumList addObject:ablum];
        }
    }];
    
    return photoAblumList;
}

-(NSArray<PHAsset *> *)getAllAssetIn:(PHAssetCollection *)givenCollection ByAscending:(BOOL)ascending{
    NSMutableArray<PHAsset *> *arr = [[NSMutableArray alloc] init];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:givenCollection options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
    
    return arr;
}


@end
