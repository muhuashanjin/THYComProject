//
//  LoginExtension.h
//  THYComProject
//
//  Created by thy on 2017/4/12.
//  Copyright © 2017年 thy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginExtension : NSObject <ExtensionHandle>

typedef enum {
    kTaskMsg_Login_Base ,
}taskMsg_Login;

#define kURL_Main_TestLogin @"" kBaseUrl "/bdCustomerLogin.json?username=13062717779&wechat=wx_qiakrtest9"

@end
