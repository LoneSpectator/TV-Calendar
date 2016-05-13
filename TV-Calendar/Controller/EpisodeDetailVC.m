//
//  EpisodeDetailVC.m
//  TV-Calendar
//
//  Created by GaoMing on 15/5/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "EpisodeDetailVC.h"
#import "Episode.h"
#import "Show.h"
#import "UIImage+BlurredFrame.h"

@interface EpisodeDetailVC ()

@property (nonatomic) Show *show;
@property (nonatomic) Episode *episode;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *showNameScrollView;
@property (weak, nonatomic) IBOutlet UILabel *showNameLable;
@property (weak, nonatomic) IBOutlet UIScrollView *episodeNameScrollView;
@property (weak, nonatomic) IBOutlet UILabel *episodeNameLabel;


@end

@implementation EpisodeDetailVC

+ (EpisodeDetailVC *)viewController {
    EpisodeDetailVC *vc = (EpisodeDetailVC *)[[NSBundle mainBundle] loadNibNamed:@"EpisodeDetailVC"
                                                                           owner:nil
                                                                         options:nil].firstObject;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    
    self.title = @"freqwq";
    self.backgroundImageView.image = [UIImage imageNamed:@"The-Simpsons-1"];
    
    [self loadNewData];
}

- (void)updateWithEpisode:(Episode *)episode {
    self.episode = episode;
    self.showNameLable.text = episode.showName;
}

- (void)loadNewData {
    self.backgroundImageView.image = [self.backgroundImageView.image applyDarkEffectAtFrame:CGRectMake(0, 0, self.backgroundImageView.image.size.width, self.backgroundImageView.image.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Hells-Kitchen-US"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:123.0/255.0 green:209.0/255.0 blue:255.0/255.0 alpha:1.0]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:20],
//                                                                      NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

@end
