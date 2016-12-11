//
//  AXURLResponse.h
//  RTNetworking
//
//  Created by casa on 14-5-18.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTNetworkingConfiguration.h"

@interface CTURLResponse : NSObject

@property (nonatomic, assign, readonly) CTURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;

@property (nonatomic, assign,readonly) int messageType;
@property (nonatomic, copy,readonly) NSString *methodName;
@property (nonatomic, copy,readonly) NSString *serviceType;
@property (nonatomic, assign,readonly) int requestType;

@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData messageType:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType status:(CTURLResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData messageType:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType error:(NSError *)error;

// 使用initWithData的response，它的isCache是YES，上面两个函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data messageType:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType;

- (instancetype)initWithResponseString:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType;

@end
