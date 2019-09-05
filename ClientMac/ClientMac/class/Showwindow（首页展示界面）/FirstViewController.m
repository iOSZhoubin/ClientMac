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
#import "SetipViewController.h"

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

@property(assign,nonatomic) BOOL isLogin;
//网络准入
@property (strong,nonatomic) FirstPageWindowController *firstPageWc;
//历史记录
@property (strong,nonatomic) HistoryRecordViewController *historyVc;
//设备信息
@property (strong,nonatomic) DeviceInfoViewController *deviceVc;
//配置ip信息
@property (strong,nonatomic) SetipViewController *setipVc;


@end

@implementation FirstViewController


-(void)viewWillAppear{
    
    [super viewWillAppear];
    
//waring 此处需要添加接口判断，该设备是否认证成功
    
    //如果有IP地址和端口号，那么就直接赋值
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];

    NSString *userId = SafeString(defaultDict[@"userId"]);
    NSString *personName = SafeString(userDict[@"userName"]);

    if(personName.length > 0 && userId.length > 0){
        
        self.loginStatus.stringValue = @"已登录";
        self.userName.stringValue = personName;
        [self.loginBtn setImage:[NSImage imageNamed:@"againInternet"]];
        self.isLogin = YES;
        
    }else{
        
        self.loginStatus.stringValue = @"未登录";
        self.userName.stringValue = @"登录捷普准入体验安全上网";
        [self.loginBtn setImage:[NSImage imageNamed:@"loginBtn"]];
        self.isLogin = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstPageWc = [[FirstPageWindowController alloc]initWithWindowNibName:@"FirstPageWindowController"];
    
    self.historyVc = [[HistoryRecordViewController alloc]initWithNibName:@"HistoryRecordViewController" bundle:nil];
    
    self.deviceVc = [[DeviceInfoViewController alloc]initWithNibName:@"DeviceInfoViewController" bundle:nil];

    self.setipVc = [[SetipViewController alloc]initWithNibName:@"SetipViewController" bundle:nil];

    
    self.ipAddress.stringValue = [JumpPublicAction getDeviceIPAddress];
    
    self.macAddress.stringValue = [JumpPublicAction getDeviceMacAddress];
    
    self.name.stringValue = [NSString stringWithFormat:@"%@",[NSHost currentHost].localizedName];

}


//进入准入登录界面
- (IBAction)pushloginView:(NSButton *)sender {
    
    //如果有保存用户名，IP地址和端口号，那么就直接赋值
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];
    
    NSString *ip = SafeString(defaultDict[@"ipAddress"]);
    NSString *port = SafeString(defaultDict[@"port"]);
    
    if(ip.length > 0 && port.length > 0){
        
        if(self.isLogin == YES){

            //重新入网删除信息
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mac_userMessage"];
         
            [KNotification postNotificationName:@"FirstPageViewController" object:nil userInfo:@{@"title":@"登录"}];
        }
        
        [self.firstPageWc.window orderFront:nil];//显示要跳转的窗口
        
        [[self.firstPageWc window] center];//显示在屏幕中间
        
        [self.view.window orderOut:nil];//关闭当前窗口
        
    }else{
        
        [self show:@"提示" andMessage:@"请先配置IP信息"];
        
    }
}

#pragma mark --- 历史记录

- (IBAction)historyAction:(NSButton *)sender {
    
    self.historyVc.title = @"历史记录";
    
    self.historyVc.top = 0;

    [self presentViewControllerAsModalWindow:self.historyVc];
}

#pragma mark --- 设备信息

- (IBAction)deviceAction:(NSButton *)sender {
    
    self.deviceVc.title = @"设备信息";
    
    [self presentViewControllerAsModalWindow:self.deviceVc];

}

#pragma mark --- 设置

- (IBAction)setAction:(NSButton *)sender {
    
    //如果有保存用户名，IP地址和端口号，那么就直接赋值
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];
    
    NSString *ip = SafeString(defaultDict[@"ipAddress"]);
    NSString *port = SafeString(defaultDict[@"port"]);

    if(ip.length > 0 && port.length > 0){
        
        self.setipVc.title = @"配置IP信息";
        
        [self presentViewControllerAsModalWindow:self.setipVc];
    
    }else{
     
        [self show:@"提示" andMessage:@"请先配置IP信息"];
        
    }
}


#pragma mark --- 提示框

-(void)show:(NSString *)title andMessage:(NSString *)message{
    
    NSAlert *alert = [[NSAlert alloc]init];
    
    alert.messageText = title;
    
    alert.informativeText = message;
    
    //设置提示框的样式
    alert.alertStyle = NSAlertStyleWarning;
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
}


@end
