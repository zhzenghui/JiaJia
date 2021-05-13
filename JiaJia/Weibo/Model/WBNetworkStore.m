//
//  WBNetworkStore.m
//  JiaJia
//
//  Created by zeng on 2020/11/29.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "WBNetworkStore.h"
#import "Weibo.h"
#import <AFNetworking/AFHTTPSessionManager.h>
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
    
//    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
//
//       NSURL *url = [NSURL URLWithString:@"http://168.192.1.18:33322/resources/videos/minion_01.mp4"];
//
//       NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//       //2.下载文件
//       /*
//        第一个参数:请求对象
//        第二个参数:progress 进度回调 downloadProgress
//        第三个参数:destination 回调(目标位置)
//                   有返回值
//                   targetPath:临时文件路径
//                   response:响应头信息
//        第四个参数:completionHandler 下载完成之后的回调
//                   filePath:最终的文件路径
//        */
//       NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//
//           //监听下载进度
//           //completedUnitCount 已经下载的数据大小
//           //totalUnitCount     文件数据的中大小
//           NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
//
//       } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//
//           NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
//
//           NSLog(@"targetPath:%@",targetPath);
//           NSLog(@"fullPath:%@",fullPath);
//
//           return [NSURL fileURLWithPath:fullPath];
//       } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//           NSLog(@"%@",filePath);
//       }];
//
//       //3.执行Task
//       [download resume];
        
    
        
//    //https://api.weibo.com/2/statuses/home_timeline.json
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString *URLString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSString *at = @"";
    if ([Weibo shareInstance].user.accessToken) {
        at = [Weibo shareInstance].user.accessToken;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"access_token": at}];
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
            NSNumber *str = responseObject[@"error_code"];
            if (str == 21327) {
                [[Weibo shareInstance] cleanWeiboUser];
            }
            [[Weibo shareInstance] reqSSOWeiboUser];
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
        
        
//    https://video.weibo.com/media/play?livephoto=https%3A%2F%2Fus.sinaimg.cn%2F001ydHXZgx07IAVkwour0f0f01003iCL0k01.mov

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
