//
//  HorizontalFlowLayout.m
//  SWCampus
//
//  Created by 11111 on 2017/3/8.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "HorizontalFlowLayout.h"

@implementation HorizontalFlowLayout

-(instancetype)init{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

@end
