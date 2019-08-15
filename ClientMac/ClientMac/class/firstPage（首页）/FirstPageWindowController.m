//
//  FirstPageWindowController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/7.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "FirstPageWindowController.h"
#import "FirstPageViewController.h"
#import "HistoryRecordViewController.h"
#import "DeviceInfoViewController.h"

@interface FirstPageWindowController ()

//准入
@property (strong,nonatomic) FirstPageViewController *loginVc;
//历史记录
@property (strong,nonatomic) HistoryRecordViewController *historyVc;
//设备信息
@property (strong,nonatomic) DeviceInfoViewController *deviceVc;
//准入按钮
@property (weak) IBOutlet NSButton *internetBtn;
//历史记录按钮
@property (weak) IBOutlet NSButton *historyBtn;
//设备按钮
@property (weak) IBOutlet NSButton *deviceBtn;

@property (weak) IBOutlet NSView *customerView;

@end

@implementation FirstPageWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    AppDelegate *appdelegate = [NSApp delegate];
    
    appdelegate.windowVc = self;
    
    [self.window setContentSize:NSMakeSize(800, 600)];
    
    self.window.restorable = NO;
    
    self.loginVc = [[FirstPageViewController alloc]initWithNibName:@"FirstPageViewController" bundle:nil];
    self.historyVc = [[HistoryRecordViewController alloc]initWithNibName:@"HistoryRecordViewController" bundle:nil];
    self.deviceVc = [[DeviceInfoViewController alloc]initWithNibName:@"DeviceInfoViewController" bundle:nil];

    self.loginVc.view.frame  = [self returnvcFrame];
    self.historyVc.view.frame  = [self returnvcFrame];
    self.deviceVc.view.frame  = [self returnvcFrame];

    [self.customerView addSubview:self.loginVc.view];
}

#pragma mark --- 网络准入

- (IBAction)interAction:(NSButton *)sender {
    
    JumpLog(@"网络准入");
    
    [self.loginVc.view removeFromSuperview];
    [self.historyVc.view removeFromSuperview];
    [self.deviceVc.view removeFromSuperview];
    
    [self.internetBtn setImage:[NSImage imageNamed:@"selectNet"]];
    [self.historyBtn setImage:[NSImage imageNamed:@"defaultHistory"]];
    [self.deviceBtn setImage:[NSImage imageNamed:@"defaultDevice"]];

    [self.customerView addSubview:self.loginVc.view];

}

#pragma mark --- 历史记录

- (IBAction)historyAction:(NSButton *)sender {
    
    JumpLog(@"历史记录");
    
    [self.loginVc.view removeFromSuperview];
    [self.historyVc.view removeFromSuperview];
    [self.deviceVc.view removeFromSuperview];
    
    [self.internetBtn setImage:[NSImage imageNamed:@"defaultNet"]];
    [self.historyBtn setImage:[NSImage imageNamed:@"historySelect"]];
    [self.deviceBtn setImage:[NSImage imageNamed:@"defaultDevice"]];
    
    [self.customerView addSubview:self.historyVc.view];
}

#pragma mark --- 设备信息

- (IBAction)deviceAction:(NSButton *)sender {
    
    JumpLog(@"设备信息");

    [self.loginVc.view removeFromSuperview];
    [self.historyVc.view removeFromSuperview];
    [self.deviceVc.view removeFromSuperview];
    
    [self.internetBtn setImage:[NSImage imageNamed:@"defaultNet"]];
    [self.historyBtn setImage:[NSImage imageNamed:@"defaultHistory"]];
    [self.deviceBtn setImage:[NSImage imageNamed:@"deviceMessage"]];
    
    [self.customerView addSubview:self.deviceVc.view];
}


-(NSRect)returnvcFrame{
    
    NSRect rect = CGRectMake(self.customerView.frame.origin.x, self.customerView.frame.origin.y, self.customerView.frame.size.width, self.customerView.frame.size.height);
    
    return rect;
}

@end
