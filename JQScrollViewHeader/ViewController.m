//
//  ViewController.m
//  JQScrollViewHeader
//
//  Created by tlkj on 17/3/20.
//  Copyright © 2017年 张家旗. All rights reserved.
//
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define CGRECTMake(x,y,w,h)  CGRectMake((x), (y), (w), (h))

#import "ViewController.h"
#import "JQScrollViewHeader.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"iphone7",@"iphone7",@"iphone7",@"iphone7"];
    
    JQScrollViewHeader *headerView = [[JQScrollViewHeader alloc]initWithFrame:CGRECTMake(0,200, SCREEN_WIDTH, 180) imageArray:array placeholderImage:@"iphone7" dragState:@"进入详情" letGoState:@"继续浏览"];
    
    headerView.isDragStateBlock = ^{
        NSLog(@"这里来处理需要跳转的页面,或其他事件");
    };
    
    [self.view addSubview:headerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
