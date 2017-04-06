//
//  LocalizedString.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "LocalizedString.h"

@implementation LocalizedString

+ (NSString *)localizedStringForKey:(NSString *)key {
    NSString * localizedString = NSLocalizedString(key, nil);
    
    if (![[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"zh-Hans"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        localizedString = [languageBundle localizedStringForKey:key value:@"" table:nil];
        
    }
    
    return localizedString;
}

@end
