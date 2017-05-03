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

@interface DiscoveryVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) ShowList *topShowList;

@end

@implementation DiscoveryVC

+ (DiscoveryVC *)viewController {
    DiscoveryVC *vc = (DiscoveryVC *)[[NSBundle mainBundle] loadNibNamed:@"DiscoveryVC"
                                                                   owner:nil
                                                                 options:nil].firstObject;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = 134;
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchTopShowListData)];
}

- (ShowList *)topShowList {
    if (!_topShowList) {
        _topShowList = [[ShowList alloc] init];
    }
    return _topShowList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView.mj_header beginRefreshing];
    [self fetchTopShowListData];
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
}

- (void)fetchTopShowListData {
    DiscoveryVC __weak *weakSelf = self;
    [self.topShowList fetchTopShowListWithSuccess:^{
                                              [weakSelf.tableView reloadData];
                                              [weakSelf.tableView.mj_header endRefreshing];
                                          }
                                          failure:^(NSError *error) {
                                              NSLog(@"[DiscoveryVC]%@", error);
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
        return self.topShowList.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TopShowTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"TopShowTVC"];
        if (!cell) {
            cell = [TopShowTVC cell];
        }
        [cell updateWithShow:self.topShowList.list[indexPath.row] place:indexPath.row+1];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShowDetailsVC *vc = [ShowDetailsVC viewControllerWithShowID:((Show *)self.topShowList.list[indexPath.row]).showID];
        [self.navigationController showViewController:vc
                                               sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    }
    return UITableViewAutomaticDimension;
}

@end
