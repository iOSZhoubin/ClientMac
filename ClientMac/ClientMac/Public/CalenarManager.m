//
//  CalenarManager.m
//  L2CSmartMotor
//
//  Created by feaonline on 2018/9/25.
//  Copyright © 2018年 feaonline. All rights reserved.
//

#import "CalenarManager.h"


@implementation CalenarManager

+ (CalenarManager *)sharedManager {
    
    static CalenarManager *handle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[CalenarManager alloc] init];
    });
    
    return handle;
    
}

- (NSCalendar *)calendar {
    
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        _calendar.timeZone = [NSTimeZone localTimeZone];
        
    }
    
    return _calendar;
}

- (NSCalendar *)chineseCalendar {
    
    if (!_chineseCalendar) {
        
        _chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    }
    
    return _chineseCalendar;
    
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
    
}

@end
