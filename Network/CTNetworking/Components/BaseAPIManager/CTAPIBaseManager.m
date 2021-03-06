//
//  AJKBaseManager.m
//  casatwy2
//
//  Created by casa on 13-12-2.
//  Copyright (c) 2013年 casatwy inc. All rights reserved.
//

#import "CTAPIBaseManager.h"
#import "CTNetworking.h"
#import "CTCache.h"
#import "CTLogger.h"
#import "CTServiceFactory.h"
#import "CTAppContext.h"
#import "CTApiProxy.h"
#import "CTAppContext.h"

NSString const *baseUrl = kBaseUrl;

#define AXCallAPI(REQUEST_METHOD, REQUEST_ID, URL_RESPONSE)                                                   \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
    REQUEST_ID = [[CTApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams urlResponse:URL_RESPONSE success:^(CTURLResponse *response) { \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf successedOnCallingAPI:response];                                            \
    } fail:^(CTURLResponse *response) {                                                        \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf failedOnCallingAPI:response withErrorType:CTAPIManagerErrorTypeDefault];    \
    }];                                                                                         \
    [self.requestIdList addObject:@(REQUEST_ID)];                                               \
}

NSString * const kBSUserTokenInvalidNotification = @"kBSUserTokenInvalidNotification";
NSString * const kBSUserTokenIllegalNotification = @"kBSUserTokenIllegalNotification";

NSString * const kBSUserTokenNotificationUserInfoKeyRequestToContinue = @"kBSUserTokenNotificationUserInfoKeyRequestToContinue";
NSString * const kBSUserTokenNotificationUserInfoKeyManagerToContinue = @"kBSUserTokenNotificationUserInfoKeyManagerToContinue";


@interface CTAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) CTAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) CTCache *cache;

@end

