//
//  AXService.h
//  RTNetworking
//
//  Created by casa on 14-5-15.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTNetworkingConfiguration.h"

// 所有CTService的派生类都要符合这个protocal
@protocol CTServiceProtocal <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *baseUrl;

@property (nonatomic, readonly) NSString *token;

@end

@interface CTService : NSObject

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

@property (nonatomic, readonly) NSString *apiToken;

@property (nonatomic, weak) id<CTServiceProtocal> child;

@end
