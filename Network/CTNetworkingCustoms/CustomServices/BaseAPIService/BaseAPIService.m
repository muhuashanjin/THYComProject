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

- (NSString *)baseUrl
{
    extern NSString *baseUrl;
    return baseUrl;
}

- (NSString *)token
{
    return [CTAppContext sharedInstance].apiToken;
}

@end
