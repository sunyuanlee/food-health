//
//  PNSVerifyTopRequest.m
//  AliComSDKDemo
//
//  Created by 刘超的MacBook on 2019/9/9.
//  Copyright © 2019 alicom. All rights reserved.
//

#import "PNSVerifyTopRequest.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation PNSVerifyTopRequest

+ (void)requstVerifyWithNumber:(NSString *)number token:(NSString *)token complete:(void (^)(BOOL, NSString * _Nonnull, NSDictionary * _Nonnull))complete {
    NSMutableDictionary *bizParams = [[NSMutableDictionary alloc] init];
    [bizParams setObject:token forKey:@"token"];
    [bizParams setObject:(number ? number : @"") forKey:@"number"];
    [bizParams setObject:@"100000192864055" forKey:@"customer_id"];
    
    NSString *api = @"alibaba.aliqin.pns.number.verify";
    [self paramsForTopRequest:api bizParams:bizParams result:^(BOOL isSuccess, NSString *msg, NSDictionary *data) {
        if (complete) {
            complete(isSuccess,msg,data);
        }
    }];
}

+ (void)requestLoginWithToken:(NSString *)token complete:(void (^)(BOOL, NSString * _Nonnull, NSDictionary * _Nonnull))complete {
    NSMutableDictionary *bizParams = [[NSMutableDictionary alloc] init];
    [bizParams setObject:token forKey:@"token"];
    [bizParams setObject:@"100000192864055" forKey:@"customer_id"];
    
    NSString *api = @"alibaba.aliqin.pns.mobile.get";
    [self paramsForTopRequest:api bizParams:bizParams result:^(BOOL isSuccess, NSString *msg, NSDictionary *data) {
        if (complete) {
            complete(isSuccess,msg,data);
        }
    }];
}

+ (void )paramsForTopRequest:(NSString *)api bizParams:(NSDictionary *)bizParams result:(void (^_Nullable)(BOOL,NSString *,NSDictionary *))result {
    NSString *urlStr = Top_Release_URL;
    if (Top_URL_Is_Debug == 1) {
        urlStr = Top_Debug_URL;
    }
    
    NSDictionary *params = [self paramsForTopRequest:api bizParams:bizParams];
    NSString *sign = [self getTopRequestSignWithParam:params appSecret:@"241fe87f31de43f69983a59389448243"];
    
    NSArray *keys = [params allKeys];
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    for (int i = 0; i < keys.count; i ++) {
        NSString *key = keys[i];
        NSString *value = params[key];
        if (value.length > 0) {
            if (i == 0) {
                urlStr = [NSString stringWithFormat:@"%@?",urlStr];
            }
            else {
                urlStr = [NSString stringWithFormat:@"%@&",urlStr];
            }
            
            value = [value stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
            urlStr = [NSString stringWithFormat:@"%@%@=%@",urlStr,key,value];
        }
    }
    
    if (sign.length > 0) {
        urlStr = [NSString stringWithFormat:@"%@&sign=%@",urlStr,sign];
    }
    
    NSLog(@"requstVerifyWithParams,url = %@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            if (result) {
                result(NO,error.description,nil);
            }
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *apiKey = [api stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            apiKey = [NSString stringWithFormat:@"%@_response",apiKey];
            NSLog(@"dataTaskWithRequest,data = %@",dic);
            NSDictionary *data = dic[apiKey][@"result"];
            
            // code = OK 表示成功，其他异常
            NSString *code = data[@"code"];
            NSString *message = data[@"message"];
            if ([code isEqualToString:@"OK"]) {
                if (result) {
                    result(YES,nil,data);
                }
            }
            else {
                if (result) {
                    result(NO,nil,data);
                }
            }
        }
        
    }] resume];
}

+ (NSDictionary *)paramsForTopRequest:(NSString *)api bizParams:(NSDictionary *)bizParams {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //必填
    [params setObject:api forKey:@"method"];
    [params setObject:@"25360259" forKey:@"app_key"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    [params setObject:dateStr forKey:@"timestamp"];
    [params setObject:@"2.0" forKey:@"v"];
    [params setObject:@"md5" forKey:@"sign_method"];
    
    //选填
    [params setObject:@"json" forKey:@"format"];
    
    //业务参数
    if (bizParams) {
        [params addEntriesFromDictionary:bizParams];
    }
    
    return params;
}

// MD5加密签名
+ (NSString *)getTopRequestSignWithParam:(NSDictionary *)param appSecret:(NSString *)appSecret {
    NSString *sign = nil;
    
    NSArray *keys = [param allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSLog(@"getTopRequestSignWithParam,sorted keys = %@",sortedKeys);
    
    NSString *sortedParam = @"";
    for (NSString *key in sortedKeys) {
        NSString *value = param[key];
        if (value.length > 0) { // 值为空字符串的过滤
            sortedParam = [NSString stringWithFormat:@"%@%@%@",sortedParam,key,value];
        }
    }
    
    sortedParam = [NSString stringWithFormat:@"%@%@%@",appSecret,sortedParam,appSecret];
    
    NSLog(@"getTopRequestSignWithParam,sortedParam = %@",sortedParam);
    
    sign = [self MD5:sortedParam];
    
    return sign;
}

+ (NSString *)MD5:(NSString *)plainText
{
    const char *cStr = [plainText UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    // 16进制的32位字符输出
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return  output;
}

@end
