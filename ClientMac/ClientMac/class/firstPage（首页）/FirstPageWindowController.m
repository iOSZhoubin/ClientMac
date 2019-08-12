//
//  FirstPageWindowController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/7.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "FirstPageWindowController.h"
#import "AppDelegate.h"
#import "FirstPageViewController.h"

@interface FirstPageWindowController ()

@property (strong,nonatomic) FirstPageViewController *loginVc;

@end

@implementation FirstPageWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    AppDelegate *appdelegate = [NSApp delegate];
    
    appdelegate.windowVc = self;
    
    //    [self.window setContentSize:NSMakeSize(800, 600)];
    
//    self.window.restorable = NO;
    
    self.loginVc = [[FirstPageViewController alloc]initWithNibName:@"FirstPageViewController" bundle:nil];
    
    self.loginVc.mainWC = self.window;
    
    [self.window setContentView:self.loginVc.view];
    
    
}

@end
