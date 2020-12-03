//
//  ViewController.m
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "UserViewController.h"
#import <WeiboSDK.h>
#import "Weibo.h"
#import <AFNetworking/AFNetworking.h>
#import "WBNetworkStore.h"
#import "ImageTableViewCell.h"
#import "WBStatusLayout.h"
#import "YYTableView.h"
#import "WBStatusCell.h"
#import "YYPhotoGroupView.h"


@interface UserViewController () <UITableViewDelegate, UITableViewDataSource, WBStatusCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;

@end

@implementation UserViewController


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
    b.frame = CGRectMake(0, 0, r.size.width, 140);
    [b addTarget:self action:@selector(openButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b1 = [[UIButton alloc] init];
    [self.view addSubview:b1];
    b1.frame = CGRectMake(0, 200, 50, 50);
    [b1 addTarget:self action:@selector(getHome) forControlEvents:UIControlEventTouchUpInside];
    b1.backgroundColor = [UIColor blueColor];
    
    UIButton *b2 = [[UIButton alloc] init];
    [self.view addSubview:b2];
    b2.frame = CGRectMake(0, 400, 50, 50);
    [b2 addTarget:self action:@selector(getMore) forControlEvents:UIControlEventTouchUpInside];
    b2.backgroundColor = [UIColor blueColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeNotification:) name:WBNetworkStore.changedNotification object:nil];
    [[Weibo shareInstance] getWeiboUser];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getHome];
}

#pragma mark - method

- (void)initViews {
    [self.view addSubview:_tableView];
    
    _tableView.frame = self.view.frame;
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
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

        NSString *reason = notification.userInfo[KchangeReasonKey];
        if ([reason isEqualToString: Kfirst]) {
            [_layouts removeAllObjects];
            for (WBStatus *status in items.statuses) {
                WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
                [_layouts addObject:layout];
            }
            [self.tableView reloadData];

        }
        else if ([reason isEqualToString: Kadded]) {
            NSMutableArray<NSIndexPath *> *paths = [NSMutableArray new];
            NSInteger first = _layouts.count - 1 ;
            for (WBStatus *status in items.statuses) {
                WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
                [_layouts addObject:layout];
                first ++;
                NSIndexPath *path = [NSIndexPath indexPathForRow:first inSection:0];
                [paths addObject:path];
            }
//            [self.tableView scrollToBottom];
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
            
        }
        else {
            [self.tableView reloadData];
        }

    }
    
}


- (void)openButton {
    [self openWeibo];
}



- (void)openWeibo {
    [[Weibo shareInstance] reqSSOWeiboUser];
}

