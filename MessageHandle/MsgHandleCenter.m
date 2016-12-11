//
//  MsgHandleCenter.m
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "MsgHandleCenter.h"
#import "AppDelegate.h"

static  NSMutableArray*controllerArr =  nil;
static  BaseViewController *rootviewcontrol = nil;

@implementation MsgHandleCenter

+(id)getControllersWithDescription:(NSString *)descri
{
    NSMutableArray *vcs = [NSMutableArray array];
    for (int i = 0; i<controllerArr.count; i++) {
        BaseViewController *viewController = [controllerArr objectAtIndex:i];
        if ([viewController.class.description isEqualToString:descri])
        {
            [vcs addObject:viewController];
        }
    }
    return vcs;
}

+(void)addController:(id)controller
{
    if (!controllerArr)
    {
        controllerArr = TTCreateNonRetainingArray();
        rootviewcontrol = controller;
    }
    
    [controllerArr addObject:controller];
}

+(void)removeController:(id)controller
{
    [controllerArr removeObject:controller];
}

+(BOOL)findController:(Class)controllerClass
{
    NSInteger num = [controllerArr count];
    for (NSInteger i = num-1; i>=0; i--)
    {
        BaseViewController *viewController = [controllerArr objectAtIndex:i];
        if ([viewController.class.description isEqualToString:controllerClass.description])
        {
            return YES;
        }
    }
    return NO;
}

+(id)getController:(Class)controllerClass
{
    NSUInteger num = [controllerArr count];
    if (controllerClass == nil)
        return num > 0 ? rootviewcontrol : nil;
    
    for (NSInteger i = num-1; i>=0; i--)
    {
        BaseViewController *viewController = [controllerArr objectAtIndex:i];
        if ([viewController.class.description isEqualToString:controllerClass.description])
        {
            return viewController;
        }
    }
    return rootviewcontrol;
}

+(id)getController:(Class)controllerClass defaultController:(UIViewController *)defaultController
{
    NSInteger num = [controllerArr count];
    if (controllerClass == nil)
        return defaultController;
    
    for (NSInteger i = num-1; i>=0; i--)
    {
        BaseViewController *viewController = [controllerArr objectAtIndex:i];
        if ([viewController isKindOfClass:controllerClass])
        {
            return viewController;
        }
    }
    return defaultController;
}

+(void)sendMessageToController:(id)conn withMessageType:(int)messageType withResult:(int)result withArg:(id)arg
{
    int messageTypeTemp = messageType;
    int resultTemp  = result;
    id argTemp = arg;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger num = [controllerArr count];
        for (NSInteger i = num-1; i>=0; i--)
        {
            BaseViewController *viewController = [controllerArr objectAtIndex:i];
            if (viewController == conn)
            {
                [viewController PreProcessMessage:messageTypeTemp withResult:resultTemp withArg:argTemp];
                [viewController handleMessage:messageTypeTemp withResult:resultTemp withArg:argTemp];
                [rootviewcontrol PostProcessMessage:messageType withResult:result withArg:arg];
                break;
            }
            else
                continue;
        }
    });
}

+(void)sendMessageToRootController:(int)messageType withResult:(int)result withArg:(id)arg
{
    int messageTypeTemp = messageType;
    int resultTemp  = result;
    id argTemp = arg;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger num = [controllerArr count];
        if(num > 0) {
            [rootviewcontrol PreProcessMessage:messageTypeTemp withResult:resultTemp withArg:argTemp];
            [rootviewcontrol handleMessage:messageTypeTemp withResult:resultTemp withArg:argTemp];
            [rootviewcontrol PostProcessMessage:messageType withResult:result withArg:arg];
        }
    });
}

+(void)sendMessageToControllers:(int)messageType withResult:(int)result withArg:(id)arg
{
    int messageTypeTemp = messageType;
    int resultTemp  = result;
    id argTemp = arg;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *vcArr = [NSMutableArray array];
        for (UIViewController *vc in controllerArr) {
            [vcArr addObject:vc];
        }
        int num = (int)[vcArr count];
        for (int i = num-1; i>=0; i--)
        {
            BaseViewController *viewController = [vcArr objectAtIndex:i];
            [viewController PreProcessMessage:messageTypeTemp withResult:resultTemp withArg:argTemp];
            BOOL isDone =  [viewController handleMessage:messageTypeTemp withResult:resultTemp withArg:argTemp];
            if (isDone)
            {
                break;
            }
        }
        if (num)
            [rootviewcontrol PostProcessMessage:messageType withResult:result withArg:arg];
    });
}

+(void)sendMessage:(int)messageType withArg:(id)arg
{
    [MsgHandleCenter sendMessage:messageType withArg:arg withBolck:NULL];
}

+(void)sendMessage:(int)messageType withArg:(id)arg withBolck:(dispatch_block_t)block
{
    MsgHandleCenter *mHandleCenter = [MsgHandleCenter new];
    if ([[NSThread currentThread] isMainThread])
    {
        [mHandleCenter handMessage:messageType withArg:arg withBlock:block];
    }
    else
    {
        NSMethodSignature *sig = [MsgHandleCenter methodSignatureForSelector:@selector(handMessage: withArg: withBlock:)];
        if (!sig) return;
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:mHandleCenter];
        [invo setSelector:@selector(handMessage: withArg: withBlock:)];
        [invo setArgument:&messageType atIndex:2];
        [invo setArgument:&arg atIndex:3];
        [invo setArgument:&block atIndex:4];
        [invo retainArguments];
        [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
    }
}

- (id)handMessage:(int)messageType withArg:(id)arg withBlock:(dispatch_block_t)block
{
    // extension dispatch
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    for (Class clazz in app.extensionArray) {
          //http
        if ([clazz respondsToSelector:@selector(autoHttpGetTaskMsg:)]
            && [clazz autoHttpGetTaskMsg:messageType]) {
            [[BaseAPIManager sharedInstance] loadData:arg withMethod:CTAPIManagerRequestTypeGet withMsgeType:messageType];
            return nil;
        }
        if ([clazz respondsToSelector:@selector(autoHttpPostTaskMsg:)]
            && [clazz autoHttpPostTaskMsg:messageType]) {
            [[BaseAPIManager sharedInstance] loadData:arg withMethod:CTAPIManagerRequestTypePost withMsgeType:messageType];
            return nil;
        }
        // extension handle
        if ([clazz respondsToSelector:@selector(handleResourceMessageType:withArg:)]
            && [clazz handleResourceMessageType:messageType withArg:(id)arg]) {
            return nil;
        }
    }
    return nil;
}

+(NSString *)dump
{
    NSMutableString *dumpString = [NSMutableString string];
    for (UIViewController *controller in controllerArr) {
        [dumpString appendFormat:@"%@ \n", controller];
    }
    return dumpString;
}


static const void* TTRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void TTReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

NSMutableArray* TTCreateNonRetainingArray() {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = TTRetainNoOp;
    callbacks.release = TTReleaseNoOp;
    return (NSMutableArray*)CFBridgingRelease(CFArrayCreateMutable(nil, 0, &callbacks));
}

@end