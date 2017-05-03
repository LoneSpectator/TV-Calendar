//
//  ShowDetailsVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/14.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowDetailsVC.h"
#import "LocalizedString.h"
#import "Show.h"
#import "Season.h"
#import "Episode.h"
#import "MJRefresh.h"
#import "ShowDetailsTVC.h"
#import "ShowDetailsTVEpHeaderView.h"
#import "ShowDetailsTVEpCell.h"

@interface ShowDetailsVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) Show *show;
@property (nonatomic) NSMutableArray *seTagArray;

@end

@implementation ShowDetailsVC

+ (ShowDetailsVC *)viewControllerWithShowID:(NSInteger)showID {
    ShowDetailsVC *vc = [[ShowDetailsVC alloc] init];
    vc.show.showID = showID;
    return vc;
}

- (Show *)show {
    if (!_show) {
        _show = [[Show alloc] init];
    }
    return _show;
}

- (NSMutableArray *)seTagArray {
    if (!_seTagArray) {
        _seTagArray = [NSMutableArray array];
    }
    return _seTagArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = YES;
        _tableView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        _tableView.estimatedRowHeight = 500;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchData)];
    }
    return _tableView;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    [self.view addSubview:self.tableView];
    NSMutableArray *cs = [NSMutableArray array];
    NSDictionary *vs = @{@"tlg": self.topLayoutGuide,
                         @"tableView": self.tableView};
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-44)-[tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [self.view addConstraints:cs];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ShowDetailsVC-NavBarImg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
    ShowDetailsVC __weak *weakSelf = self;
    [Show fetchShowDetailWithID:self.show.showID
                        success:^(Show *show) {
                            weakSelf.show = show;
                            for (int i = 0; i < self.show.seasonsArray.count; i++) {
                                [weakSelf.seTagArray addObject:@0];
                            }
                            [weakSelf.tableView reloadData];
                            [weakSelf.tableView.mj_header endRefreshing];
                        }
                        failure:^(NSError *error) {
                            NSLog(@"[ShowDetailsVC]%@", error);
                            [weakSelf.tableView.mj_header endRefreshing];
                            UIAlertController *ac = [UIAlertController alertControllerWithTitle:LocalizedString(@"发生了一点小问题！")
                                                                                        message:LocalizedString(@"请再次刷新")
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                            [ac addAction:[UIAlertAction actionWithTitle:LocalizedString(@"好的")
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil]];
                        }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.show.seasonsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (((NSNumber *)self.seTagArray[section-1]).intValue == 0) {
            return 0;
        } else {
            return ((Season *)self.show.seasonsArray[section-1]).episodesArray.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShowDetailsTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowDetailsTVC"];
        if (!cell) {
            cell = [ShowDetailsTVC cell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // 禁止行被选中
        ShowDetailsVC __weak *weakSelf = self;
        cell.refreshTableViewBlock = ^{ // 剧详情行内的简介展开收起时列表页的动态刷新块
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        };
        [cell updateWithShow:self.show];
        return cell;
    } else {
        ShowDetailsTVEpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowDetailsTVEpCell"];
        if (!cell) {
            cell = [ShowDetailsTVEpCell cell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // 禁止行被选中
        [cell updateWithEpisode:((Season *)self.show.seasonsArray[indexPath.section-1]).episodesArray[indexPath.row]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        ShowDetailsTVEpHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShowDetailsTVEpHeaderView"];
        if (!view) {
            view = [ShowDetailsTVEpHeaderView view];
            ShowDetailsVC __weak *weakSelf = self;
            view.refreshTableViewBlock = ^{
                [weakSelf.tableView reloadData];
            };
        }
        ShowDetailsVC __weak *weakSelf = self;
        view.setOpenTagBlock = ^{
            weakSelf.seTagArray[section-1] = (((NSNumber *)self.seTagArray[section-1]).intValue == 0) ? @1 : @0;
            [weakSelf.tableView reloadData];
        };
        [view updateWithSeason:self.show.seasonsArray[section-1] openTag:(((NSNumber *)self.seTagArray[section-1]).intValue != 0)];
        return view;
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor *color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        return;
    }
    if (offsetY > 121) {
        CGFloat alpha = 1.0 - ((174.0 - offsetY) / 53.0);
        self.navigationController.navigationBar.backgroundColor = [color colorWithAlphaComponent:alpha];
    } else {
        self.navigationController.navigationBar.backgroundColor = [color colorWithAlphaComponent:0];
    }
    if (offsetY > 166) {
        [self.navigationController.navigationBar setShadowImage:nil];
        scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    } else {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return 35;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 45;
}

@end
