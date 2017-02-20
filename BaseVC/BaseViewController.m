//
//  BaseViewController.m
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [MsgHandleCenter addController:self];
    }
    return self;
}

- (void)dealloc
{
    [self cancelRequest];
    [MsgHandleCenter removeController:self];
}

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
        [self.requestIds addObject:requestId];
    }
}

- (void)cancelRequest
{
    @synchronized (_requestIds)
    {
        if (_requestIds.count>0)
        {
            [[CTApiProxy sharedInstance] cancelRequestWithRequestIDList:_requestIds];
        }
    }
}

- (NSMutableArray *)requestIds
{
    if (!_requestIds) {
        _requestIds = [[NSMutableArray alloc] init];
    }
    return _requestIds;
}
@end
