//
//  JQScrollViewHeader.h
//  JQScrollViewHeader
//
//  Created by tlkj on 17/3/20.
//  Copyright © 2017年 张家旗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQScrollViewHeader : UIView

@property (nonatomic,strong)NSArray *imageArray;
///用来处理滑动的事件
@property (nonatomic,strong) void(^isDragStateBlock)();

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imgArray placeholderImage:(NSString *)placeHolderImage dragState:(NSString *)dragState letGoState:(NSString *)letGoState;

@end
