//
//  ApplicitionModel.h
//  进程管家
//
//  Created by jumpapp1 on 2019/2/28.
//  Copyright © 2019年 zb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicitionModel : NSObject

//进程名称
@property (copy,nonatomic) NSString *localizedName;
//进程URL
@property (strong,nonatomic) NSURL *bundleURL;
//进程PID
@property (assign,nonatomic) pid_t processIdentifier;
//启动时间
@property (strong,nonatomic) NSDate *launchDate;
//进程图标
@property (strong,nonatomic) NSImage *icon;

-(instancetype)initApplationModelName:(NSString *)localizedName bundleURL:(NSURL *)bundleURL processIdentifier:(pid_t)processIdentifier launchDate:(NSDate *)launchDate icon:(NSImage *)icon;

@end
