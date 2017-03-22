//
//  AppDelegate.h
//  JQScrollViewHeader
//
//  Created by tlkj on 17/3/20.
//  Copyright © 2017年 张家旗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

