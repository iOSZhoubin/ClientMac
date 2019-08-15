//
//  DeviceInfoViewController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/12.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "DeviceInfoViewController.h"

@interface DeviceInfoViewController ()
//使用人
@property (weak) IBOutlet NSTextField *userName;
//部门
@property (weak) IBOutlet NSTextField *department;
//电话
@property (weak) IBOutlet NSTextField *phoneNum;
//邮箱
@property (weak) IBOutlet NSTextField *email;
//地址
@property (weak) IBOutlet NSTextField *address;
//类型
@property (weak) IBOutlet NSTextField *type;
//备注
@property (weak) IBOutlet NSTextField *remark;

@property (assign,nonatomic) BOOL isRefresh;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRefresh = NO;
    
    [self userInfoDetail];
}



- (IBAction)refreshBtn:(NSButton *)sender {
    
    self.isRefresh = YES;
    
    [self userInfoDetail];
}


#pragma mark --- 获取个人信息

-(void)userInfoDetail{
    
    L2CWeakSelf(self);
    
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];
    
    NSString *userId = SafeString(defaultDict[@"userId"]);
    NSString *deviceCode = SafeString(defaultDict[@"deviceId"]);
    
    NSString *macIp = [JumpPublicAction getDeviceIPAddress];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = userId;
    parameters[@"sid"] = SafeString(deviceCode);
    parameters[@"ip"] = macIp;
    
    [AFNHelper macPost:Mac_GetUserInfo parameters:parameters success:^(id responseObject) {
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            //使用人
            weakself.userName.stringValue = SafeString(responseObject[@"result"][@"name"]);
            //电子邮箱
            weakself.email.stringValue = SafeString(responseObject[@"result"][@"email"]);
            //设备类型
            weakself.type.stringValue = @"MacOS";
            //电话
            weakself.phoneNum.stringValue = SafeString(responseObject[@"result"][@"phoneNumber"]);
            //设备位置
            weakself.address.stringValue = SafeString(responseObject[@"result"][@"address"]);
            //部门名称
            weakself.department.stringValue = SafeString(responseObject[@"result"][@"departmentName"]);
            //备注
            weakself.remark.stringValue = SafeString(responseObject[@"result"][@"remark"]);
            
            if(self.isRefresh == YES){
            
                [weakself show:@"提示" andMessage:@"刷新成功"];
            }
            
        }else{
            
            [weakself show:@"提示" andMessage:@"获取设备信息失败"];
        }
        
        
    } andFailed:^(id error) {
        
        [weakself show:@"提示" andMessage:@"请求服务器失败"];
        
    }];
    
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
