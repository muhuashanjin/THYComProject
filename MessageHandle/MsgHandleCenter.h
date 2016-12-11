//
//  MsgHandleCenter.h
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseViewController.h"


#define kExtMsgMaxCount 100000
#define MsgBaseOfExtension(extension_id)               ((extension_id) * kExtMsgMaxCount)

typedef enum {
    kExtID_Default,
    kExtID_Main,
    kExtID_COUNT // 记录extension总数
} ExtensionID;

@protocol ExtensionHandle <NSObject>


@optional

// 判断是否是HttpGet消息，并是否自动处理
+ (BOOL)autoHttpGetTaskMsg:(int)taskMsg;

// 判断是否是HttpPost消息，并是否自动处理
+ (BOOL)autoHttpPostTaskMsg:(int)taskMsg;

// 用于处理资源相关的如网络请求、DB保存等消息，返回YES将停止继续分发消息
+ (BOOL)handleResourceMessageType:(int)messageType withArg:(id)arg;

// 用于处理发送给其他控制器未处理的消息
+ (BOOL)handleOnRootController:(BaseViewController *)rootController message:(int)messageType withResult:(int)result withArg:(id)arg;

@end

@interface MsgHandleCenter : NSObject

+(void)addController:(id)controller;
+(void)removeController:(id)controller;
+(BOOL)findController:(Class)controllerClass;
+(id)getControllersWithDescription:(NSString *)descri;

+(id)getController:(Class)controllerClass;
+(id)getController:(Class)controllerClass defaultController:(UIViewController *)defaultController;

+(void)sendMessageToControllers:(int)messageType withResult:(int)result withArg:(id)arg;
+(void)sendMessageToController:(id)conn withMessageType:(int)messageType withResult:(int)result withArg:(id)arg;
+(void)sendMessageToRootController:(int)messageType withResult:(int)result withArg:(id)arg;

+(void)sendMessage:(int)messageType withArg:(id)arg;
+(void)sendMessage:(int)messageType withArg:(id)arg withBolck:(dispatch_block_t)block;


@end
