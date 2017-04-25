//
//  ShowDetailsVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/14.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowDetailsVC.h"
#import "Show.h"
#import "Season.h"
#import "Episode.h"
#import "MJRefresh.h"
#import "ShowDetailsTVC.h"
#import "LocalizedString.h"

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        _tableView.estimatedRowHeight = 350;
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
                            for (int i = 0; i < show.quantityOfSeason; i++) {
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
        ShowDetailsVC __weak *weakSelf = self;
        cell.refreshTableViewBlock = ^{
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        };
        [cell updateWithShow:self.show];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 20;
}

@end
