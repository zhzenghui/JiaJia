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
#import "UserViewController.h"
#import "Weibo.h"
#import "ZHWebViewController.h"
#import "T1HomeTimelineItemsViewController.h"
#import "PPSURLProtocol.h"

@interface AppDelegate ()
@property (strong, nonatomic) id viewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [PPSURLProtocol start];

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
    UIViewController *vc = [[ViewController alloc] init];
    vc.title = @"timeline";
    vc.tabBarItem.title = @"timeline";
    vc.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *vc1 = [[UserViewController alloc] init];
    vc1.tabBarItem.title = @"userline";
    vc1.title = @"userline";

    vc1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    
//    ZHWebViewController *vc2 = [[ZHWebViewController alloc] init];
//    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
//    T1HomeTimelineItemsViewController *vc2 = [[T1HomeTimelineItemsViewController alloc] init];
//    vc2.title = @"twitter";
//    vc2.tabBarItem.title = @"twitter";
//    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    tab.viewControllers = @[ nav, nav1 ];
    
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
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
        [[Weibo shareInstance] setWeiboUser:response.userInfo];
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

@end
