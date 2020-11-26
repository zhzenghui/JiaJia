//
//  ViewController.m
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "ViewController.h"
#import <WeiboSDK.h>
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    CGRect r = self.view.frame;

    UIButton *b = [[UIButton alloc] init];
    [self.view addSubview:b];
    b.frame = CGRectMake(0, 0, r.size.width, r.size.height);
    [b addTarget:self action:@selector(openButton) forControlEvents:UIControlEventTouchUpInside];

}

- (void)openButton {

    [self openWeibo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)openWeibo {
    WBAuthorizeRequest *req = [WBAuthorizeRequest request];
    req.redirectURI = kRedirectURL;
    [req setScope:@"all"];
    [req setUserInfo:@{@"sso":@"sendlogin", @"Other_Info_1": @123}];
    [WeiboSDK sendRequest:req completion:^(BOOL success) {
        NSLog(@"成功%i", success);
    }];}
@end

