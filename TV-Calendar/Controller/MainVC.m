//
//  MainVC.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/11.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "MainVC.h"
#import "DailyEpisodesListVC.h"

@interface MainVC ()

@property (strong, nonatomic) UITabBarController *contentTabBarController;

@end

@implementation MainVC

- (UITabBarController *)contentTabBarController {
    if (!_contentTabBarController) {
        _contentTabBarController = [[UITabBarController alloc] init];
        
        DailyEpisodesListVC *dailyEpisodesListVC = [[DailyEpisodesListVC alloc] init];
        UIViewController *showsSelectVC = [[UIViewController alloc] init];
        UIViewController *userVC = [[UIViewController alloc] init];
        UINavigationController *firstContentViewController = [[UINavigationController alloc] initWithRootViewController:dailyEpisodesListVC];
        UINavigationController *secondContentViewController = [[UINavigationController alloc] initWithRootViewController:showsSelectVC];
        UINavigationController *thirdContentViewController = [[UINavigationController alloc] initWithRootViewController:userVC];
        
        _contentTabBarController.viewControllers = [[NSArray alloc] initWithObjects:firstContentViewController, secondContentViewController, thirdContentViewController, nil];
    }
    return _contentTabBarController;
}

- (void)loadView {
    [super loadView];
    
    [self addChildViewController:self.contentTabBarController];
    [self.view addSubview:self.contentTabBarController.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
