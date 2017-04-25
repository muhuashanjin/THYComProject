//
//  MsgHandleCenter.h
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "UIViewController+MsgHandle.h"
#import "AppDelegate+MsgHandle.h"

#define kExtMsgMaxCount 100000
#define MsgBaseOfExtension(extension_id)               ((extension_id) * kExtMsgMaxCount)

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

/*!
 @typedef ExtensionID
 
 @brief extension handle ID
 
 @discussion class inherit protocol ExtensionHandle must add ExtensionID
 */
typedef enum {
    kExtID_Default,
    kExtID_Main,
    kExtID_Login,
    kExtID_COUNT // 记录extension总数
} ExtensionID;

/*!
 @protocol  ExtensionHandle
 @brief     handle message ps:http、DB save or custome message
 */
@protocol ExtensionHandle <NSObject>
@optional

/*! judge the Http Get message, and whether the automatic processing */
+ (BOOL)autoHttpGetTaskMsg:(int)taskMsg;

/*! judge the Http Post message, and whether the automatic processing */
+ (BOOL)autoHttpPostTaskMsg:(int)taskMsg;

/*! judge the Http Upload message, and whether the automatic processing */
+ (BOOL)autoHttpUploadTaskMsg:(int)taskMsg;

/*! judge the Http Download message, and whether the automatic processing */
+ (BOOL)autoHttpDownloadTaskMsg:(int)taskMsg;

/*! Used for processing resources such as network request, DB save, return YES will stop to continue to distribute the message */
+ (BOOL)handleResourceMessageType:(int)messageType withArg:(id)arg;

/*! Used for processing messages that other controllers don't handle */
+ (BOOL)handleOnRootController:(UIViewController *)rootController message:(int)messageType withResult:(int)result withArg:(id)arg;

@end

@interface MsgHandleCenter : NSObject

/*! add UIViewController to MsgHandleCenter's controllerArr */
+(void)addController:(id)controller;

/*! remove UIViewController to MsgHandleCenter's controllerArr */
+(void)removeController:(id)controller;

/*! find UIViewController to MsgHandleCenter's controllerArr */
+(BOOL)findController:(Class)controllerClass;

/*! Use for class Name describe find obj in controllerArr  */
+(id)getControllersWithDescription:(NSString *)descri;

/*! Use for class find obj on controllerArr  */
+(id)getController:(Class)controllerClass;

/*! Use for class find obj on controllerArr and reture it ,in case not exist return default */
+(id)getController:(Class)controllerClass defaultController:(UIViewController *)defaultController;

/*!
 @brief send message to controllerArr's UIViewController
 @discussion Used for communication between controllers
 @param messageType send message type
 @param result message result ,or judge tpye
 @param arg the parameters of the incoming
 */
+(void)sendMessageToControllers:(int)messageType withResult:(int)result withArg:(id)arg;

/*!
 @brief send message to UIViewController
 @discussion Used for communication between controllers
 @param conn send message to conn that is UIViewController
 @param messageType send message type
 @param result message result ,or judge tpye
 @param arg the parameters of the incoming
 */
+(void)sendMessageToController:(id)conn withMessageType:(int)messageType withResult:(int)result withArg:(id)arg;

/*!
 @brief send message to RootController
 @discussion Used for communication between controllers
 @param messageType send message type
 @param result message result ,or judge tpye
 @param arg the parameters of the incoming
 */
+(void)sendMessageToRootController:(int)messageType withResult:(int)result withArg:(id)arg;

/*!
 @brief send message
 @discussion Used for communication between controllers、network request or DB save
 @param messageType send message type
 @param arg the parameters of the incoming, arg may be url or not
 */
+(void)sendMessage:(int)messageType withArg:(id)arg;

/*!
 @brief send message for upload
 @discussion upload network request
 @param messageType send message type
 @param arg the parameters of the incoming, arg must be url
 @param data data is NSArray, contain obj is kind of UIImage or filePath string
 */
+(void)sendMessage:(int)messageType withArg:(id)arg withUploadData:(id)data;

/*!
 @brief send message for download
 @discussion download network request
 @param messageType send message type
 @param arg the parameters of the incoming, arg must be url
 @param path download finish , set download path
 */
+(void)sendMessage:(int)messageType withArg:(id)arg withDownloadPath:(NSString *)path;

/*!
 @brief send message for download
 @discussion download network request
 @param messageType send message type
 @param arg the parameters of the incoming, arg must be url
 @param path download finish , set download path
 */
+(void)sendMessage:(int)messageType withArg:(id)arg withVc:(UIViewController *)vc withUploadData:(id)data withDownloadPath:(NSString *)path;


@end
