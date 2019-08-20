//
//  AppDelegate.h
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/7.
//  Copyright © 2019年 zb. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "FirstWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong,nonatomic) FirstWindowController *mainWC;

@property (strong,nonatomic) NSWindowController *windowVc;


@end

