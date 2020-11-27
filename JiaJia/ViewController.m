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
    
}
@end

