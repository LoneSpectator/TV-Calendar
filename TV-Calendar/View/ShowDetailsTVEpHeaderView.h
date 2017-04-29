//
//  ShowDetailsTVEpHeaderView.h
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/25.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Season;

@interface ShowDetailsTVEpHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *seNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkButtonImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *checkButtonAIView;

@property (nonatomic) Season *season;
@property BOOL openTag;

@property void (^setOpenTagBlock)();
@property void (^refreshTableViewBlock)();

+ (ShowDetailsTVEpHeaderView *)view;
- (void)updateWithSeason:(Season *)season openTag:(BOOL)openTag;

@end
