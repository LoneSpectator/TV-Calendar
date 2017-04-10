//
//  SettingsManager.m
//  TV-Calendar
//
//  Created by GaoMing on 16/4/19.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "SettingsManager.h"

@interface SettingsManager()

@property (readwrite) Language defaultLanguage;

@end

@implementation SettingsManager

+ (instancetype)defaultManager {
    static dispatch_once_t ID = 0;
    static SettingsManager *manager = nil;
    dispatch_once(&ID, ^{
        manager = [[self alloc] init];
        if ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"zh-Hans"]) {
            manager.defaultLanguage = zh_CN;
        } else {
            manager.defaultLanguage = en;
        }
    });
    return manager;
}

@end
