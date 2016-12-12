//
//  AXService.m
//  RTNetworking
//
//  Created by casa on 14-5-15.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTService.h"
#import "NSObject+AXNetworkingMethods.h"

@implementation CTService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(CTServiceProtocal)]) {
            self.child = (id<CTServiceProtocal>)self;
        }
    }
    return self;
}

#pragma mark - getters and setters
- (NSString *)apiBaseUrl
{
    return self.child.baseUrl;
}

- (NSString *)apiToken
{
    return self.child.token;
}

@end
