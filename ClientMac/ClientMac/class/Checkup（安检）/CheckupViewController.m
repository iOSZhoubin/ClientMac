//
//  CheckupViewController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/12.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "CheckupViewController.h"
#import "ApplicitionModel.h"
#import "DateCalculater.h"
//wifi信息
#import <sys/socket.h>
#import <ifaddrs.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

@interface CheckupViewController ()


//进度条
@property (weak) IBOutlet NSProgressIndicator *progress;
//检查内容
@property (weak) IBOutlet NSTextField *itemContent;
//重新检测按钮
@property (weak) IBOutlet NSButton *againBtn;

//定时器
@property (strong,nonatomic) NSTimer *timer;
//进程名称
@property (strong,nonatomic) NSMutableArray <ApplicitionModel *> *dataArray;
//允许进程安装检查Array
@property (strong,nonatomic) NSMutableArray *processY;
//禁止进程安装检查Array
@property (strong,nonatomic) NSMutableArray *processN;
//检查总Array
@property (strong,nonatomic) NSMutableArray *sumArray;
//服务器时间
@property (copy,nonatomic) NSString *serverTime;
//服务器ip地址
@property (copy,nonatomic) NSString *serverIp;
//进度条
@property (assign,nonatomic) NSInteger progressV;
//检查显示结果
@property (strong,nonatomic) NSMutableString *contentStr;
//
@property (assign,nonatomic) BOOL isTrue;
//
@property (assign,nonatomic) BOOL isRight;
//必须进程检查
@property (strong,nonatomic) NSMutableString *yesStr;
//禁止运行检查
@property (strong,nonatomic) NSMutableString *noStr;
//未通过项数组
@property (strong,nonatomic) NSMutableArray *muArray;

@end

@implementation CheckupViewController

-(NSMutableArray<ApplicitionModel *> *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)progressStatus{
    
    L2CWeakSelf(self);
    
    self.progress.doubleValue = 0;
    
    self.itemContent.stringValue = @"";
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        weakself.progressV = weakself.progress.doubleValue;
        
        if(weakself.progressV >= 100){
            
            weakself.progress.doubleValue = 100;
            
            [weakself.timer invalidate];
            
            weakself.timer = nil;
            
            self.againBtn.enabled = YES;
            
            self.itemContent.stringValue = self.contentStr;
            
            JumpLog(@"%@===%@",self.noStr,self.yesStr);
            
            if(self.noStr.length < 1 && self.yesStr.length < 1 && self.isTrue == YES && self.isRight == YES){
                
                [self saveData:@"1"];
                
            }else{
                
                [self saveData:@"0"];
            }
            
            [self pushVc]; //检查是否可以登录
            
        }else{
            
            [weakself.progress incrementBy:1];
            
            self.itemContent.stringValue = @"正在检测...\n";
            
            self.againBtn.enabled = NO;
            
        }
        
    }];
}

#pragma mark --- 开始检测

- (IBAction)backAction:(NSButton *)sender {
    
    [self getAllCheck];
    
    [self progressStatus];
}



#pragma mark --- 获取检查项

-(void)getAllCheck{
    
    L2CWeakSelf(self);
    
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];

    NSString *userId = SafeString(defaultDict[@"userId"]);
    
    [AFNHelper macPost:Mac_CheckEntry parameters:@{@"userId":userId} success:^(id responseObject) {
       
        weakself.processY = [NSMutableArray array];
        weakself.processN = [NSMutableArray array];
        
        NSArray *dataArray = responseObject[@"result"];
        
        for (NSDictionary *dict in dataArray) {
            
            /**
             name:必须运行进程检查  type:mobilemustprocesscheck
             name:禁止运行进程检查  type:mobileprogibitedprocesscheck
             */
            
            NSString *type = dict[@"type"];
            
            NSString *jsonStr = dict[@"policy"];
            
            NSDictionary *dict = [jsonStr mj_JSONObject];
            
            NSArray *array = dict[@"content"];
            
            if ([type isEqualToString:@"mobilemustprocesscheck"]){
                
                [weakself.processY addObjectsFromArray:array];
                
            }
            
            if ([type isEqualToString:@"mobileprogibitedprocesscheck"]){
                
                [weakself.processN addObjectsFromArray:array];
                
            }
        }
        
        [weakself getAppName];
        
    } andFailed:^(id error) {
        
    }];
}


