//
//  UIViewController+MsgHandle.m
//  THYComProject
//
//  Created by thy on 2017/4/18.
//  Copyright © 2017年 thy. All rights reserved.
//

#import "UIViewController+MsgHandle.h"

static char *requestIdsKey = "requestIdsKey";

@implementation UIViewController (MsgHandle)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class],@selector(initWithNibName:bundle:),@selector(msgHandle_initWithNibName:bundle:));
    });
}

- (id)msgHandle_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [MsgHandleCenter addController:self];
    return [self msgHandle_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)dealloc
{
    [self cancelRequest];
    [MsgHandleCenter removeController:self];
}

#pragma mark - public method
-(void)sendMessage:(int)messageType withArg:(id)arg
{
    if (!arg)
    {
        [MsgHandleCenter sendMessage:messageType withArg:arg];
    }
    else
    {
        [MsgHandleCenter sendMessage:messageType withArg:arg withVc:self withUploadData:nil withDownloadPath:nil];
    }
}

-(void)sendMessage:(int)messageType withArg:(id)arg withUploadData:(id)data
{
    if (arg && data)
    {
        [MsgHandleCenter sendMessage:messageType withArg:arg withVc:self withUploadData:data withDownloadPath:nil];
    }
    else
    {
        [MsgHandleCenter sendMessage:messageType withArg:arg];
    }
}

-(void)sendMessage:(int)messageType withArg:(id)arg withDownloadPath:(NSString *)path
{
    if (arg && path)
    {
        [MsgHandleCenter sendMessage:messageType withArg:arg withVc:self withUploadData:nil withDownloadPath:path];
    }
    else
    {
        [MsgHandleCenter sendMessage:messageType withArg:arg];
    }
}

-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg{return NO;}
-(void)PreProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg{}
-(void)PostProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg{}

- (void)addRequest:(NSNumber *)requestId
{
    @synchronized (self.requestIds)
    {
        if (!self.requestIds) {
            self.requestIds = [[NSMutableArray alloc] init];
        }
        [self.requestIds addObject:requestId];
    }
}

- (void)cancelRequest
{
    @synchronized (self.requestIds)
    {
        if (self.requestIds.count>0)
        {
            [[NSClassFromString(@"CTApiProxy") sharedInstance] performSelector:@selector(cancelRequestWithRequestIDList:) withObject:self.requestIds];            
        }
    }
}

#pragma mark - getters and setter
-(void)setRequestIds:(NSMutableArray *)requestIds {
    objc_setAssociatedObject(self, requestIdsKey, requestIds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)requestIds{
    return objc_getAssociatedObject(self, requestIdsKey);
}
@end
