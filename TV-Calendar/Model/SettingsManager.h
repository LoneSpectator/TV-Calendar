//
//  SettingsManager.h
//  TV-Calendar
//
//  Created by GaoMing on 16/4/19.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

typedef enum{
    zh_CN,
    en,
} Language;

@property (readonly) Language defaultLanguage;

+ (instancetype)defaultManager;

@end