#pragma mark --- 获取进程名称

-(void)getAppName{
    
    //获取正在运行的app名称
    NSArray<NSRunningApplication *> *apps = [[NSWorkspace sharedWorkspace] runningApplications];
    
    for (NSRunningApplication *app in apps) {
        
        ApplicitionModel *model = [[ApplicitionModel alloc]initApplationModelName:app.localizedName bundleURL:app.bundleURL processIdentifier:app.processIdentifier launchDate:app.launchDate icon:app.icon];
        
        [self.dataArray addObject:model];
    }
    
    JumpLog(@"所有的进程名称：%@",self.dataArray);
    
    [self ishaveAppname];
    
}

//检查进程等
-(void)ishaveAppname{
    
    self.muArray = [NSMutableArray array];
    
    self.yesStr = [NSMutableString string];
    self.noStr = [NSMutableString string];
    
    for (NSInteger i=0; i<self.processY.count; i++) {
        //必须运行进程检查
        NSString *proName = self.processY[i][@"processname"];
        
        for(NSInteger j=0;j<self.dataArray.count;j++){
            
            ApplicitionModel *model = self.dataArray[j];
            
            NSString *name = model.localizedName;
            
            if([proName isEqualToString:name]){
                
                break;
                
            }else{
                
                if(j == self.dataArray.count - 1){
                    
                    [self.yesStr appendFormat:@"%@", [NSString stringWithFormat:@"%@,",proName]];
                    
                    [self.muArray addObject:proName];
                }
            }
        }
    }
    
    
    
    
    for (NSInteger i=0; i<self.processN.count; i++) {
        //禁止运行进程检查
        NSString *proName = self.processN[i][@"processname"];
        
        for(NSInteger j=0;j<self.dataArray.count;j++){
            
            ApplicitionModel *model = self.dataArray[j];
            
            NSString *name = model.localizedName;
            
            if([proName isEqualToString:name]){
                
                [self.noStr appendFormat:@"%@", [NSString stringWithFormat:@"%@,",proName]];
                
                [self.muArray addObject:proName];
                
                break;
            }
        }
    }
    
    
    self.contentStr = [NSMutableString string];
    
    
    if(self.yesStr.length > 0){
        
        [self.contentStr appendFormat:@"%@", [NSString stringWithFormat:@"必须运行进程检查异常，需运行%@进程",self.yesStr]];
        
    }else{
        
        [self.contentStr appendFormat:@"必须运行进程检查正常..."];
        
    }
    
    
    if(self.noStr.length > 0){
        
        [self.contentStr appendFormat:@"%@", [NSString stringWithFormat:@"\n禁止运行进程检查异常，需禁止%@进程",self.noStr]];
        
    }else{
        
        [self.contentStr appendFormat:@"\n禁止运行进程检查正常..."];
        
    }
    
    JumpLog(@"%@",self.contentStr);
    
    [self getServerInfo];
    
}



#pragma mark --- 获取服务器时间和IP地址

-(void)getServerInfo{
    
    L2CWeakSelf(self);
    
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];
    
    NSString *deviceId = SafeString(defaultDict[@"deviceId"]);

    [AFNHelper macPost:Mac_ServerInfo parameters:@{@"sid":deviceId} success:^(id responseObject) {
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            NSDictionary *dict = responseObject[@"result"];
            
            weakself.serverTime = dict[@"serverTime"];//服务器时间
            
            weakself.serverIp = dict[@"serverIp"];//服务器ip地址
            
        }else{
            
            weakself.serverTime = @"";//服务器时间
            
            weakself.serverIp = @"";//服务器ip地址
        }
        
        [weakself compareIpandTime];
        
    } andFailed:^(id error) {
        
        
    }];
}

