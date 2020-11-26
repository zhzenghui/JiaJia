//
//  AppDelegate.m
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "AppDelegate.h"
#import <WeiboSDK.h>
#import "ViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) id viewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:true];
    [WeiboSDK registerApp:@"4237188095" universalLink:@"https://www.yuenvshen.com/"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    double launchTime = CFAbsoluteTimeGetCurrent();
//    Class cls = NSClassFromString(@"WKBrowsingContextController");
//    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
//    if ([cls respondsToSelector:sel]) {
//        // 通过 http 和 https 的请求，同理可通过其他的 Scheme 但是要满足 URL Loading System
//        [cls performSelector:sel withObject:@"http"];
//        [cls performSelector:sel withObject:@"https"];
//    }
//    NSLog(@"launchTime = %f秒", CFAbsoluteTimeGetCurrent() - launchTime);

    self.viewController = [[ViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    __weak id weakSelf = self;
    return [WeiboSDK handleOpenURL:url delegate:weakSelf];
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    __weak id weakSelf = self;
//    return [WeiboSDK handleOpenURL:url delegate:weakSelf];
//}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation  {
    __weak id weakSelf = self;
    return [WeiboSDK handleOpenURL:url delegate:weakSelf];

}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType API_AVAILABLE(ios(8.0)) {
    return true;
}


#pragma mark -

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        NSLog(@"%@", response.userInfo);
    }
    
    
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

@end
