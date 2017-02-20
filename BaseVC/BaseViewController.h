//
//  BaseViewController.h
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *requestIds;

- (void)addRequest:(NSNumber *)requestId;
- (void)cancelRequest;

-(void)sendMessage:(int)messageType withArg:(id)arg;
-(void)sendMessage:(int)messageType withArg:(id)arg withUploadData:(id)data;
-(void)sendMessage:(int)messageType withArg:(id)arg withDownloadPath:(NSString *)path;

-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg;
-(void)PreProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg;
-(void)PostProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg;

@end