- (void)getMore {
    if( ![self.timeLineItem.maxID isEqualToString:@"0"]  ) {
        [WBNetworkStore.shareInstance getUserTimeline:@"0" maxID:self.timeLineItem.maxID];
    }
    

}
- (void)getHome {
    [[Weibo shareInstance] getWeiboUser];

    [WBNetworkStore.shareInstance getUserTimeline:@"0" maxID:@"0"];
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

//#pragma mark - WBStatusCellDelegate
//
//
///// 点击了图片
//- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
//    UIView *fromView = nil;
//    NSMutableArray *items = [NSMutableArray new];
//    WBStatus *status = cell.statusView.layout.status;
//    NSArray<WBPicture *> *pics = status.retweetedStatus ? status.retweetedStatus.pics : status.pics;
//
//    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
//        UIView *imgView = cell.statusView.picViews[i];
//        WBPicture *pic = pics[i];
//        WBPictureMetadata *meta = pic.largest.badgeType == WBPictureBadgeTypeGIF ? pic.largest : pic.large;
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = imgView;
//        item.largeImageURL = meta.url;
//        item.largeImageSize = CGSizeMake(meta.width, meta.height);
//        [items addObject:item];
//        if (i == index) {
//            fromView = imgView;
//        }
//    }
//
//    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
//}


#pragma mark - WBStatusCellDelegate
// 此处应该用 Router 之类的东西。。。这里只是个Demo，直接全跳网页吧～

/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell {
    
}

/// 点击了 Card
- (void)cellDidClickCard:(WBStatusCell *)cell {
    WBPageInfo *pageInfo = cell.statusView.layout.status.pageInfo;
    NSString *url = pageInfo.pageURL; // sinaweibo://... 会跳到 Weibo.app 的。。
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    vc.title = pageInfo.pageTitle;
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了转发内容
- (void)cellDidClickRetweet:(WBStatusCell *)cell {
    
}

/// 点击了 Cell 菜单
- (void)cellDidClickMenu:(WBStatusCell *)cell {
    
}

/// 点击了下方 Tag
- (void)cellDidClickTag:(WBStatusCell *)cell {
    WBTag *tag = cell.statusView.layout.status.tagStruct.firstObject;
    NSString *url = tag.tagScheme; // sinaweibo://... 会跳到 Weibo.app 的。。
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    vc.title = tag.tagName;
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了关注
- (void)cellDidClickFollow:(WBStatusCell *)cell {
    
}

/// 点击了转发
- (void)cellDidClickRepost:(WBStatusCell *)cell {
//    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
//    vc.type = WBStatusComposeViewTypeRetweet;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    @weakify(nav);
//    vc.dismiss = ^{
//        @strongify(nav);
//        [nav dismissViewControllerAnimated:YES completion:NULL];
//    };
//    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell {
//    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
//    vc.type = WBStatusComposeViewTypeComment;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    @weakify(nav);
//    vc.dismiss = ^{
//        @strongify(nav);
//        [nav dismissViewControllerAnimated:YES completion:NULL];
//    };
//    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell {
    WBStatus *status = cell.statusView.layout.status;
    [cell.statusView.toolbarView setLiked:!status.attitudesStatus withAnimation:YES];
}

/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUser *)user {
//    if (user.userID == 0) return;
//    NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/u/%lld",user.userID];
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    WBStatus *status = cell.statusView.layout.status;
    NSArray<WBPictureUrl *> *pics = status.retweetedStatus ? status.retweetedStatus.pics : status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        WBPictureUrl *pic = pics[i];
//        WBPictureMetadata *meta = pic.largest;
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = pic.largest.url;
//        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// 点击了 Label 的链接
- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
//    NSAttributedString *text = label.textLayout.text;
//    if (textRange.location >= text.length) return;
//    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
//    NSDictionary *info = highlight.userInfo;
//    if (info.count == 0) return;
//
//    if (info[kWBLinkHrefName]) {
//        NSString *url = info[kWBLinkHrefName];
//        YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
//    if (info[kWBLinkURLName]) {
//        WBURL *url = info[kWBLinkURLName];
//        WBPicture *pic = url.pics.firstObject;
//        if (pic) {
//            // 点击了文本中的 "图片链接"
//            YYTextAttachment *attachment = [label.textLayout.text attribute:YYTextAttachmentAttributeName atIndex:textRange.location];
//            if ([attachment.content isKindOfClass:[UIView class]]) {
//                YYPhotoGroupItem *info = [YYPhotoGroupItem new];
//                info.largeImageURL = pic.large.url;
//                info.largeImageSize = CGSizeMake(pic.large.width, pic.large.height);
//
//                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[info]];
//                [v presentFromImageView:attachment.content toContainer:self.navigationController.view animated:YES completion:nil];
//            }
//
//        } else if (url.oriURL.length){
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url.oriURL]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        return;
//    }
//
//    if (info[kWBLinkTagName]) {
//        WBTag *tag = info[kWBLinkTagName];
//        NSLog(@"tag:%@",tag.tagScheme);
//        return;
//    }
//
//    if (info[kWBLinkTopicName]) {
//        WBTopic *topic = info[kWBLinkTopicName];
//        NSString *topicStr = topic.topicTitle;
//        topicStr = [topicStr stringByURLEncode];
//        if (topicStr.length) {
//            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@",topicStr];
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        return;
//    }
//
//    if (info[kWBLinkAtName]) {
//        NSString *name = info[kWBLinkAtName];
//        name = [name stringByURLEncode];
//        if (name.length) {
//            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        return;
//    }
}



@end

