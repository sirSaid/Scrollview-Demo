//
//  SSCarouselFigure.m
//  SSCarouselFigureDemo
//
//  Created by 吴亚乾 on 16/2/26.
//  Copyright © 2016年 吴亚乾. All rights reserved.
//

#import "SSCarouselFigure.h"
#import "UIImageView+WebCache.h"

@interface SSCarouselFigure ()<UIScrollViewDelegate>
// 左侧图片
@property (nonatomic,strong) UIImageView *leftImageView;
// 中间图片
@property (nonatomic,strong) UIImageView *centerImageView;
// 右侧图片
@property (nonatomic,strong) UIImageView *rightImageView;
// 记录当前显示图片的下标
@property (nonatomic,assign) NSInteger imageIndex;
// 定时器
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,copy) void (^block)();
// pageControl
@property (nonatomic,strong) UIPageControl *pageControl;
// 判断是否使用SDwebImage
@property (nonatomic,assign) BOOL isSDWebImage;
// 判断是否是两张图片
@property (nonatomic,assign) BOOL isTwoImage;

@end

@implementation SSCarouselFigure

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self layoutImageViews];
    }
    return self;
}
-(void)layoutImageViews
{
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
    
    // 设置偏移量
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    // 设置显示图片下标
    self.imageIndex = 1;
    
    // 设置滚动范围
    self.contentSize = CGSizeMake(self.frame.size.width *3, self.frame.size.height);
    
    // 添加视图
    [self addSubview:self.leftImageView];
    [self addSubview:self.centerImageView];
    [self addSubview:self.rightImageView];
    
    // 设置代理
    self.delegate = self;
    self.pagingEnabled = YES;
    
    // 取消边界
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;

}
#pragma mark ----- 重写轮播时间的 setter方法
-(void)setCarouselTime:(CGFloat)carouselTime
{
    _carouselTime = carouselTime;
    // 设置定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    // 开启RunLoop
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
#pragma mark ----- 重写本地加载图片数组的setter方法
-(void)setImageArray:(NSArray *)imageArray
{
    UIImage *image = imageArray.lastObject;
    // 数组赋值
    NSMutableArray *array = [self setImageMutableArrayWith:imageArray];
    if (array.count == 1) {
        _leftImageView.image = array.firstObject;
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        // 移除定时器
        [_timer invalidate];
        _timer = nil;
        return;
    }
    if (array.count == 2) {
        UIImage *images = array.firstObject;
        [array addObject:images];
        [array addObject:image];
        _isTwoImage = YES;
    }
    _imageArray = array;
    _leftImageView.image = _imageArray.firstObject;
    _centerImageView.image = _imageArray[1];
    _rightImageView.image = _imageArray[2];
    
    // 设置 pageControl
    [self setPageControlLayoutWith:imageArray];
}
// 自定义方法设置 传入图片数组的方法
-(NSMutableArray *)setImageMutableArrayWith:(NSArray *)imageArray
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:imageArray];
    // 把传入数组的最后一个元素移除
    [mutableArray removeObjectAtIndex:imageArray.count - 1];
    // 把最后一个元素插入到第一个
    [mutableArray insertObject:imageArray.lastObject atIndex:0];
    return mutableArray;
}

#pragma mark ----- 添加PageControl
-(void)setPageControlLayoutWith:(NSArray *)array
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = array.count;
    _pageControl.frame = CGRectMake(self.frame.size.width - 20 * _pageControl.numberOfPages, self.frame.size.height + self.frame.origin.y - 20, 20 * _pageControl.numberOfPages, 20);
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}

-(void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}

#pragma mark ----- 重写占位图片
-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    _leftImageView.image = placeholderImage;
    _centerImageView.image = placeholderImage;
    _rightImageView.image = placeholderImage;
}

