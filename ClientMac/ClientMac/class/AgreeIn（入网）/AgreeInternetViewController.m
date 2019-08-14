//
//  AgreeInternetViewController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/12.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "AgreeInternetViewController.h"

@interface AgreeInternetViewController ()

//状态
@property (weak) IBOutlet NSTextField *status;
//时间
@property (weak) IBOutlet NSTextField *time;
//时长
@property (weak) IBOutlet NSTextField *longtime;
//状态图片
@property (weak) IBOutlet NSImageView *statusImage;

@property (weak) IBOutlet NSImageView *backImage;

@property (strong ,nonatomic) NSTimer *connectTimer;

@property(assign,nonatomic) BOOL isClick;

@end

@implementation AgreeInternetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isClick = NO;

    [self creatInfo];
}

//刷新方法
- (IBAction)clickRefresh:(NSButton *)sender {
    
    self.isClick = YES;
    
    [self creatInfo];
}

-(void)creatInfo{
    
    L2CWeakSelf(self);
    
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];

    NSString *userId = SafeString(defaultDict[@"userId"]);
    NSString *deviceCode = SafeString(defaultDict[@"deviceId"]);
    NSString *macIp = [JumpPublicAction getDeviceIPAddress];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = userId;
    parameters[@"sid"] = deviceCode;
    parameters[@"ip"] = macIp;
    
    [AFNHelper macPost:Mac_GetUserInfo parameters:parameters success:^(id responseObject) {
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            if(weakself.isClick == NO){
                
                [weakself timeStart]; //启动心跳
            }
            
            if([SafeString(responseObject[@"result"][@"deviceStatus"]) isEqualToString:@"0"]){
                
                weakself.statusImage.image = [NSImage imageNamed:@"bg-state-N"];
                weakself.status.stringValue = @"下线";
                
            }else{
                
                
                weakself.statusImage.image = [NSImage imageNamed:@"bg-state-Y"];
                weakself.status.stringValue = @"在线";
            }
            
            weakself.time.stringValue = SafeString(responseObject[@"result"][@"sureTime"]);
            weakself.longtime.stringValue = SafeString(responseObject[@"result"][@"surelength"]);
            
            if(weakself.isClick){
                
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



-(void)timeStart{
    
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f  //间隔时间
                                                         target:self
                                                       selector:@selector(longConnect)
                                                       userInfo:nil
                                                        repeats:YES];
}



-(void)longConnect{
    
    L2CWeakSelf(self);
    
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];

    NSString *deviceCode = SafeString(defaultDict[@"deviceId"]);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"sid"] = deviceCode;
    
    [AFNHelper macPost:Mac_DeviceisOnline parameters:parameters success:^(id responseObject) {
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            if([SafeString(responseObject[@"result"][@"isonline"]) isEqualToString:@"0"]){
                
                [weakself offlineAlert];
            }
            
        }else{
            
            [weakself offlineAlert];
        }
        
    } andFailed:^(id error) {
        
        JumpLog(@"连接服务器失败");
        
    }];
}


-(void)offlineAlert{
    
    [self.connectTimer invalidate];
    
    self.connectTimer = nil;
    
    NSAlert *alert = [[NSAlert alloc]init];
    
    alert.messageText = @"提示";
    
    alert.informativeText = @"该设备已下线";
    
    //设置提示框的样式
    alert.alertStyle = NSAlertStyleWarning;
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
        [KNotification postNotificationName:@"FirstPageViewController" object:nil userInfo:@{@"title":@"登录"}];
  
    }];
}

@end
