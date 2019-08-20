//
//  LoginViewController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/12.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstPageViewController.h"
#import "NewAccountWindowController.h"

@interface LoginViewController ()

@property (strong,nonatomic) FirstPageViewController *checkVC;

@property (strong,nonatomic) NewAccountWindowController *accountWC;

////ip地址
//@property (weak) IBOutlet NSTextField *ipcontent;
////端口
//@property (weak) IBOutlet NSTextField *portcontent;
//账号
@property (weak) IBOutlet NSTextField *accountcontent;
//密码or验证码的title
@property (weak) IBOutlet NSTextField *passwordTitle;
//验证码
@property (weak) IBOutlet NSTextField *codecontent;
//获取验证码
@property (weak) IBOutlet NSButton *getCodeBtn;
//切换登录方式
@property (weak) IBOutlet NSButton *changeTypeBtn;
//登录按钮
@property (weak) IBOutlet NSButton *loginBtn;
//密码
@property (weak) IBOutlet NSSecureTextField *passT;

@property (strong,nonatomic) NSTimer *timer;

@property (assign,nonatomic) NSInteger timerNum;

//设备唯一识别码
@property (copy,nonatomic) NSString *deviceCode;

@property (assign,nonatomic) BOOL isgetServer;

//是否为网内手机才可以登录
@property (copy,nonatomic) NSString *isIn;
//是否将手机号同步到设备联系电话
@property (copy,nonatomic) NSString *isSyn;
//登录界面是否自动填充手机号
@property (copy,nonatomic) NSString *isPut;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.wantsLayer = YES;
    
    self.getCodeBtn.hidden = YES;
    
    self.accountWC = [[NewAccountWindowController alloc]initWithWindowNibName:@"NewAccountWindowController"];
   
    self.isgetServer = NO;
    
    [self defaultShow];
    
    [self getLoginType];
    
}


-(void)defaultShow{
    
    //如果有保存用户名，IP地址和端口号，那么就直接赋值
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];
    
    if(defaultDict){
        
        self.accountcontent.stringValue = SafeString(defaultDict[@"userName"]);
    }
    
    //获取设备唯一识别码
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];

    NSString *sid = SafeString(dict[@"deviceId"]);
    
    if(sid.length > 0){
        
        self.deviceCode = sid;

    }else{
       
        self.deviceCode = [self getUUID];
    }
    
    JumpLog(@"设备id是---%@",self.deviceCode);
    
}


#pragma mark --- 登录

- (IBAction)LoginAction:(NSButton *)sender {
    
    if(self.accountcontent.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入用户名"];
        
        return;
    }
    
    
    if([self.passwordTitle.stringValue isEqualToString:@"密码"] && self.passT.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入密码"];
        
        return;
        
    }else if([self.passwordTitle.stringValue isEqualToString:@"验证码"] && self.codecontent.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入验证码"];
        
        return;
        
    }
    
    if (self.isgetServer == NO){
        
        [self show:@"提示" andMessage:@"请先获取服务器配置"];
        
        return;
        
    }
    
    
    if(self.isgetServer == YES){
        
        [self clicklogin];
    }
    
}


-(void)clicklogin{
    
    L2CWeakSelf(self);
    
    NSString *loginType = @"";
    
    if([self.passwordTitle.stringValue isEqualToString:@"密码"]){
        
        loginType = @"1";
        
    }else{
        
        loginType = @"2";
    }
    
    NSString *macIp = [JumpPublicAction getDeviceIPAddress];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"account"] = SafeString(self.accountcontent.stringValue);
    parameters[@"loginType"] = SafeString(loginType);
    parameters[@"sid"] = SafeString(self.deviceCode);
    parameters[@"ip"] = SafeString(macIp);
    
    
    //登录方式 1-账号密码登录  2-验证码登录
    if([loginType isEqualToString:@"1"]){
        
        parameters[@"password"] = [JumpPublicAction md5:SafeString(self.passT.stringValue)];
        
    }else{
        
        parameters[@"code"] = SafeString(self.codecontent.stringValue);
    }
    
    [AFNHelper macPost:Mac_Login parameters:parameters success:^(id responseObject) {
        
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            NSString *isRegistered = SafeString(responseObject[@"result"][@"regedite"]);
            
            NSString *userId = SafeString(responseObject[@"result"][@"userId"]);
            
            NSString *isCheck = SafeString(responseObject[@"result"][@"ischeck"]);
            
            NSString *isUser = SafeString(responseObject[@"result"][@"binduser"]);
            
            [weakself pushSuccessVcWithUserId:userId isCheck:isCheck isregiter:isRegistered binduser:SafeString(isUser)];
            
        }else{
            
            NSString *msg = SafeString(responseObject[@"result"][@"msg"]);
            
            [weakself show:@"提示" andMessage:msg];
        }
        
    } andFailed:^(id error) {
        
        [weakself show:@"提示" andMessage:@"请求服务器失败"];

    }];
}



