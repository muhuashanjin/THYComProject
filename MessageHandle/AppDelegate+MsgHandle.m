//
//  AppDelegate+MsgHandle.m
//  THYComProject
//
//  Created by thy on 2017/4/18.
//  Copyright © 2017年 thy. All rights reserved.
//

#import "AppDelegate+MsgHandle.h"
#import <objc/runtime.h>

static char *extensionArrayKey = "extensionArrayKey";

#define AddExtension(objc_class) \
[self performSelector:@selector(addExtension:) withObject:[objc_class class]]

@implementation AppDelegate (MsgHandle)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class],@selector(application:didFinishLaunchingWithOptions:),@selector(msgHandle_application:didFinishLaunchingWithOptions:));
    });
}

- (BOOL)msgHandle_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadExtensions];
    return [self msgHandle_application:application didFinishLaunchingWithOptions:launchOptions];
}


#pragma mark - laod Extensions
- (void)loadExtensions{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MsgHandleCenterExtension" ofType:@"plist"];
    NSMutableDictionary *extensionDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    for (NSString *extensionName in extensionDic.allKeys) {
        AddExtension(NSClassFromString(extensionName));
    }
}

- (void)addExtension:(Class)clazz
{
    if ([clazz conformsToProtocol:@protocol(ExtensionHandle)]) {
        if (!self.extensionArray) {
            self.extensionArray = [NSMutableArray array];
        }
        [self.extensionArray addObject:clazz];
    }
    else {
        NSAssert(@"Loading extension error : %@", NSStringFromClass(clazz));
    }
}

#pragma mark - getters and setter
-(void)setExtensionArray:(NSMutableArray *)extensionArray {
    objc_setAssociatedObject(self, extensionArrayKey, extensionArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)extensionArray{
    return objc_getAssociatedObject(self, extensionArrayKey);
}


@end
