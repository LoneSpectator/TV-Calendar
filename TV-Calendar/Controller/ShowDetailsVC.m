//
//  ShowDetailsVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/14.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowDetailsVC.h"
#import "Show.h"
#import "Episode.h"
#import "MJRefresh.h"
#import "ShowDetailsTVC.h"

@interface ShowDetailsVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) Show *show;

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.allowsSelection = NO;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchData)];
        _tableView.estimatedRowHeight = 350;
    }
    return _tableView;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    
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

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
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
                            [weakSelf.tableView reloadData];
                            [weakSelf.tableView.mj_header endRefreshing];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
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

@end
