//
//  AXApiProxy.h
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTURLResponse.h"

typedef void(^AXCallback)(CTURLResponse *response);

@interface CTApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail;
- (NSInteger)callPUTWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail;
- (NSInteger)callDELETEWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail;
- (NSInteger)callUPLOADWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail;
- (NSInteger)callDOWNLOADWithParams:(NSDictionary *)params urlResponse:(CTURLResponse *)response success:(AXCallback)success fail:(AXCallback)fail;


- (NSNumber *)callApiWithRequest:(NSURLRequest *)request messageType:(int)messageType success:(AXCallback)success fail:(AXCallback)fail;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
