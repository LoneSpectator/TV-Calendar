//
//  FavouriteShowsVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/10.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "FavouriteShowsVC.h"
#import "LoginVC.h"
#import "User.h"
#import "ShowList.h"
#import "FavouriteShowsTVC.h"
#import "MJRefresh.h"
#import "ShowDetailsVC.h"
#import "Show.h"
#import "LocalizedString.h"
#import "ShowListVC.h"
#import "SettingsVC.h"

@interface FavouriteShowsVC ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *settingsItem;
@property (strong, nonatomic) UIBarButtonItem *addItem;

@property (nonatomic) ShowList *showList;

@end

@implementation FavouriteShowsVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchData)];
    }
    return _tableView;
}

- (ShowList *)showList {
    if (!_showList) {
        _showList = [[ShowList alloc] init];
    }
    return _showList;
}

- (UIBarButtonItem *)settingsItem {
    if (!_settingsItem) {
        _settingsItem = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(showSettingsViewController)];
    }
    return _settingsItem;
}

- (UIBarButtonItem *)addItem {
    if (!_addItem) {
        _addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                 target:self
                                                                 action:@selector(showShowListViewController)];
    }
    return _addItem;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.settingsItem;
    self.navigationItem.rightBarButtonItem = self.addItem;
    
    self.navigationItem.title = LocalizedString(@"我的订阅");
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginViewController {
    [LoginVC showLoginViewControllerWithSender:self];
}

- (void)showShowListViewController {
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:[[ShowListVC alloc] init]];
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self showDetailViewController:nv sender:self];
}

- (void)showSettingsViewController {
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:[[SettingsVC alloc] init]];
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self showDetailViewController:nv sender:self];
}

- (void)fetchData {
    if (!currentUser) {
        [self.showList.list removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    FavouriteShowsVC __weak *weakSelf = self;
    [self.showList fetchFavouriteShowListWithSuccess:^{
                                                  [weakSelf.tableView reloadData];
                                                  [weakSelf.tableView.mj_header endRefreshing];
                                              }
                                              failure:^(NSError *error) {
                                                  NSLog(@"[FavouriteShowsVC]%@", error);
                                                  [weakSelf.tableView.mj_header endRefreshing];
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
        if (currentUser) {
            return 0;
        } else {
            return 1;
        }
    }
    if (section == 1) {
        return self.showList.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:nil];
        cell.textLabel.text = LocalizedString(@"您尚未登录，点此登录！");
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
//        cell.detailTextLabel.text = @"test";
//        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
//        v.backgroundColor = [UIColor redColor];
//        cell.accessoryView = v;
        return cell;
    }
    if (indexPath.section == 1) {
        FavouriteShowsTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteShowsTVC"];
        if (!cell) {
            cell = [FavouriteShowsTVC cell];
        }
        [cell updateWithShow:self.showList.list[indexPath.row]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self showLoginViewController];
    }
    if (indexPath.section == 1) {
        ShowDetailsVC *vc = [ShowDetailsVC viewControllerWithShowID:((Show *)self.showList.list[indexPath.row]).showID];
        [self.navigationController showViewController:vc
                                               sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }
    if (indexPath.section == 1) {
        return 77;
    }
    return UITableViewAutomaticDimension;
}

@end
