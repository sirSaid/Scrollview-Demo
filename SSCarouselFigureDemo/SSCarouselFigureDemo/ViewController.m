//
//  ViewController.m
//  SSCarouselFigureDemo
//
//  Created by 吴亚乾 on 16/2/26.
//  Copyright © 2016年 吴亚乾. All rights reserved.
//

#import "ViewController.h"
#import "SSCarouselFigure.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    SSCarouselFigure *carouselFigure = [[SSCarouselFigure alloc] initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width - 20, ([UIScreen mainScreen].bounds.size.width - 20) / 3.0 * 2.0)];
    
    // 设置轮播时间
    carouselFigure.carouselTime = 1.0f;
#pragma mark ----- 本地文件加载轮播图使用此方法
    NSMutableArray *imageArray = [NSMutableArray array];

    for (int i = 0 ; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",i]];
        [imageArray addObject:image];
    }
    
    carouselFigure.imageArray = imageArray;
    [carouselFigure touchImageIndexBlock:^(NSInteger index) {
        NSLog(@"点击了第%ld张图片",(long)index);
    }];
    
    [self.view addSubview:carouselFigure];
    
#pragma mark ----- 网络请求加载轮播图
//    NSString *string = @"http://img2.a0bi.com/upload/ttq/20140722/1405995619576_middle.jpg";
//    NSString *string1 = @"http://ww2.sinaimg.cn/mw600/c6c1d258jw1e5r59ttpkcj20gu0gsmyh.jpg";
//    NSString *string2 = @"http://ww1.sinaimg.cn/mw600/bce7ca57gw1e4rg0coeqqj20dw099myu.jpg";
//    NSString *string3 = @"http://imgsrc.baidu.com/forum/w%3D580/sign=7fc5b239b9a1cd1105b672288912c8b0/51b0f603738da977be0bd022b351f8198618e3b7.jpg";
//    carouselFigure.SD_UrlArray = @[string,string1,string2,string3];
//    carouselFigure.placeholderImage = [UIImage imageNamed:@"image0.png"];
//    [carouselFigure touchImageIndexBlock:^(NSInteger index) {
//        NSLog(@"%ld",(long)index);
//    }];

//    [self.view addSubview:carouselFigure];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