#pragma mark ----- 重写SD加载图片的数据
-(void)setSD_UrlArray:(NSArray *)SD_UrlArray
{
    _isSDWebImage = YES;

    // 取出最后一张
    NSString *URLString = SD_UrlArray.lastObject;
    NSMutableArray *array = [self setImageMutableArrayWith:SD_UrlArray];

    // 如果是一张图片
    if (array.count == 1) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:SD_UrlArray.firstObject] placeholderImage:_placeholderImage];
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    // 如果是两张图片
    if (array.count == 2){
        NSString *URLStrings = array.firstObject;
        [array addObject:URLStrings];
        [array addObject:URLString];
        _isTwoImage = YES;
    }
    
    _imageArray = [NSArray arrayWithArray:array];
    [_leftImageView sd_setImageWithURL:_imageArray[0] placeholderImage:_placeholderImage];
    [_centerImageView sd_setImageWithURL:_imageArray[1] placeholderImage:_placeholderImage];
    [_rightImageView sd_setImageWithURL:_imageArray[2] placeholderImage:_placeholderImage];
    
    // 设置PageControl
    [self setPageControlLayoutWith:SD_UrlArray];
}

#pragma mark ----- 定时器检测方法
-(void)timerAction
{
    // 设置偏移量
    [self setContentOffset:CGPointMake(self.frame.size.width* 2, 0) animated:YES];
    
    // 添加新的计时器 检测
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerDidEndAction) userInfo:nil repeats:YES];
}

-(void)timerDidEndAction
{
    [self scrollViewDidEndDecelerating:self];
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 记录当前显示图片的左右图片的下标
    NSInteger leftIndex = 0;
    NSInteger rightIndex = 0;
    
    // 向左滑动
    if (scrollView.contentOffset.x == 0) {
        _imageIndex--;
        // 判断当前显示是第几张图片
        if (_imageIndex == 0) {
            leftIndex = _imageArray.count - 1;
            rightIndex = 1;
        }else if (_imageIndex < 0){
            _imageIndex = _imageArray.count - 1;
            leftIndex = _imageIndex - 1;
            rightIndex = 0;
        }else{
            leftIndex = _imageIndex - 1;
            rightIndex = _imageIndex + 1;
        }
    }else
    // 往右滑动
    if (scrollView.contentOffset.x == self.frame.size.width * 2){
        _imageIndex++;
        if (_imageIndex == _imageArray.count - 1) {
            leftIndex = _imageIndex - 1;
            rightIndex = 0;
        }else if (_imageIndex > _imageArray.count -1){
            _imageIndex = 0;
            leftIndex = _imageArray.count - 1;
            rightIndex = _imageIndex + 1;
        }else{
            leftIndex = _imageIndex - 1;
            rightIndex = _imageIndex + 1 ;
        }
    }else{
        return;
    }
    
    // 让图片偏移回到中间
    self.contentOffset = CGPointMake(self.frame.size.width, 0);

    // 当手指滑动时,让定时器重新设置时间
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_carouselTime]];
    
    //是否使用SDWebImage
    if (_isSDWebImage) {
        [_leftImageView sd_setImageWithURL:_imageArray[leftIndex] placeholderImage:_placeholderImage];
        [_centerImageView sd_setImageWithURL:_imageArray[_imageIndex] placeholderImage:_placeholderImage];
        [_rightImageView sd_setImageWithURL:_imageArray[rightIndex] placeholderImage:_placeholderImage];
    }else{
        self.leftImageView.image = _imageArray[leftIndex];
        self.centerImageView.image = _imageArray[_imageIndex];
        self.rightImageView.image = _imageArray[rightIndex];
    }

    // 当图片滚动时设置pageControl
    if (_isTwoImage) {
        if (_imageIndex % 2 == 0) {
            _pageControl.currentPage = 1;
        }else{
            _pageControl.currentPage = 0;
        }
    }else{
        //多张图片的pageControl
        _pageControl.currentPage = leftIndex;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.block) {
        self.block();
    }
}
-(void)touchImageIndexBlock:(void (^)(NSInteger))block
{
    __block SSCarouselFigure *men = self;
    self.block = ^(){
        if (block) {
            /* 
            // 常规判断
            NSInteger index = 0;
            if (men.imageIndex == 0 ) {
                index =  men.imageArray.count - 1;
            }else{
                index = men.imageIndex - 1;
            }
            block(index);
             */
            // 三目运算 修改  和上段注释任选一个使用
            NSInteger index = men.imageIndex != 0 ? men.imageIndex - 1 : men.imageArray.count - 1;
            //两种图片的情况
            if (men.isTwoImage) {
                if (index % 2 == 0) {
                    index = 0;
                }else{
                    index = 1;
                }
            }
            block(index);
        }
    };
    
}

@end
