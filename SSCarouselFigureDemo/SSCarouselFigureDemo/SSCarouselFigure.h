//
//  SSCarouselFigure.h
//  SSCarouselFigureDemo
//
//  Created by 吴亚乾 on 16/2/26.
//  Copyright © 2016年 吴亚乾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSCarouselFigure : UIScrollView
// 设置本地加载轮播图image数组，
@property (nonatomic,strong) NSArray *imageArray;

// 设置SDWebImage 加载轮播图的数组
@property (nonatomic,strong) NSArray *SD_UrlArray;

// 占位图
@property (nonatomic,strong) UIImage *placeholderImage;

// 设置轮播时间
@property (nonatomic, assign)CGFloat carouselTime; 

// 点击回调block
-(void)touchImageIndexBlock:(void (^)(NSInteger index))block;

@end
