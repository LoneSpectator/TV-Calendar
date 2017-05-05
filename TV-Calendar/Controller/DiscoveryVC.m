//
//  DiscoveryVC.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "DiscoveryVC.h"
#import "MJRefresh.h"
#import "Show.h"
#import "ShowList.h"
#import "ShowDetailsVC.h"
#import "TopShowTVC.h"
#import "LocalizedString.h"
#import "User.h"
#import "LoginVC.h"

@interface DiscoveryVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) ShowList *topShowList;
@property (nonatomic) ShowList *tipShowList;
@property (nonatomic) NSInteger refreshTag;

@end

@implementation DiscoveryVC

+ (DiscoveryVC *)viewController {
    DiscoveryVC *vc = (DiscoveryVC *)[[NSBundle mainBundle] loadNibNamed:@"DiscoveryVC"
                                                                   owner:nil
                                                                 options:nil].firstObject;
    return vc;
}

- (ShowList *)topShowList {
    if (!_topShowList) {
        _topShowList = [[ShowList alloc] init];
    }
    return _topShowList;
}

- (ShowList *)tipShowList {
    if (!_tipShowList) {
        _tipShowList = [[ShowList alloc] init];
    }
    return _tipShowList;
}

- (NSInteger)refreshTag {
    if (!_refreshTag) {
        _refreshTag = 0;
    }
    return _refreshTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = 134;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(refreshData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ShowDetailsVC-NavBarImg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshData];
}

- (void)refreshData {
    [self fetchTopShowListData];
    if (currentUser) {
        [self fetchTipShowListData];
    }
}

- (void)endRefreshingData {
    self.refreshTag--;
    if (self.refreshTag <= 0) {
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)fetchTopShowListData {
    self.refreshTag++;
    DiscoveryVC __weak *weakSelf = self;
    [self.topShowList fetchTopShowListWithSuccess:^{
                                              [weakSelf.tableView reloadData];
                                              [weakSelf endRefreshingData];
                                          }
                                          failure:^(NSError *error) {
                                              NSLog(@"[DiscoveryVC]%@", error);
                                              [weakSelf endRefreshingData];
                                              UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"发生了一点小问题！"
                                                                                                          message:@"请下拉刷新"
                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                              [ac addAction:[UIAlertAction actionWithTitle:@"好的"
                                                                                     style:UIAlertActionStyleDefault
                                                                                   handler:nil]];
                                          }];
}

- (void)fetchTipShowListData {
    self.refreshTag++;
    DiscoveryVC __weak *weakSelf = self;
    [self.tipShowList fetchTipShowListWithSuccess:^{
                                              [weakSelf.tableView reloadData];
                                              [weakSelf endRefreshingData];
                                          }
                                          failure:^(NSError *error) {
                                              NSLog(@"[DiscoveryVC]%@", error);
                                              [weakSelf endRefreshingData];
                                              UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"发生了一点小问题！"
                                                                                                          message:@"请下拉刷新"
                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                              [ac addAction:[UIAlertAction actionWithTitle:@"好的"
                                                                                     style:UIAlertActionStyleDefault
                                                                                   handler:nil]];
                                          }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.topShowList.list.count;
    }
    if (section == 1) {
        if (!currentUser) {
            return 1;
        }
        return self.tipShowList.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TopShowTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"TopShowTVC"];
        if (!cell) {
            cell = [TopShowTVC cell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  // 禁止行被选中
        [cell updateWithShow:self.topShowList.list[indexPath.row] place:indexPath.row+1];
        return cell;
    }
    if (indexPath.section == 1) {
        if (!currentUser) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:nil];
            cell.textLabel.text = LocalizedString(@"点此登录，享受更多个性化推荐！");
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
            return cell;
        }
        TopShowTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"TipShowTVC"];
        if (!cell) {
            cell = [TopShowTVC cell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  // 禁止行被选中
        [cell updateWithShow:self.tipShowList.list[indexPath.row] place:indexPath.row+1];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return LocalizedString(@"24小时热门榜");
    }
    if (section == 1) {
        return LocalizedString(@"每日推荐");
    }
    return @"";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShowDetailsVC *vc = [ShowDetailsVC viewControllerWithShowID:((Show *)self.topShowList.list[indexPath.row]).showID];
        [self.navigationController showViewController:vc
                                               sender:self];
    }
    if (indexPath.section == 1) {
        if (!currentUser) {
            [LoginVC showLoginViewControllerWithSender:self];
        } else {
            ShowDetailsVC *vc = [ShowDetailsVC viewControllerWithShowID:((Show *)self.tipShowList.list[indexPath.row]).showID];
            [self.navigationController showViewController:vc
                                                   sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
    }
    return 35;
}

@end
