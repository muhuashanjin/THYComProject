//
//  AXApiProxy.m
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CTApiProxy.h"
#import "CTServiceFactory.h"
#import "CTRequestGenerator.h"
#import "CTLogger.h"
#import "NSURLRequest+CTNetworkingMethods.h"

static NSString * const kAXApiProxyDispatchItemKeyCallbackSuccess = @"kAXApiProxyDispatchItemCallbackSuccess";
static NSString * const kAXApiProxyDispatchItemKeyCallbackFail = @"kAXApiProxyDispatchItemCallbackFail";

@interface CTApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

//AFNetworking stuff
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation CTApiProxy
#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[CTRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:response.serviceType requestParams:params methodName:response.methodName];
    NSNumber *requestId = [self callApiWithRequest:request messageType:response.messageType success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[CTRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:response.serviceType requestParams:params methodName:response.methodName];

    NSNumber *requestId = [self callApiWithRequest:request messageType:response.messageType success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPUTWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[CTRequestGenerator sharedInstance] generatePutRequestWithServiceIdentifier:response.serviceType requestParams:params methodName:response.methodName];

    NSNumber *requestId = [self callApiWithRequest:request messageType:response.messageType success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callDELETEWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[CTRequestGenerator sharedInstance] generateDeleteRequestWithServiceIdentifier:response.serviceType requestParams:params methodName:response.methodName];

    NSNumber *requestId = [self callApiWithRequest:request messageType:response.messageType success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callUPLOADWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail
{
    NSNumber *requestId = @1000;
    id data = response.uploadData;
    if ([data isKindOfClass:[NSArray class]]) {
        
        NSArray *datas = (NSArray *)data;
        if ([[datas firstObject] isKindOfClass:[UIImage class]]) {
            
            // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
            NSMutableArray* result = [NSMutableArray array];
            for (int i = 0; i<datas.count; i++) {
                [result addObject:[NSNull null]];
            }
            
            dispatch_group_t group = dispatch_group_create();
            for (int i = 0; i<datas.count; i++) {
                
                UIImage *image = datas[i];
                NSString *fileName = [NSString stringWithFormat:@"file%d",i];
                dispatch_group_enter(group);
                NSURLRequest *request = [[CTRequestGenerator sharedInstance] generateUploadRequestWithServiceIdentifier:response.serviceType requestParams:params methodName:response.methodName uploadData:image fileName:fileName];
                [self callUploadWithRequest:request group:group result:result index:i];
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                //上传完成
                CTURLResponse *CTResponse = [[CTURLResponse alloc] init];
                CTResponse.content = result;
                CTResponse.requestId = [requestId integerValue];
                CTResponse.messageType = response.messageType;
                
                if (datas.count == result.count) {
                    success?success(response):nil;
                }
                else
                {
                    fail?fail(response):nil;
                }
            });

        }
    }
    
    return [requestId integerValue];
}

- (NSInteger)callDOWNLOADWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail
{
    
    NSURLRequest *request = [[CTRequestGenerator sharedInstance] generateDownloadRequestWithServiceIdentifier:response.serviceType requestParams:params methodName:response.methodName];

    NSNumber *requestId = [self callDownloadWithRequest:request messageType:response.messageType downloadPath:response.downloadPath success:success fail:fail];
    
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request messageType:(int)messageType success:(AXCallback)success fail:(AXCallback)fail
{
    
    NSLog(@"\n==================================\n\nRequest Start: \n\n %@\n\n==================================", request.URL);
    
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSURL *realUrl = request.URL;

        if (error) {
            [CTLogger logDebugInfoWithResponse:httpResponse
                                  resposeString:responseString
                                        request:request
                                          error:error];
            CTURLResponse *CTResponse = [[CTURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData messageType:messageType metName:realUrl.relativePath serType:kServiceIndefiniteForMain reqType:0 error:error];
            fail?fail(CTResponse):nil;
        } else {
            // 检查http response是否成立。
            [CTLogger logDebugInfoWithResponse:httpResponse
                                  resposeString:responseString
                                        request:request
                                          error:NULL];
            CTURLResponse *CTResponse = [[CTURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData messageType:messageType metName:realUrl.relativePath serType:kServiceIndefiniteForMain reqType:0 status:CTURLResponseStatusSuccess];
            success?success(CTResponse):nil;
        }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}


- (NSNumber *)callUploadWithRequest:(NSURLRequest *)request group:(dispatch_group_t)group result:(NSMutableArray *)result index:(NSInteger)index
{
    
    NSLog(@"\n==================================\n\nUpload Start: \n\n %@\n\n==================================", request.URL);

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) {
            
            [CTLogger logDebugInfoWithResponse:httpResponse
                                 resposeString:responseString
                                       request:request
                                         error:error];

            dispatch_group_leave(group);
        } else {
            
            [CTLogger logDebugInfoWithResponse:httpResponse
                                 resposeString:responseString
                                       request:request
                                         error:NULL];

            @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                result[index] = responseString;
            }
            dispatch_group_leave(group);
        }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

- (NSNumber *)callDownloadWithRequest:(NSURLRequest *)request messageType:(int)messageType downloadPath:(NSString *)path success:(AXCallback)success fail:(AXCallback)fail
{
    
    NSLog(@"\n==================================\n\nDownload Start: \n\n %@\n\n==================================", request.URL);

    __block NSURLSessionDownloadTask *dataTask = nil;
    dataTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //设置下载路径
        NSString *filePath = path;
        if (!filePath) {
            filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        }
        return [NSURL URLWithString:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //下载完成
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        CTURLResponse *CTResponse = [[CTURLResponse alloc] init];
        CTResponse.content = filePath;
        CTResponse.requestId = [requestID integerValue];
        CTResponse.messageType = messageType;

        if (error) {
            [CTLogger logDebugInfoWithResponse:httpResponse
                                 resposeString:nil
                                       request:request
                                         error:error];

            fail?fail(CTResponse):nil;
        } else {
            // 检查http response是否成立。
            [CTLogger logDebugInfoWithResponse:httpResponse
                                 resposeString:nil
                                       request:request
                                         error:NULL];

            success?success(CTResponse):nil;
        }
        
    }];

    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

@end
