//
//  UIViewController+MsgHandle.h
//  THYComProject
//
//  Created by thy on 2017/4/18.
//  Copyright © 2017年 thy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgHandleCenter.h"

@interface UIViewController (MsgHandle)

@property(nonatomic,strong)NSMutableArray *requestIds;

//add local vc network request method
- (void)addRequest:(NSNumber *)requestId;
- (void)cancelRequest;

//VC send message method
-(void)sendMessage:(int)messageType withArg:(id)arg;
-(void)sendMessage:(int)messageType withArg:(id)arg withUploadData:(id)data;
-(void)sendMessage:(int)messageType withArg:(id)arg withDownloadPath:(NSString *)path;

//VC handle message three status(before/now/after handle) ps:now handle reture yes will cut message chain
-(void)PreProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg;
-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg;
-(void)PostProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg;

@end