/**
 判断跳转的页面
 
 @param userId 用户id
 @param isCheck 是否需要安检（0-否 1-是）
 @param isregiter 是否注册过（0-否 1-是）
 @param binduser 已经绑定的用户
 
 */
-(void)pushSuccessVcWithUserId:(NSString *)userId isCheck:(NSString *)isCheck isregiter:(NSString *)isregiter binduser:(NSString *)binduser{
    
    
    if([binduser isEqualToString:self.accountcontent.stringValue] || binduser.length < 1){
        
        if([isregiter isEqualToString:@"0"]){
            //没注册过
            
            //跳转到注册界面
            [KNotification postNotificationName:@"FirstPageViewController" object:nil userInfo:@{@"title":@"注册",@"isCheck":isCheck}];

        }else{
            //注册过
            
            if([isCheck isEqualToString:@"1"]){
                //需要安检
            
                //跳转到安检界面
                [KNotification postNotificationName:@"FirstPageViewController" object:nil userInfo:@{@"title":@"安检"}];

                
            }else{
                //不需要安检
                
                //跳转到入网界面
                [KNotification postNotificationName:@"FirstPageViewController" object:nil userInfo:@{@"title":@"入网"}];

            }
            
            if([self.isSyn isEqualToString:@"1"] && [self.passwordTitle.stringValue isEqualToString:@"验证码"]){
                //服务器勾选了将手机号同步到设备联系电话（只有注册过的用户才进行同步）
            
                [self synWithPhone];
            }
            
        }
        
        
    }else{
        
        NSString *str = [NSString stringWithFormat:@"登录失败，该设备已被%@绑定",binduser];
        
        [self show:@"提示" andMessage:str];
        
    }
    
    
    //同步
    NSDictionary *mudict = @{
                             @"deviceId":SafeString(self.deviceCode),
                             @"userId":SafeString(userId),
                             };
    
    //存入数组并同步
    [[NSUserDefaults standardUserDefaults] setObject:mudict forKey:@"mac_userMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //同步
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];
    
    NSDictionary *mudict1 = @{
                             @"userName":SafeString(self.accountcontent.stringValue),
                             @"ipAddress":SafeString(defaultDict[@"ipAddress"]),
                             @"port":SafeString(defaultDict[@"port"]),
                             };
    //存入数组并同步
    [[NSUserDefaults standardUserDefaults] setObject:mudict1 forKey:@"mac_IpInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark --- 切换登录方式

- (IBAction)changeTypeAction:(NSButton *)sender {
    
    NSLog(@"切换登录方式");
    
    [self defaultUI:sender.title andType:nil];
}

#pragma mark --- 获取验证码

- (IBAction)getCodeAction:(NSButton *)sender {
    
    if(SafeString(self.accountcontent.stringValue).length < 1){
        
        [self show:@"提示" andMessage:@"手机号不能为空"];
        
        return;
    }
    
    BOOL isPhoneNum = [self validateCellPhoneNumber:SafeString(self.accountcontent.stringValue)];
    
    if(isPhoneNum == NO){
        
        [self show:@"提示" andMessage:@"手机号格式有误"];
        
        return;
    }
    
    if([self.isIn isEqualToString:@"1"]){//服务器勾选了只能网内手机获取验证码
        
        [self ischeck];
        
    }else{
        
        [self sendCode];//获取验证码
        
        self.getCodeBtn.enabled = NO;
        
        self.timerNum = 60;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f  //间隔时间
                                                      target:self
                                                    selector:@selector(countdown)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


#pragma mark --- 校验手机号是否为内网号

-(void)ischeck{
    
    L2CWeakSelf(self);
    
    [AFNHelper macPost:Mac_IsIntranet parameters:@{@"phoneNumber":self.accountcontent.stringValue} success:^(id responseObject) {
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            [weakself sendCode];//获取验证码
            
            weakself.getCodeBtn.enabled = NO;
            
            weakself.timerNum = 60;
            
            weakself.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f  //间隔时间
                                                              target:self
                                                            selector:@selector(countdown)
                                                            userInfo:nil
                                                             repeats:YES];
            
        }else{
            
            [weakself show:@"提示" andMessage:@"请联系管理员,目前只允许网内手机登录"];
            
            return;
            
        }
        
    } andFailed:^(id error) {
        
        [weakself show:@"提示" andMessage:@"请求服务器失败"];

    }];
}



- (void)countdown{
    
    self.timerNum --;
    
    if(self.timerNum < 0){
        
        [self.timer invalidate];
        
        self.timer = nil;
        
        self.timerNum = 0;
        
        self.getCodeBtn.enabled = YES;
        
        [self.getCodeBtn setTitle:@"获取验证码"];
        
    }else{
        
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒",self.timerNum]];
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

#pragma mark --- 获取服务器配置的登录方式

-(void)getLoginType{
    
    L2CWeakSelf(self);
    
    [AFNHelper macPost:Mac_GetloginType parameters:nil success:^(id responseObject) {
        
        NSString *type = @"3";
        NSString *title = @"用户名密码登录";
        
        if([weakself.passwordTitle.stringValue isEqualToString:@"验证码"]){
            
            title = @"短信验证码登录";
            
        }else{
            
            title = @"用户名密码登录";
            
        }
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            NSString *smscertType = SafeString(responseObject[@"result"][@"smscert"]);
            NSString *codeType = SafeString(responseObject[@"result"][@"accountcert"]);
            
            weakself.isIn = SafeString(responseObject[@"result"][@"checknetphone"]);
            weakself.isSyn = SafeString(responseObject[@"result"][@"syncdevicephone"]);
            weakself.isPut = SafeString(responseObject[@"result"][@"filleddevicephone"]);
            
            
            if([smscertType isEqualToString:@"1"] && [codeType isEqualToString:@"0"]){
                //如果只支持短信验证码登录
                type = @"1";
                
                title = @"短信验证码登录";
                
            }else if ([smscertType isEqualToString:@"0"] && [codeType isEqualToString:@"1"]){
                //如果只支持账户密码登录
                type = @"2";
                
                title = @"用户名密码登录";
                
            }else{
                //两者都支持
                type = @"3";
                
                if([weakself.passwordTitle.stringValue isEqualToString:@"验证码"]){
                    
                    title = @"短信验证码登录";
                    
                }else{
                    
                    title = @"用户名密码登录";
                    
                }
            }
            
            [weakself show:@"提示" andMessage:@"获取服务器配置成功"];
            
            weakself.isgetServer = YES;
            
        }else{
            
            weakself.isgetServer = NO;
            
            type = @"3";
            
            if([weakself.passwordTitle.stringValue isEqualToString:@"验证码"]){
                
                title = @"短信验证码登录";
                
            }else{
                
                title = @"用户名密码登录";
                
            }
            
            [weakself show:@"提示" andMessage:@"获取服务器配置失败,请检查ip地址是否正确"];
        }
        
        [weakself defaultUI:title andType:type];
        
    } andFailed:^(id error) {
        
        weakself.isgetServer = NO;
        
        NSString *title;
        
        if([weakself.passwordTitle.stringValue isEqualToString:@"验证码"]){
            
            title = @"短信验证码登录";
            
        }else{
            
            title = @"用户名密码登录";
            
        }
        
        [weakself defaultUI:title andType:@"3"];
        
        [weakself show:@"提示" andMessage:@"获取服务器配置失败,请检查ip地址是否正确"];
    }];
}


-(void)defaultUI:(NSString *)title andType:(NSString *)type{
    
    if([title isEqualToString:@"用户名密码登录"]){
        
        [self.changeTypeBtn setTitle:@"短信验证码登录"];
        
        self.getCodeBtn.hidden = YES;
        
        self.passT.hidden = NO;
        
        self.codecontent.hidden = YES;
        
        self.passwordTitle.stringValue = @"密码";
        
    }else{
        
        [self.changeTypeBtn setTitle:@"用户名密码登录"];
        
        self.getCodeBtn.hidden = NO;
        
        self.passT.hidden = YES;
        
        self.codecontent.hidden = NO;
        
        self.passwordTitle.stringValue = @"验证码";
        
    }
    
    if([type isEqualToString:@"1"] || [type isEqualToString:@"2"]){
        
        self.changeTypeBtn.hidden = YES;
        
    }else{
        
        self.changeTypeBtn.hidden = NO;
    }
    
}

#pragma mark --- 发送验证码

-(void)sendCode{
    
    L2CWeakSelf(self);
    
    [AFNHelper macPost:Mac_CreatCode parameters:@{@"phoneNumber":SafeString(self.accountcontent.stringValue)} success:^(id responseObject) {
        
        if([SafeString(responseObject[@"message"]) isEqualToString:@"ok"]){
            
            [weakself show:@"提示" andMessage:@"验证码发送成功"];
            
        }else{
            
            [weakself show:@"提示" andMessage:@"验证码发送失败"];
            
        }
        
    } andFailed:^(id error) {
       
        [weakself show:@"提示" andMessage:@"请求服务器失败"];

    }]; 
}

#pragma mark --- 正则校验手机号码

-(BOOL)validateCellPhoneNumber:(NSString *)cellNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if(([regextestmobile evaluateWithObject:cellNum] == YES)
       || ([regextestcm evaluateWithObject:cellNum] == YES)
       || ([regextestct evaluateWithObject:cellNum] == YES)
       || ([regextestcu evaluateWithObject:cellNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}


#pragma mark --- 获取服务器配置

- (IBAction)getServerSet:(NSButton *)sender {

    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];

    NSDictionary *mudict = @{
                             @"userName":SafeString(self.accountcontent.stringValue),
                             @"ipAddress":SafeString(defaultDict[@"ipAddress"]),
                             @"port":SafeString(defaultDict[@"port"]),
                             };
    //存入数组并同步
    [[NSUserDefaults standardUserDefaults] setObject:mudict forKey:@"mac_IpInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isgetServer = NO;
    
    [self getLoginType];
}

#pragma mark --- 同步手机号到设备

-(void)synWithPhone{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"phoneNumber"] = self.accountcontent.stringValue;
    parameters[@"sid"] = self.deviceCode;
    
    [AFNHelper macPost:Mac_UpdataPhone parameters:parameters success:^(id responseObject) {
        
        if([responseObject[@"message"] isEqualToString:@"ok"]){
            
            JumpLog(@"同步成功");
        }
        
    } andFailed:^(id error) {
        
        
    }];
}

#pragma mark --- 注册新用户

- (IBAction)newAccount:(NSButton *)sender {
    
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_IpInfo"];

    self.accountWC.ipAddress = SafeString(defaultDict[@"ipAddress"]);
    
    self.accountWC.port = SafeString(defaultDict[@"port"]);
    
    [self.accountWC.window orderFront:nil];//显示要跳转的窗口
    
    [[self.accountWC window] center];//显示在屏幕中间
}



#pragma mark --- 获取UUID的方法

-(NSString *)getUUID {
   
    CFUUIDRef puuid = CFUUIDCreate( nil );
    
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    return result;
}


@end
