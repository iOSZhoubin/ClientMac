//
//  FirstWindowController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/20.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "FirstWindowController.h"
#import "FirstViewController.h"

@interface FirstWindowController ()

@property (strong,nonatomic) FirstViewController *firstVc;

@end

@implementation FirstWindowController

- (void)windowDidLoad {
    [super windowDidLoad];

    AppDelegate *appdelegate = [NSApp delegate];
    
    appdelegate.windowVc = self;
    
    [self.window setContentSize:NSMakeSize(800, 600)];
    
    [self.window setBackgroundColor:[NSColor whiteColor]];

    self.window.restorable = NO;
    
    self.firstVc = [[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
    
    [self.window setContentView:self.firstVc.view];
}

@end
