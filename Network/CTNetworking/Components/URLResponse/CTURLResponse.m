//
//  AXURLResponse.m
//  RTNetworking
//
//  Created by casa on 14-5-18.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTURLResponse.h"
#import "NSObject+AXNetworkingMethods.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface CTURLResponse ()

@property (nonatomic, assign, readwrite) CTURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end

@implementation CTURLResponse

#pragma mark - life cycle
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData messageType:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType status:(CTURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status = status;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
        
        self.methodName = metName;
        self.serviceType = serType;
        self.requestType = reqType;
        self.messageType = messageType;
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData messageType:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.contentString = [responseString CT_defaultValue:@""];
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;

        self.methodName = metName;
        self.serviceType = serType;
        self.requestType = reqType;
        self.messageType = messageType;

        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data messageType:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType
{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
        
        self.methodName = metName;
        self.serviceType = serType;
        self.requestType = reqType;
        self.messageType = messageType;
    }
    return self;
}

- (instancetype)initWithResponseString:(int)messageType metName:(NSString *)metName serType:(NSString *)serType reqType:(int)reqType uploadData:(id)data downloadPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.methodName = metName;
        self.serviceType = serType;
        self.requestType = reqType;
        self.messageType = messageType;
        self.uploadData = data;
        self.downloadPath = path;
    }
    return self;
}

#pragma mark - private methods
- (CTURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        CTURLResponseStatus result = CTURLResponseStatusErrorNoNetwork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = CTURLResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return CTURLResponseStatusSuccess;
    }
}

@end
