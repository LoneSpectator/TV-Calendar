//
//  LocalizedString.h
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizedString : NSObject

#define LocalizedString(key) [LocalizedString localizedStringForKey:(key)]

+ (NSString *)localizedStringForKey:(NSString *)key;

@end
