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
#import "LocalizedString.h"
#import "HMSegmentedControl.h"

@interface ShowListVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *segmentedControlView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *backItem;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

@property (nonatomic) ShowList *showList;
@property (nonatomic) NSArray *segmentArr;
//@property NSInteger

@end

@implementation ShowListVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.segmentedControlView addSubview:self.segmentedControl];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 134;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchData)];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreData)];
    
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [_tableView addGestureRecognizer:leftSwipeGR];
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [_tableView addGestureRecognizer:rightSwipeGR];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = LocalizedString(@"影视库");
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
}

+ (ShowListVC *)viewController {
    ShowListVC *vc = (ShowListVC *)[[NSBundle mainBundle] loadNibNamed:@"ShowListVC"
                                                                 owner:nil
                                                               options:nil].firstObject;
    return vc;
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.segmentArr];
        [_segmentedControl setFrame:CGRectMake(0, 0, self.segmentedControlView.frame.size.width, self.segmentedControlView.frame.size.height)];
        _segmentedControl.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _segmentedControl.selectionIndicatorHeight = 3.0f;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:27.0/255.0 green:173.0/255.0 blue:248.0/255.0 alpha:1.0];
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15],
                                                      NSForegroundColorAttributeName: [UIColor blackColor]};
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        
        ShowListVC __weak *weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }
    return _segmentedControl;
}

- (ShowList *)showList {
    if (!_showList) {
        _showList = [[ShowList alloc] init];
    }
    return _showList;
}

- (NSArray *)segmentArr {
    if (!_segmentArr) {
        _segmentArr = @[@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    }
    return _segmentArr;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"返回")
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(back)];
    }
    return _backItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ShowDetailsVC-NavBarImg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
#warning 
    NSLog(@"%ld", (long)self.segmentedControl.selectedSegmentIndex);
    ShowListVC __weak *weakSelf = self;
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
    ShowListVC __weak *weakSelf = self;
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

- (void)swipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.segmentedControl.selectedSegmentIndex - 1 >= 0) {
            [self.segmentedControl setSelectedSegmentIndex:self.segmentedControl.selectedSegmentIndex - 1
                                                  animated:YES];
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.segmentedControl.selectedSegmentIndex + 1 < self.segmentArr.count) {
            [self.segmentedControl setSelectedSegmentIndex:self.segmentedControl.selectedSegmentIndex + 1
                                                  animated:YES];
        }
    }
}

- (void)refresh {
    [self.tableView.mj_header beginRefreshing];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    }
    return UITableViewAutomaticDimension;
}

@end
