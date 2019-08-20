//
//  FirstViewController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/20.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstPageWindowController.h"
#import "DeviceInfoViewController.h"
#import "HistoryRecordViewController.h"

@interface FirstViewController ()

//主机名
@property (weak) IBOutlet NSTextField *name;
//ip地址
@property (weak) IBOutlet NSTextField *ipAddress;
//mac地址
@property (weak) IBOutlet NSTextField *macAddress;
//登录状态
@property (weak) IBOutlet NSTextField *loginStatus;
//登录用户
@property (weak) IBOutlet NSTextField *userName;
//网络准入按钮
@property (weak) IBOutlet NSButton *loginBtn;

//网络准入
@property (strong,nonatomic) FirstPageWindowController *firstPageWc;
//历史记录
@property (strong,nonatomic) HistoryRecordViewController *historyVc;
//设备信息
@property (strong,nonatomic) DeviceInfoViewController *deviceVc;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstPageWc = [[FirstPageWindowController alloc]initWithWindowNibName:@"FirstPageWindowController"];
    
    self.historyVc = [[HistoryRecordViewController alloc]initWithNibName:@"HistoryRecordViewController" bundle:nil];
    
    self.deviceVc = [[DeviceInfoViewController alloc]initWithNibName:@"DeviceInfoViewController" bundle:nil];

    self.ipAddress.stringValue = [JumpPublicAction getDeviceIPAddress];
    
    self.macAddress.stringValue = [JumpPublicAction getDeviceMacAddress];
    
    self.name.stringValue = [NSString stringWithFormat:@"%@",[NSHost currentHost].localizedName];

}


//进入准入登录界面
- (IBAction)pushloginView:(NSButton *)sender {
    
    [self.firstPageWc.window orderFront:nil];//显示要跳转的窗口
    
    [[self.firstPageWc window] center];//显示在屏幕中间
    
    [self.view.window orderOut:nil];//关闭当前窗口
    
}

#pragma mark --- 历史记录

- (IBAction)historyAction:(NSButton *)sender {
    
    self.historyVc.title = @"历史记录";

    [self presentViewControllerAsModalWindow:self.historyVc];
}

#pragma mark --- 设备信息

- (IBAction)deviceAction:(NSButton *)sender {
    
    self.deviceVc.title = @"设备信息";
    
    [self presentViewControllerAsModalWindow:self.deviceVc];

}

@end
