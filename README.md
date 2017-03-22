# JQScrollViewHeader
-
## 仿造目前商城常用商品详情内轮播图滑动进入商品详情页 
 +
 ### viewController 实现方法  
 
     NSArray *array = @[@"iphone7",@"iphone7",@"iphone7",@"iphone7"];
    
    JQScrollViewHeader *headerView = [[JQScrollViewHeader alloc]initWithFrame:CGRECTMake(0,200, SCREEN_WIDTH, 180) imageArray:array placeholderImage:@"iphone7" dragState:@"进入详情" letGoState:@"继续浏览"];
    
    headerView.isDragStateBlock = ^{
        NSLog(@"这里来处理需要跳转的页面,或其他事件");
    };
    
    [self.view addSubview:headerView];
 
 -
![image](https://raw.githubusercontent.com/seanBoler/JQScrollViewHeader/master/JQScrollViewHeader/gifscrollView.gif)
