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
#import "EpisodeDetailVC.h"

@interface DailyEpisodesListVC () <CLWeeklyCalendarViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CLWeeklyCalendarView* calendarView;

@property (nonatomic) DailyEpisodes *dailyEpisodes;

@end

@implementation DailyEpisodesListVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:53.f/255.f green:53.f/255.f blue:53.f/255.f alpha:1.f];
    _tableView.sectionHeaderHeight = 0.f;
    return _tableView;
}

- (CLWeeklyCalendarView *)calendarView
{
    if (!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120.f)];
        _calendarView.delegate = self;
        _calendarView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _calendarView;
}

- (DailyEpisodes *)dailyEpisodes {
    if (!_dailyEpisodes) {
        _dailyEpisodes = [[DailyEpisodes alloc] init];
    }
    return _dailyEpisodes;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.calendarView];
    NSMutableArray *cs = [NSMutableArray array];
    NSDictionary *vs = @{@"tableView": self.tableView,
                         @"calendarView": self.calendarView,
                         @"tlg": self.topLayoutGuide};
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[calendarView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[calendarView(==120)][tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [self.view addConstraints:cs];
//    [self.view addSubview:]
    
//    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadData {
    self.dailyEpisodes = [DailyEpisodes dailyEpisodesWithDate:self.calendarView.selectedDate];
    
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dailyEpisodes.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EpisodesTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [EpisodesTVC cellWithEpisode:self.dailyEpisodes.list[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CLWeeklyCalendarViewDelegate
- (NSDictionary *)CLCalendarBehaviorAttributes {
    return @{CLCalendarWeekStartDay : @7, //Start Day of the week, from 1-7 Mon-Sun -- default 1
//             CLCalendarDayTitleTextColor : [UIColor colorWithRed:255.f/255.f green:128.f/255.f blue:29.f/255.f alpha:1.f],
             CLCalendarSelectedDatePrintFormat : @"yyyy MMM d, EEE", //Selected Date print format,  - Default: @"EEE, d MMM yyyy"
//             CLCalendarSelectedDatePrintColor : [UIColor colorWithRed:255.f/255.f green:128.f/255.f blue:29.f/255.f alpha:1.f], //Selected Date print text color -Default: [UIColor whiteColor]
             CLCalendarSelectedDatePrintFontSize : @16.f, //Selected Date print font size - Default : 13.f
             CLCalendarBackgroundImageColor : [UIColor colorWithPatternImage:[UIImage imageNamed:@"CLCalendarBackgroundImage"]]
        };
}

- (void)dailyCalendarViewDidSelect:(NSDate *)date {
    [self reloadData];
}

@end
