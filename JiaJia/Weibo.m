//
//  Weibo.m
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "Weibo.h"
#import <WeiboSDK.h>


static Weibo *obj = nil;

@implementation Weibo

#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"
static NSString *weiboKey = @"weibo_key";

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[Weibo alloc] init];
    });
    return obj;
}

- (id)init {
    self = [super init];
    _user = [[User alloc] init];
    return self;
}

- (void)reqSSOWeiboUser {
    WBAuthorizeRequest *req = [WBAuthorizeRequest request];
    req.redirectURI = kRedirectURL;
    [req setScope:@"all"];
    [req setUserInfo:@{@"sso":@"sendlogin", @"Other_Info_1": @123}];
    [WeiboSDK sendRequest:req completion:^(BOOL success) {
        NSLog(@"成功%i", success);
    }];
}

- (void)setWeiboUser:(NSDictionary *)dict {
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:weiboKey];
    NSLog(@"%@", dict);
    self.user.name = dict[@"app"];
    self.user.accessToken = dict[@"access_token"];
    self.user.refreshToken = dict[@"refresh_token"];
}
- (void)getWeiboUser {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:weiboKey];
    self.user.name = dict[@"app"];
    self.user.accessToken = dict[@"access_token"];
    self.user.refreshToken = dict[@"refresh_token"];
//    self.user.accessToken = @"2.00KuUszBTLokcEf5b59341f00WPiVG";
    NSLog(@"set user success token %@", self.user.accessToken);

}


@end
