//
//  DailyEpisodesListVC.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "DailyEpisodesListVC.h"
#import "CLWeeklyCalendarView.h"
#import "EpisodesTVC.h"
#import "DailyEpisodes.h"
#import "Episode.h"
#import "NSDate+CL.h"
#import "MJRefresh.h"
#import "User.h"
#import "ShowDetailsVC.h"

@interface DailyEpisodesListVC () <UITableViewDelegate, UITableViewDataSource, CLWeeklyCalendarViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CLWeeklyCalendarView* calendarView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic) DailyEpisodes *dailyEpisodes;

@end

@implementation DailyEpisodesListVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.allowsSelection = NO;
        _tableView.estimatedRowHeight = 100;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchData)];
    }
    return _tableView;
}

- (CLWeeklyCalendarView *)calendarView
{
    if (!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70.f)];
        _calendarView.delegate = self;
        _calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _calendarView;
}

- (DailyEpisodes *)dailyEpisodes {
    if (!_dailyEpisodes) {
        _dailyEpisodes = [[DailyEpisodes alloc] init];
    }
    return _dailyEpisodes;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithRed:37.0/255.0 green:185.0/255.0 blue:244.0/255.0 alpha:1.0];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(titleLabelDidClick)]];
    }
    return _titleLabel;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.titleLabel;
    UIView *blackLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width, 1.f)];
    blackLineView.backgroundColor = [UIColor colorWithRed:170.0/255.0
                                                    green:170.0/255.0
                                                     blue:170.0/255.0
                                                    alpha:1.f];
    [self.calendarView addSubview:blackLineView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.calendarView];
    NSMutableArray *cs = [NSMutableArray array];
    NSDictionary *vs = @{@"tlg": self.topLayoutGuide,
                         @"tableView": self.tableView,
                         @"calendarView": self.calendarView};
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[calendarView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tlg][calendarView(==70)][tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [self.view addConstraints:cs];
    
//    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)titleLabelDidClick {
    [self.calendarView redrawToDate:[NSDate date]];
}

- (void)fetchData {
    DailyEpisodesListVC __weak *weakSelf = self;
    [DailyEpisodes fetchDailyEpisodesWithDate:self.calendarView.selectedDate
                                      success:^(DailyEpisodes *dailyEpisodes) {
                                          weakSelf.dailyEpisodes = dailyEpisodes;
                                          [weakSelf.tableView reloadData];
                                          [weakSelf.tableView.mj_header endRefreshing];
                                      }
                                      failure:^(NSError *error) {
                                          NSLog(@"[DailyEpisodesListVC]%@", error);
                                          [weakSelf.tableView.mj_header endRefreshing];
                                      }];
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
        return self.dailyEpisodes.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EpisodesTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [EpisodesTVC cell];
        }
        [cell updateWithEpisode:self.dailyEpisodes.list[indexPath.row]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShowDetailsVC *vc = [ShowDetailsVC viewControllerWithShowID:((Episode *)self.dailyEpisodes.list[indexPath.row]).showID];
        [self.navigationController showViewController:vc
                                               sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 105;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - CLWeeklyCalendarViewDelegate

- (NSDictionary *)CLCalendarBehaviorAttributes {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday
                                               fromDate:[NSDate date]];
    return @{CLCalendarWeekStartDay : [NSNumber numberWithInt:(components.weekday+2)%7+1], //Start Day of the week, from 1-7 Mon-Sun -- default 1
             CLCalendarDayTitleTextColor : [UIColor blackColor],
             CLCalendarSelectedDatePrintFormat : @"yyyy MMM d, EEE", //Selected Date print format,  - Default: @"EEE, d MMM yyyy"
             CLCalendarBackgroundImageColor : [UIColor whiteColor]
        };
}

- (void)dailyCalendarViewDidSelect:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self.calendarView.selectedDate];
//    if([self.calendarView.selectedDate isDateToday]){
//        strDate = [NSString stringWithFormat:@"Today, %@", strDate];
//    }
    self.titleLabel.text = strDate;
    if ([strDate isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
        self.titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:147.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
    [self.tableView.mj_header beginRefreshing];
}

@end
