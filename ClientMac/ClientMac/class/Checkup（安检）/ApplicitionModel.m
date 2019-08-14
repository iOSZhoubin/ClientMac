//
//  ApplicitionModel.m
//  进程管家
//
//  Created by jumpapp1 on 2019/2/28.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "ApplicitionModel.h"

@implementation ApplicitionModel

-(instancetype)initApplationModelName:(NSString *)localizedName bundleURL:(NSURL *)bundleURL processIdentifier:(pid_t)processIdentifier launchDate:(NSDate *)launchDate icon:(NSImage *)icon{

    self = [super init];
    
    if(self){
        
        _localizedName = localizedName;
        _bundleURL = bundleURL;
        _processIdentifier = processIdentifier;
        _launchDate = launchDate;
        _icon = icon;
    }
    
    return self; 
}


@end
