//
//  ShowDetailsTVEpCell.h
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/25.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Episode;

@interface ShowDetailsTVEpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *epNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *epNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *epAiringDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkButtonImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *checkButtonAIView;

@property (nonatomic) Episode *episode;

+ (ShowDetailsTVEpCell *)cell;
- (void)updateWithEpisode:(Episode *)episode;

@end
