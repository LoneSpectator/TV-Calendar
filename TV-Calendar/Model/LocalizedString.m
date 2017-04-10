//
//  LocalizedString.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "LocalizedString.h"
#import "SettingsManager.h"

@implementation LocalizedString

+ (NSString *)localizedStringForKey:(NSString *)key {
    NSString * localizedString = NSLocalizedString(key, nil);
    
    if (SettingsManager.defaultManager.defaultLanguage != zh_CN) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        localizedString = [languageBundle localizedStringForKey:key value:@"" table:nil];
        
    }
    
    return localizedString;
}

@end