@implementation CTAPIBaseManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = CTAPIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(CTAPIManager)]) {
            self.child = (id <CTAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public methods
- (void)cancelAllRequests
{
    [[CTApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[CTApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<CTAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark - calling api
- (NSInteger)loadData:(NSString *)url withMethod:(CTAPIManagerRequestType)requestType withMsgeType:(int)messageType
{
    if (!url) {
        DLog("==== ERROR : URL String Empty ====");
        return 0;
    }
    
    NSURL *realUrl = [NSURL URLWithString:url];
    baseUrl = [NSString stringWithFormat:@"%@://%@",realUrl.scheme,realUrl.host];
    CTURLResponse *response = [[CTURLResponse alloc] initWithResponseString:messageType metName:realUrl.relativePath serType:kServiceIndefiniteForMain reqType:requestType uploadData:nil downloadPath:nil];
    NSDictionary *params = [self handleParamStr:realUrl.query];
    NSInteger requestId = [self loadDataWithParams:params withUrlReponse:response];
    return requestId;
}

- (NSInteger)uploadData:(NSString *)url withMsgeType:(int)messageType withUploadData:(id)data
{
    if (!url) {
        DLog("==== ERROR : URL String Empty ====");
        return 0;
    }
    
    NSURL *realUrl = [NSURL URLWithString:url];
    baseUrl = [NSString stringWithFormat:@"%@://%@",realUrl.scheme,realUrl.host];
    CTURLResponse *response = [[CTURLResponse alloc] initWithResponseString:messageType metName:realUrl.relativePath serType:kServiceIndefiniteForMain reqType:CTAPIManagerRequestTypeUpload uploadData:data downloadPath:nil];
    NSDictionary *params = [self handleParamStr:realUrl.query];
    NSInteger requestId = [self loadDataWithParams:params withUrlReponse:response];
    return requestId;
}

- (NSInteger)downloadData:(NSString *)url withMsgeType:(int)messageType withDownloadPath:(NSString *)path
{
    if (!url) {
        DLog("==== ERROR : URL String Empty ====");
        return 0;
    }
    
    NSURL *realUrl = [NSURL URLWithString:url];
    baseUrl = [NSString stringWithFormat:@"%@://%@",realUrl.scheme,realUrl.host];
    CTURLResponse *response = [[CTURLResponse alloc] initWithResponseString:messageType metName:realUrl.relativePath serType:kServiceIndefiniteForMain reqType:CTAPIManagerRequestTypeUpload uploadData:nil downloadPath:path];
    NSDictionary *params = [self handleParamStr:realUrl.query];
    NSInteger requestId = [self loadDataWithParams:params withUrlReponse:response];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params withUrlReponse:(CTURLResponse *)response
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            if ([self shouldLoadFromNative]) {
                [self loadDataFromNative:response];
            }
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams withUrlReponse:response]) {
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                self.isLoading = YES;
                    switch (response.requestType)
                    {
                        case CTAPIManagerRequestTypeGet:
                            AXCallAPI(GET, requestId, response);
                            break;
                        case CTAPIManagerRequestTypePost:
                            AXCallAPI(POST, requestId, response);
                            break;
                        case CTAPIManagerRequestTypePut:
                            AXCallAPI(PUT, requestId, response);
                            break;
                        case CTAPIManagerRequestTypeDelete:
                            AXCallAPI(DELETE, requestId, response);
                        break;
                        case CTAPIManagerRequestTypeUpload:
                            AXCallAPI(UPLOAD, requestId, response);
                        break;
                        case CTAPIManagerRequestTypeDownload:
                            AXCallAPI(DOWNLOAD, requestId, response);
                        break;
                        default:
                            break;
                    }
            
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kCTAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
            
            } else {
                [self failedOnCallingAPI:nil withErrorType:CTAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:CTAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(CTURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    
    if ([self shouldLoadFromNative]) {
        if (response.isCache == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:response.methodName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache && response.requestType != CTAPIManagerRequestTypeUpload && response.requestType != CTAPIManagerRequestTypeDownload) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:response.serviceType methodName:response.methodName messageType:response.messageType requestParams:response.requestParams];
        }
        
        if ([self beforePerformSuccessWithResponse:response]) {
            if ([self shouldLoadFromNative]) {
                if (response.isCache == YES) {
                    [self.delegate managerCallAPIDidSuccess:self];
                    [MsgHandleCenter sendMessageToControllers:response.messageType withResult:0 withArg:response.content];
                }
                if (self.isNativeDataEmpty) {
                    [self.delegate managerCallAPIDidSuccess:self];
                    [MsgHandleCenter sendMessageToControllers:response.messageType withResult:0 withArg:response.content];
                }
            } else {
                [self.delegate managerCallAPIDidSuccess:self];
                [MsgHandleCenter sendMessageToControllers:response.messageType withResult:0 withArg:response.content];
            }
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:CTAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(CTURLResponse *)response withErrorType:(CTAPIManagerErrorType)errorType
{
    self.isLoading = NO;
    self.response = response;
    if ([response.content[@"id"] isEqualToString:@"expired_access_token"]) {
        // token 失效
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
    } else if ([response.content[@"id"] isEqualToString:@"illegal_access_token"]) {
        // token 无效，重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
    } else if ([response.content[@"id"] isEqualToString:@"no_permission_for_this_api"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
    } else {
        // 其他错误
        self.errorType = errorType;
        [self removeRequestIdWithRequestID:response.requestId];
        if ([self beforePerformFailWithResponse:response]) {
            [self.delegate managerCallAPIDidFailed:self];
            [MsgHandleCenter sendMessageToControllers:response.messageType withResult:1 withArg:response.content];
        }
        [self afterPerformFailWithResponse:response];
    }
}

#pragma mark - method for interceptor

/*
    拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
    当两种情况共存的时候，子类重载的方法一定要调用一下super
    然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
    
    notes:
        正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
        但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
        所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
        这就是decorate pattern
 */
- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = CTAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(CTURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(CTURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(CTURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - method for child
- (void)cleanData
{
    [self.cache clean];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = CTAPIManagerErrorTypeDefault;
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)shouldCache
{
    return kCTShouldCache;
}

#pragma mark - private methods
- (NSDictionary *)handleParamStr:(NSString *)paramStr
{
    NSArray *paramArr = [paramStr componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *param in paramArr) {
        NSArray *dicArr = [param componentsSeparatedByString:@"="];
        [dic setObject:dicArr[1] forKey:dicArr[0]];
    }

    //add token
    if ([CTAppContext sharedInstance].apiToken) {
        [dic setObject:[CTAppContext sharedInstance].apiToken forKey:@"token"];
    }

    return dic;
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params withUrlReponse:(CTURLResponse *)urlResponse
{
    NSString *serviceIdentifier = urlResponse.serviceType;
    NSString *methodName = urlResponse.methodName;
    
    CTCachedObject *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName messageType:urlResponse.messageType requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        CTURLResponse *response = [[CTURLResponse alloc] initWithData:result.content messageType:result.messageType metName:urlResponse.methodName serType:kServiceIndefiniteForMain reqType:urlResponse.requestType];
        response.requestParams = params;
        [CTLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [strongSelf successedOnCallingAPI:response];
    });
    
    return YES;
}

- (void)loadDataFromNative:(CTURLResponse *)response
{
    NSString *methodName = response.methodName;
    NSDictionary *result = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:methodName];
    
    if (result) {
        self.isNativeDataEmpty = NO;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            CTURLResponse *response = [[CTURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:NULL] messageType:response.messageType metName:response.methodName serType:kServiceIndefiniteForMain reqType:response.requestType];
            [strongSelf successedOnCallingAPI:response];
        });
    } else {
        self.isNativeDataEmpty = YES;
    }
}

#pragma mark - getters and setters
- (CTCache *)cache
{
    if (_cache == nil) {
        _cache = [CTCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [CTAppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = CTAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)shouldLoadFromNative
{
    return NO;
}

@end
