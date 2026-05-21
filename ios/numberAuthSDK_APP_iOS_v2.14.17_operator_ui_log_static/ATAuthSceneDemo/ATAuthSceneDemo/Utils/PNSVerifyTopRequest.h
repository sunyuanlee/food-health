//
//  PNSVerifyTopRequest.h
//  AliComSDKDemo
//
//  Created by 刘超的MacBook on 2019/9/9.
//  Copyright © 2019 alicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXTestSceneViewController.h"

#define TXUserDefaults [NSUserDefaults standardUserDefaults]
#define TX_Top_Request_Environment_Key      @"TX_AliComSDKDemo_Env"

// 1为预发，0为线上
#define Top_URL_Is_Debug  ([TXUserDefaults integerForKey:TX_Top_Request_Environment_Key] == TX_Top_Request_Environment_Online ? 0 : 1)

#define Top_Release_URL     @"https://eco.taobao.com/router/rest"
#define Top_Debug_URL       @"http://140.205.57.248/top/router/rest"

NS_ASSUME_NONNULL_BEGIN

@interface PNSVerifyTopRequest : NSObject


+ (void)requstVerifyWithNumber:(NSString *)number token:(NSString *)token complete:(void (^_Nullable)(BOOL isSuccess, NSString *msg, NSDictionary *data))complete;

+ (void)requestLoginWithToken:(NSString *)token complete:(void (^_Nullable)(BOOL isSuccess, NSString *msg, NSDictionary *data))complete;

@end

NS_ASSUME_NONNULL_END
