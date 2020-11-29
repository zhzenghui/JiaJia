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
#import "WBNetworkStore.h"
#import "ImageTableViewCell.h"
#import "WBStatusLayout.h"
#import "YYTableView.h"
#import "WBStatusCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;

@end

@implementation ViewController


- (instancetype)init {
    self = [super init];
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = [NSMutableArray new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeNotification:) name:WBNetworkStore.changedNotification object:nil];
    
    
}

#pragma mark - method

- (void)initViews {
    [self.view addSubview:_tableView];
    
    _tableView.frame = self.view.frame;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];

    
    self.tableView = _tableView;
    [self.tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:@"cell"];

}

- (void)handleChangeNotification:(NSNotification *)notification {
    
    NSLog(@"notification");
    
    if (!notification.object) {
        return;
    }
    
    if ([notification.object isKindOfClass:[WBTimelineItem class]]) {

        WBTimelineItem *items = notification.object;
        NSLog(@"notification %@", notification.userInfo);
        self.timeLineItem = items;
        for (WBStatus *status in items.statuses) {
            WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
//                [layout layout];
            [_layouts addObject:layout];
        }
        
        NSString *reason = notification.userInfo[KchangeReasonKey];
        if ([reason isEqualToString: Kadded]) {
            
        }
        else if ([reason isEqualToString: Kremoved]) {

        }
        else {
            [self.tableView reloadData];
        }

    }
    
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
    [WBNetworkStore.shareInstance getHome:@"1"];;
//
//    //https://api.weibo.com/2/statuses/home_timeline.json
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    NSString *URLString = @"https://api.weibo.com/2/statuses/home_timeline.json";
//    NSDictionary *parameters = @{@"access_token": [Weibo shareInstance].user.accessToken, @"feature":@2};
//    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
//    
//
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//            
//    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"%@", [NSThread currentThread]);
//        WBTimelineItem *item = [WBTimelineItem modelWithDictionary:(NSDictionary *)responseObject];
//        for (WBStatus *status in item.statuses) {
//            NSLog(@"%@", status.idstr);
//            NSLog(@"%@", status.pics);
//        }
//    }];
//
//    [dataTask resume];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((WBStatusLayout *)_layouts[indexPath.row]).height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";

    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
//    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
//
//
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
//    }
//
//    WBStatus *status = (WBStatus *)self.timeLineItem.statuses[indexPath.row];
//    [cell setPlaceholderImageWithName:nil];
//    NSLog(@"set table view cell%@", status.text);
////    [cell performSelector:@selector(setImageWithName:) withObject:s afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
//
//    return cell;
}

@end

