//
//  ShowDetailsTVEpCell.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/25.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ShowDetailsTVEpCell.h"
#import "Episode.h"

@implementation ShowDetailsTVEpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkButtonAIView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ShowDetailsTVEpCell *)cell {
    ShowDetailsTVEpCell *cell = (ShowDetailsTVEpCell *)[[NSBundle mainBundle] loadNibNamed:@"ShowDetailsTVEpCell" owner:nil options:nil].firstObject;
    return cell;
}

- (void)updateWithEpisode:(Episode *)episode {
    self.episode = episode;
    if (episode.epNum < 10) {
        self.epNumLabel.text = [NSString stringWithFormat:@"0%ld", (long)episode.epNum];
    } else {
        self.epNumLabel.text = [NSString stringWithFormat:@"%ld", (long)episode.epNum];
    }
    self.epNameLabel.text = episode.episodeName;
    if (episode.isReleased) {
        self.epAiringDateLabel.hidden = YES;
    } else {
        self.checkButtonImageView.hidden = YES;
        self.checkButton.hidden = YES;
        self.checkButtonAIView.hidden = YES;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MM-dd"];
        self.epAiringDateLabel.text = [dateFormatter stringFromDate:episode.airingDate];
    }
}

@end
