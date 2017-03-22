//
//  JQScrollViewHeader.m
//  JQScrollViewHeader
//
//  Created by tlkj on 17/3/20.
//  Copyright © 2017年 张家旗. All rights reserved.
//
#define SCREEN_HEIGHT self.frame.size.height
#define SCREEN_WIDTH self.frame.size.width
#define CGRECTMake(x,y,w,h)  CGRectMake((x), (y), (w), (h))
#define ScrollViewWidth self.backGroundScrollView.frame.size.width
#define ScrollViewHeight self.backGroundScrollView.frame.size.height
#define LabelTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] // #333333



#import "JQScrollViewHeader.h"
#import "UIImageView+EMWebCache.h"


@interface JQScrollViewHeader ()<UIScrollViewDelegate>{
    BOOL _isDragState;//确定是否拖动

}

@property (nonatomic,strong)UIScrollView *backGroundScrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSString *placeholderImage;//用于存放默认图片String
@property (nonatomic,strong)UILabel *dragLabel;
@property (nonatomic,strong)NSString *dragState;//拖动显示文字
@property (nonatomic,strong)NSString *letGoState;//放开显示文字

@end


@implementation JQScrollViewHeader

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imgArray placeholderImage:(NSString *)placeHolderImage dragState:(NSString *)dragState letGoState:(NSString *)letGoState{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = [NSArray arrayWithArray:imgArray];
        self.placeholderImage = placeHolderImage;
        _dragState = dragState;
        _letGoState = letGoState;
        [self creatView];
    }
    return self;
}


- (void)creatView{
    if (self.imageArray.count >0) {
        self.backGroundScrollView = [[UIScrollView alloc]init];
        [self creatScrollView:self.backGroundScrollView frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) arrayCount:self.imageArray.count imageArray:self.imageArray];

    }else{
        self.backGroundScrollView = [[UIScrollView alloc]init];
        [self creatScrollView:self.backGroundScrollView frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) arrayCount:1];

    }
}

- (void)creatScrollView:(UIScrollView *)scrollView frame:(CGRect)frame arrayCount:(NSInteger)arrayCount imageArray:(NSArray *)imageArray{
    scrollView.frame = frame;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.backGroundScrollView.frame.size.width*arrayCount, self.backGroundScrollView.frame.size.height);
    for (NSInteger num = 0; num <arrayCount; num++) {
        [self creatImageViewCount:num array:imageArray addTo:scrollView];
    }
    
    if (arrayCount > 1) {
        //轮播pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, self.backGroundScrollView.frame.size.height - 20, self.backGroundScrollView.frame.size.width, 10);
        [pageControl setNumberOfPages:arrayCount];
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl = pageControl;
        [self addSubview:self.pageControl];
    }

    UIView *checkMoreView = [[UIView alloc] initWithFrame:CGRectMake(self.backGroundScrollView.frame.size.width*arrayCount, 0, 0.25*self.backGroundScrollView.frame.size.width, self.backGroundScrollView.frame.size.height)];
    [scrollView addSubview:checkMoreView];
    
    self.dragLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, (checkMoreView.frame.size.height - 150)/2.0, 20, 150)];
    self.dragLabel.text = _dragState;//拖动显示
    self.dragLabel.numberOfLines = 0;
    self.dragLabel.textColor = LabelTextColor;
    self.dragLabel.font = [UIFont systemFontOfSize:13.0];
    [checkMoreView addSubview:self.dragLabel];
}

- (void)creatImageViewCount:(NSInteger)num array:(NSArray *)array addTo:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(self.backGroundScrollView.frame.size.width *num, 0, self.backGroundScrollView.frame.size.width, self.backGroundScrollView.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imgpath =  array[num];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgpath]];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:self.placeholderImage]];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]]; ///用来设置iamge的点击方法
}





#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.backGroundScrollView.contentOffset.x/self.backGroundScrollView.frame.size.width;
    _isDragState = NO;
    @synchronized(scrollView) {

    //滑动过程修改图片和文字
        if ((scrollView.contentOffset.x+scrollView.frame.size.width)>scrollView.contentSize.width) {

            CGFloat rightRefreshWidth = 60.0;
            CGAffineTransform transform;
            NSString *labelText;
            if ((scrollView.contentOffset.x+scrollView.frame.size.width-scrollView.contentSize.width) >= rightRefreshWidth) {
                transform = CGAffineTransformMakeRotation(M_PI);
                labelText = [NSString stringWithFormat:@"%@",_dragState];
                _isDragState = YES;
            } else {
                transform = CGAffineTransformIdentity;
                labelText = [NSString stringWithFormat:@"%@",_letGoState];;
                _isDragState = NO;
            }
            [UIView animateWithDuration:.20 animations:^{
                self.dragLabel.text = [NSString stringWithFormat:@"%@",labelText];
            }];
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_isDragState) {
        if (self.isDragStateBlock) {
            self.isDragStateBlock();
        }
    }
}



#pragma mark - 无数据情况
- (void)creatScrollView:(UIScrollView *)scrollView frame:(CGRect)frame arrayCount:(NSInteger)arrayCount{
    scrollView.frame = frame;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.backGroundScrollView.frame.size.width*arrayCount, self.backGroundScrollView.frame.size.width);
    for (NSInteger num = 0; num <arrayCount; num++) {
        [self creatImageViewCount:num addTo:scrollView];
    }
}
- (void)creatImageViewCount:(NSInteger)num addTo:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(self.backGroundScrollView.frame.size.width *num, 0, self.backGroundScrollView.frame.size.width, self.backGroundScrollView.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:self.placeholderImage];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]]; ///用来设置iamge的点击方法
}


@end
