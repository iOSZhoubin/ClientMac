//
//  FirstShowWindowController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/14.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "FirstShowWindowController.h"
#import "FirstPageWindowController.h"

@interface FirstShowWindowController ()

//主机名
@property (weak) IBOutlet NSTextField *name;
//ip地址
@property (weak) IBOutlet NSTextField *ipAddress;
//mac地址
@property (weak) IBOutlet NSTextField *macAddress;

@property (strong,nonatomic) FirstPageWindowController *firstPageWc;

@end

@implementation FirstShowWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    AppDelegate *appdelegate = [NSApp delegate];
    
    appdelegate.windowVc = self;
    
    [self.window setContentSize:NSMakeSize(800, 600)];
    
    self.window.restorable = NO;
    
    [self.window setBackgroundColor:[NSColor whiteColor]];
    
    self.firstPageWc = [[FirstPageWindowController alloc]initWithWindowNibName:@"FirstPageWindowController"];
    
    self.ipAddress.stringValue = [JumpPublicAction getDeviceIPAddress];
   
    self.macAddress.stringValue = [JumpPublicAction getDeviceMacAddress];
    
    self.name.stringValue = [NSString stringWithFormat:@"%@",[NSHost currentHost].localizedName];

}


//进入准入登录界面
- (IBAction)pushloginView:(NSButton *)sender {
    
    [self.firstPageWc.window orderFront:nil];//显示要跳转的窗口
    
    [[self.firstPageWc window] center];//显示在屏幕中间
    
    [self.window orderOut:nil];//关闭当前窗口
    
}



@end
