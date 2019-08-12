//
//  CalenarManager.h
//  L2CSmartMotor
//
//  Created by feaonline on 2018/9/25.
//  Copyright © 2018年 feaonline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalenarManager : NSObject

+ (CalenarManager *)sharedManager;

/** 日期 */
@property (nonatomic,strong)NSCalendar *calendar;


/** 中国日历 */
@property (nonatomic,strong)NSCalendar *chineseCalendar;


/** dateFormatter */
@property (nonatomic,strong)NSDateFormatter *dateFormatter;


@end
