//
//  NewAccountWindowController.h
//  MacOSJump
//
//  Created by jumpapp1 on 2019/4/15.
//  Copyright © 2019年 zb. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewAccountWindowController : NSWindowController

//ip地址
@property (copy,nonatomic) NSString *ipAddress;
//端口号
@property (copy,nonatomic) NSString *port;

@end

NS_ASSUME_NONNULL_END
