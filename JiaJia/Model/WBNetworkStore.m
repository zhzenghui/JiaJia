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

- (void)getHome:(NSString *)page {
    //https://api.weibo.com/2/statuses/home_timeline.json
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString *URLString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSDictionary *parameters = @{@"access_token": [Weibo shareInstance].user.accessToken, @"feature":@2};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", [NSThread currentThread]);
        WBTimelineItem *item = [WBTimelineItem modelWithDictionary:(NSDictionary *)responseObject];
        for (WBStatus *status in item.statuses) {
            NSLog(@"%@", status.idstr);
            NSLog(@"%@", status.pics);
        }
        self.timeLineItem = item;
        NSDictionary *dict = @{};
        if ([page isEqualToString:@"1"]) {
        }
        else {
            dict = @{KchangeReasonKey:Kadded};
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WBNetworkStore.changedNotification object:item userInfo:dict];
    }];

    [dataTask resume];
}

@end
