//
//  ViewController.m
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "ViewController.h"
#import <WeiboSDK.h>
#import "Weibo.h"
#import <AFNetworking/AFNetworking.h>
#import "WBTimelineItem.h"
#import "NSObject+ZModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    CGRect r = self.view.frame;

    UIButton *b = [[UIButton alloc] init];
    [self.view addSubview:b];
    b.frame = CGRectMake(0, 0, r.size.width, 100);
    [b addTarget:self action:@selector(openButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b1 = [[UIButton alloc] init];
    [self.view addSubview:b1];
    b1.frame = CGRectMake(0, 100, r.size.width, 100);
    [b1 addTarget:self action:@selector(getHome) forControlEvents:UIControlEventTouchUpInside];
    b1.backgroundColor = [UIColor blueColor];
    
}

- (void)openButton {
    [self openWeibo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[Weibo shareInstance] getWeiboUser];

}

- (void)openWeibo {
    [[Weibo shareInstance] reqSSOWeiboUser];
}

- (void)getHome {
    //https://api.weibo.com/2/statuses/home_timeline.json
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString *URLString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSDictionary *parameters = @{@"access_token": [Weibo shareInstance].user.accessToken};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        WBTimelineItem *item = [WBTimelineItem modelWithDictionary:(NSDictionary *)responseObject];
        
        for (WBStatus *status in item.statuses) {
            NSLog(@"%@", status.idstr);

        }
    }];

    [dataTask resume];
}

@end

