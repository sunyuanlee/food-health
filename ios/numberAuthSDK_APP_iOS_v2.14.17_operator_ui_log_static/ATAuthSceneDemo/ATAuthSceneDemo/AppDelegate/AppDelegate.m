//
//  AppDelegate.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "AppDelegate.h"
#import "PNSMainController.h"
#import "PNSBaseNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    
    PNSMainController *controller = [[PNSMainController alloc] init];
    PNSBaseNavigationController *navigationController = [[PNSBaseNavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    /**
     *  设置 ATAuthSDK 的秘钥信息
     *  建议该信息维护在自己服务器端
     *  放在程序入口处调用效果最佳
     */
    [PNSHttpsManager requestATAuthSDKInfo:^(BOOL isSuccess, NSString * _Nonnull authSDKInfo) {
        if (isSuccess) {
            // 省略
        }
    }];
    /* Demo展示直接使用宏PNSATAUTHSDKINFO进行赋值 */
    
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:PNSATAUTHSDKINFO
                                            complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"设置秘钥结果：%@", resultDic);
        
    }];
    
    return YES;
}

@end
