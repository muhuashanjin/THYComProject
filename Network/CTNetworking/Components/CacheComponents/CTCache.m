//
//  CTCache.m
//  RTNetworking
//
//  Created by casa on 14-5-26.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTCache.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "CTNetworkingConfiguration.h"

@interface CTCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation CTCache

#pragma mark - getters and setters
- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kCTCacheCountLimit;
    }
    return _cache;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public method
- (CTCachedObject *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                     messageType:(int)messageType
                                   requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams messageType:messageType]];
}

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
              messageType:(int)messageType
            requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData messageType:messageType key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams messageType:messageType]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                             messageType:(int)messageType
                           requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams messageType:messageType]];
}

- (CTCachedObject *)fetchCachedDataWithKey:(NSString *)key
{
    CTCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData messageType:(int)messageType key:(NSString *)key
{
    CTCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[CTCachedObject alloc] init];
    }
    [cachedObject updateContent:cachedData messageType:messageType];
    [self.cache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)clean
{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams messageType:(int)messageType
{
    return [NSString stringWithFormat:@"%@%@%@/%d", serviceIdentifier, methodName, [requestParams CT_urlParamsStringSignature:NO],messageType];
}

#pragma mark - private method
@end
