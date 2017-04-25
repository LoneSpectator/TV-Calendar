//
//  ShowDetailsTVEpHeaderView.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/25.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ShowDetailsTVEpHeaderView.h"
#import "Season.h"

@implementation ShowDetailsTVEpHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkButtonAIView.hidden = YES;
}

+ (ShowDetailsTVEpHeaderView *)view {
    ShowDetailsTVEpHeaderView *view = (ShowDetailsTVEpHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"ShowDetailsTVEpHeaderView" owner:nil options:nil].firstObject;
    [view.infoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:view
                                                                                action:@selector(viewTouchUpInside)]];
    return view;
}

- (void)updateWithSeason:(Season *)season {
    self.season = season;
    self.seNumLabel.text = [NSString stringWithFormat:@"%ld", (long)season.seNum];
}

- (void)viewTouchUpInside {
    if (self.refreshTableViewBlock) {
        self.refreshTableViewBlock();
    }
}

@end
