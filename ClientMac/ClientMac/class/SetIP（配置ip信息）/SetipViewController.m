//
//  SetipViewController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/20.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "SetipViewController.h"

@interface SetipViewController ()

//端口号
@property (weak) IBOutlet NSTextField *port;
//ip地址
@property (weak) IBOutlet NSTextField *ipAddress;

@end

@implementation SetipViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //如果有IP地址和端口号，那么就直接赋值
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];
    
    if(defaultDict){
        
        self.port.stringValue = SafeString(defaultDict[@"port"]);
        self.ipAddress.stringValue = SafeString(defaultDict[@"ipAddress"]);
    }
}

#pragma mark --- 完成

- (IBAction)finishAction:(NSButton *)sender {
    
    
    if(self.ipAddress.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入ip地址"];

        return;
        
    }else if (self.port.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入端口"];

        return;

    }
    
    
    NSDictionary *mudict = @{
                             @"ipAddress":SafeString(self.ipAddress.stringValue),
                             @"port":SafeString(self.port.stringValue),
                             };
    
    //存入数组并同步
    [[NSUserDefaults standardUserDefaults] setObject:mudict forKey:@"mac_IpInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewController:self];

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
