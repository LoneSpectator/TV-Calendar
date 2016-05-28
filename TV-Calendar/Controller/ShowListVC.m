//
//  ShowListVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/24.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowListVC.h"
#import "MJRefresh.h"
#import "ShowTVC.h"
#import "ShowDetailsVC.h"
#import "ShowList.h"
#import "Show.h"

@interface ShowListVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) ShowList *showList;

@end

@implementation ShowListVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                    refreshingAction:@selector(fetchMoreData)];
        _tableView.estimatedRowHeight = 134;
    }
    return _tableView;
}

- (ShowList *)showList {
    if (!_showList) {
        _showList = [[ShowList alloc] init];
    }
    return _showList;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.title = @"影视库";
    
    [self.view addSubview:self.tableView];
    NSMutableArray *cs = [NSMutableArray array];
    NSDictionary *vs = @{@"tlg": self.topLayoutGuide,
                         @"tableView": self.tableView};
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tlg][tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [self.view addConstraints:cs];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    ShowListVC  __weak *weakSelf = self;
    [self.showList fetchAllShowListFirstPageWithLimit:20
                                              success:^{
                                                  [weakSelf.tableView reloadData];
                                                  [weakSelf.tableView.mj_header endRefreshing];
                                                  [weakSelf.tableView.mj_footer resetNoMoreData];
                                              }
                                              failure:^(NSError *error) {
                                                  NSLog(@"[ShowDetailsVC]%@", error);
                                                  [weakSelf.tableView.mj_header endRefreshing];
                                                  UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"发生了一点小问题！"
                                                                                                              message:@"请下拉刷新"
                                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                                  [ac addAction:[UIAlertAction actionWithTitle:@"好的"
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:nil]];
                                              }];
}

- (void)fetchMoreData {
    int returnNum;
    ShowListVC  __weak *weakSelf = self;
    returnNum = [self.showList fetchAllShowListNextPageWithLimit:20
                                                         success:^{
                                                             [weakSelf.tableView reloadData];
                                                             [weakSelf.tableView.mj_footer endRefreshing];
                                                         }
                                                         failure:^(NSError *error) {
                                                             NSLog(@"[ShowDetailsVC]%@", error);
                                                             [weakSelf.tableView.mj_footer endRefreshing];
                                                             UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"发生了一点小问题！"
                                                                                                                         message:@"请再试一次"
                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                             [ac addAction:[UIAlertAction actionWithTitle:@"好的"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                  handler:nil]];
                                                         }];
    if (returnNum == 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)refresh {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.showList.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShowTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [ShowTVC cell];
        }
        [cell updateWithShow:self.showList.list[indexPath.row]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShowDetailsVC *vc = [ShowDetailsVC viewControllerWithShowID:((Show *)self.showList.list[indexPath.row]).showID];
        [self.navigationController showViewController:vc
                                               sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 134;
    }
    return UITableViewAutomaticDimension;
}

@end