//比较ip地址与时间
-(void)compareIpandTime{
    
    //获取系统当前时间
    NSDate *datenow = [NSDate new];
    
    NSString *deviceDate = [DateCalculater startTimeFromDate:datenow];
    
    //时间转时间戳
    NSInteger nowNum = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    
    NSDate *serverDate = [DateCalculater dateAndTimeFromString:self.serverTime];
    
    NSInteger serverNum = [[NSNumber numberWithDouble:[serverDate timeIntervalSince1970]] integerValue];
    
    NSInteger reductionNum = serverNum - nowNum;
    
    //获取本机的ip地址
    NSString *macIp = [self getDeviceIPAddress];
    
    if([self.serverIp isEqualToString:macIp]){
        
        NSString *ipaddress = [NSString stringWithFormat:@"\n设备IP地址正常,服务器设备IP为:%@",self.serverIp];
        
        [self.contentStr appendFormat:@"%@", ipaddress];
        
        self.isRight = YES;
        
    }else{
        
        NSString *ipaddress = [NSString stringWithFormat:@"\n设备IP地址异常,设备IP为:%@,服务器设备IP为:%@",macIp,self.serverIp];
        
        [self.contentStr appendFormat:@"%@", ipaddress];
        
        self.isRight = NO;
        
    }
    
    if(reductionNum > 300 || self.serverTime.length < 1){
        
        NSString *time = [NSString stringWithFormat:@"\n设备时间检查异常,设备时间为:%@,服务器时间为:%@",deviceDate,self.serverTime];
        
        [self.contentStr appendFormat:@"%@", time];
        
        self.isTrue = NO;
        
    }else{
        
        NSString *time = [NSString stringWithFormat:@"\n设备时间检查正常,服务器时间为:%@",self.serverTime];
        
        [self.contentStr appendFormat:@"%@", time];
        
        self.isTrue = YES;
    }
}



/** 保留数据到本地 */
-(void)saveData:(NSString *)isNormal{
    
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *status = @"";
    
    if([isNormal isEqualToString:@"1"]){
        
        status = @"通过";
        
    }else{
        
        status = @"不通过";
    }
    
    NSInteger sumNum = self.processY.count + self.processN.count + 2;
    
    NSString *sumCount = [NSString stringWithFormat:@"%ld",sumNum];
    NSString *noCount = [NSString stringWithFormat:@"%ld",self.muArray.count];

    
    NSDictionary *dict = @{@"time":currentDateString,@"status":status,@"desc":self.contentStr,@"sumPass":sumCount,@"noPass":noCount};
    
    //    如果本地化的数组有值，那么先加进去
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    
    self.sumArray = [NSMutableArray array];
    
    if(array.count > 0){
        
        [self.sumArray addObjectsFromArray:array];
    }
    
    [self.sumArray addObject:dict];
    
    //存入数组并同步
    [[NSUserDefaults standardUserDefaults] setObject:self.sumArray forKey:@"status"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [KNotification postNotificationName:@"HistoryRecordViewController" object:nil userInfo:nil];
    
}

#pragma mark --- 获取设备ip地址

- (NSString *)getDeviceIPAddress {
    
    NSString *address = @"";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    struct sockaddr_in *sockaddr = (struct sockaddr_in *)temp_addr->ifa_addr;
                    address = [NSString stringWithUTF8String:inet_ntoa(sockaddr->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    NSLog(@"IP地址是：%@", address);
    return address;
}

#pragma mark --- 检查是否可以入网

-(void)pushVc{
    
    if(self.noStr.length < 1 && self.yesStr.length < 1 && self.isTrue == YES && self.isRight == YES){
        
        //安检通过后入网
        [KNotification postNotificationName:@"FirstPageViewController" object:nil userInfo:@{@"title":@"入网"}];

    }else{
        
        [self show:@"提示" andMessage:@"检查异常,通过后方可入网"];
    }
}

#pragma mark --- 提示框

-(void)show:(NSString *)title andMessage:(NSString *)message{
    
    NSAlert *alert = [[NSAlert alloc]init];
    
    alert.messageText = title;
    
    alert.informativeText = message;
    
    //设置提示框的样式
    alert.alertStyle = NSAlertStyleWarning;
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
        
    }];
    
}


@end
