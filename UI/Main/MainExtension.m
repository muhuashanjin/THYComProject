//
//  MainExtension.m
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "MainExtension.h"

@implementation MainExtension

+ (BOOL)autoHttpGetTaskMsg:(int)taskMsg
{
    return (kTaskMsg_Main_TestToExtension == taskMsg);
}

+ (BOOL)autoHttpPostTaskMsg:(int)taskMsg
{
    return (kTaskMsg_Main_TestToVC == taskMsg);
}

+ (BOOL)handleResourceMessageType:(int)messageType withArg:(id)arg
{
    if (kTaskMsg_Main_TestToExtension == messageType) {
        [MsgHandleCenter sendMessageToControllers:kTaskMsg_Main_TestToVC withResult:0 withArg:nil];
    }
    return NO;
}

+ (BOOL)handleOnRootController:(BaseViewController *)rootController message:(int)messageType withResult:(int)result withArg:(id)arg
{
    if (kTaskMsg_Main_TestToVC == messageType) {
        
    }
    return NO;
}

@end
