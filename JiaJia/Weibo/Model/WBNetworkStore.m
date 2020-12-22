//
//  WBNetworkStore.m
//  JiaJia
//
//  Created by zeng on 2020/11/29.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "WBNetworkStore.h"
#import "Weibo.h"
#import <AFNetworking/AFNetworking.h>
#import "WBTimelineItem.h"
#import "NSObject+ZModel.h"


static WBNetworkStore *obj = nil;

@implementation WBNetworkStore
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"
static NSString *weiboKey = @"weibo_key";

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[WBNetworkStore alloc] init];
    });
    return obj;
}

- (id)init {
    self = [super init];
    _timeLineItem = [[WBTimelineItem alloc] init];
    return self;
}

+ (NSString *)changedNotification {
    static NSString *fooDict = nil;
    if (fooDict == nil) {
      // create dict
        fooDict= @"StoreChanged";
    }
    return fooDict;
}

- (void)getHome:(NSString *)sinceID maxID:(NSString *)maxID {
    //https://api.weibo.com/2/statuses/home_timeline.json
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString *URLString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"access_token": [Weibo shareInstance].user.accessToken}];
    if (maxID) {
        [parameters setObject:maxID forKey:@"max_id"];
    }
    if (sinceID) {
        [parameters setObject:sinceID forKey:@"since_id"];
    }
    
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", [NSThread currentThread]);
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        WBTimelineItem *item = [WBTimelineItem modelWithDictionary:(NSDictionary *)responseObject];
        for (WBStatus *status in item.statuses) {
            NSLog(@"%@", status.idstr);
            NSLog(@"%@", status.pics);
        }
        self.timeLineItem = item;
        NSDictionary *dict = @{};
        if ([maxID isEqualToString:@"0"]) {
            dict = @{KchangeReasonKey:Kfirst};
        }
        else {
            dict = @{KchangeReasonKey:Kadded};
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WBNetworkStore.changedNotification object:item userInfo:dict];
    }];
    [dataTask resume];
    
}

- (void)getUserTimeline:(NSString *)sinceID maxID:(NSString *)maxID {
    //https://api.weibo.com/2/statuses/home_timeline.json
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString *URLString = @"https://api.weibo.com/2/statuses/user_timeline.json";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"access_token": [Weibo shareInstance].user.accessToken}];
    if (maxID) {
        [parameters setObject:maxID forKey:@"max_id"];
    }
    if (sinceID) {
        [parameters setObject:sinceID forKey:@"since_id"];
    }

    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", [NSThread currentThread]);
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        WBTimelineItem *item = [WBTimelineItem modelWithDictionary:(NSDictionary *)responseObject];
        for (WBStatus *status in item.statuses) {
            NSLog(@"%@", status.idstr);
            NSLog(@"%@", status.pics);
            
        }
        
        
    https://video.weibo.com/media/play?livephoto=https%3A%2F%2Fus.sinaimg.cn%2F001ydHXZgx07IAVkwour0f0f01003iCL0k01.mov

        self.timeLineItem = item;
        NSDictionary *dict = @{};
        if ([maxID isEqualToString:@"0"]) {
            dict = @{KchangeReasonKey:Kfirst};
        }
        else {
            dict = @{KchangeReasonKey:Kadded};
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WBNetworkStore.changedNotification object:item userInfo:dict];
    }];

    [dataTask resume];
}



@end
