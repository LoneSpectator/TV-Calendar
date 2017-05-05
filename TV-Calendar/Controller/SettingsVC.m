//
//  SettingsVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/1.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "SettingsVC.h"
#import "SettingsManager.h"
#import "LocalizedString.h"
#import "User.h"
#import "LoginVC.h"

@interface SettingsVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *backItem;

@end

@implementation SettingsVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
    }
    return _tableView;
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

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backItem;
    
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
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (currentUser) {
            return 2;
        } else {
            return 1;
        }
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.section == 0) {
        if (currentUser) {
            if (indexPath.row == 0) {
                cell.textLabel.text = LocalizedString(@"手机号");
                cell.detailTextLabel.text = currentUser.phone;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  // 禁止行被选中
            }
            if (indexPath.row == 1) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = LocalizedString(@"注销");
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
            }
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = LocalizedString(@"登陆/注册");
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = LocalizedString(@"语言");
            cell.detailTextLabel.text = LocalizedString(@"中文");
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  // 禁止行被选中
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = LocalizedString(@"关于");
    }
    cell.textLabel.font = [UIFont systemFontOfSize:18];
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
//    v.backgroundColor = [UIColor redColor];
//    cell.accessoryView = v;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
    }
    return @"";
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (currentUser) {
            if (indexPath.row == 1) {
                [User logout];
                [self.tableView reloadData];
            }
        } else {
            [LoginVC showLoginViewControllerWithSender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    }
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
    }
    return 20;
}

@end
