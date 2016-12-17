//
//  AXNetworkingConfiguration.h
//  RTNetworking
//
//  Created by casa on 14-5-13.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#ifndef CTNetworking_CTNetworkingConfiguration_h
#define CTNetworking_CTNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, CTAppType) {
    CTAppTypexxx
};

typedef NS_ENUM(NSUInteger, CTURLResponseStatus)
{
    CTURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CTAPIBaseManager来决定。
    CTURLResponseStatusErrorTimeout,
    CTURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSString *CTKeychainServiceName = @"xxxxx";
static NSString *CTUDIDName = @"xxxx";
static NSString *CTPasteboardType = @"xxxx";

static BOOL kCTShouldCache = YES;
static BOOL kCTServiceIsOnline = NO;
static NSTimeInterval kCTNetworkingTimeoutSeconds = 20.0f;       // 网络请求超时时间
static NSTimeInterval kCTCacheOutdateTimeSeconds = 5;           // cache过期时间
static NSUInteger kCTCacheCountLimit = 1000;                     // cache最多条数限制

// services
extern NSString * const kServiceIndefiniteForMain;

#endif
