//
//  BaseAPIService.m
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "BaseAPIService.h"
#import "CTAppContext.h"

@implementation BaseAPIService

#pragma mark - CTServiceProtocal
- (BOOL)isOnline
{
    return [CTAppContext sharedInstance].isOnline;
}

- (NSString *)offlineApiBaseUrl
{
    extern NSString *baseUrl;
    return baseUrl;
}

- (NSString *)onlineApiBaseUrl
{
    extern NSString *baseUrl;
    return baseUrl;
}

- (NSString *)offlineApiVersion
{
    return @"";
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";
}

- (NSString *)offlinePublicKey
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}
@end
