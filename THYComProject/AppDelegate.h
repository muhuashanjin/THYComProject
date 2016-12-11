//
//  AppDelegate.h
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)NSMutableArray *extensionArray;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

