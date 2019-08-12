//
//  NewAccountWindowController.m
//  MacOSJump
//
//  Created by jumpapp1 on 2019/4/15.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "NewAccountWindowController.h"

@interface NewAccountWindowController ()

//手机号
@property (weak) IBOutlet NSTextField *phoneNum;
//验证码
@property (weak) IBOutlet NSTextField *code;
//密码
@property (weak) IBOutlet NSTextField *password;
//确认密码
@property (weak) IBOutlet NSTextField *againPass;
//获取验证码按钮
@property (weak) IBOutlet NSButton *codeBtn;

@property (strong,nonatomic) NSTimer *timer;

@property (assign,nonatomic) NSInteger timerNum;

@end

@implementation NewAccountWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
  
}

#pragma mark --- 获取验证码

- (IBAction)getCodeAction:(NSButton *)sender {
    
    if(SafeString(self.phoneNum.stringValue).length < 1){
        
        [self show:@"提示" andMessage:@"手机号不能为空"];
        
        return;
    }
    
    BOOL isPhoneNum = [self validateCellPhoneNumber:SafeString(self.phoneNum.stringValue)];
    
    if(isPhoneNum == NO){
        
        [self show:@"提示" andMessage:@"手机号格式有误"];
        
        return;
    }
    
    [self sendCode];//获取验证码
        
    self.codeBtn.enabled = NO;
        
    self.timerNum = 60;
        
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f  //间隔时间
                                                      target:self
                                                    selector:@selector(countdown)
                                                    userInfo:nil
                                                     repeats:YES];
}


- (void)countdown{
    
    self.timerNum --;
    
    if(self.timerNum < 0){
        
        [self.timer invalidate];
        
        self.timer = nil;
        
        self.timerNum = 0;
        
        self.codeBtn.enabled = YES;
        
        [self.codeBtn setTitle:@"获取验证码"];
        
    }else{
        
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",self.timerNum]];
    }
}


#pragma mark --- 发送验证码

-(void)sendCode{
    
    L2CWeakSelf(self);
    
    [AFNHelper macPost:Mac_CreatCode parameters:@{@"phoneNumber":SafeString(self.phoneNum.stringValue)} success:^(id responseObject) {
        
        if([SafeString(responseObject[@"message"]) isEqualToString:@"ok"]){
            
            [weakself show:@"提示" andMessage:@"验证码发送成功"];
            
        }else{
            
            [weakself show:@"提示" andMessage:@"验证码发送失败"];
            
        }
        
    } andFailed:^(id error) {

        [weakself show:@"提示" andMessage:@"请求服务器失败"];

    }];
}


#pragma mark --- 注册

- (IBAction)registerAction:(NSButton *)sender {
    
    
    if(self.phoneNum.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入手机号"];
        
        return;
        
    }else if (self.code.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入验证码"];
        
        return;
   
    }else if (self.password.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请输入密码"];
        
        return;
    
    }else if (self.againPass.stringValue.length < 1){
        
        [self show:@"提示" andMessage:@"请再次输入密码"];
        
        return;
    }
    
    if(![self.password.stringValue isEqualToString:self.againPass.stringValue]){
        
        [self show:@"提示" andMessage:@"两次输入的密码不一致"];
        
        return;
    }
    
    BOOL isIntensity = [self checkPassWord:self.password.stringValue];
    
    if(!isIntensity){
        
        [self show:@"提示" andMessage:@"密码强度过低,请重新设置"];

        return;
    }
   
    [self clickRegister];
  
}

-(void)clickRegister{
    
    L2CWeakSelf(self);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"account"] = SafeString(self.phoneNum.stringValue);
    parameters[@"code"] = SafeString(self.code.stringValue);
    parameters[@"password"] = SafeString(self.password.stringValue);
    
    [AFNHelper macPost:Mac_Registed parameters:parameters success:^(id responseObject) {
        if([SafeString(responseObject[@"message"]) isEqualToString:@"ok"]){
            
            NSAlert *alert = [[NSAlert alloc]init];
            
            alert.messageText = @"提示";
            
            alert.informativeText = @"注册信息已经提交给管理员,等待管理员审批";
            
            //设置提示框的样式
            alert.alertStyle = NSAlertStyleWarning;
            
            [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
                
                [weakself.window orderOut:nil];//关闭当前窗口
                
            }];
            
        }else{
            
            [weakself show:@"提示" andMessage:@"注册失败"];
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
    
    [alert beginSheetModalForWindow:self.window completionHandler:nil];
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

// 密码验证
-(BOOL)checkPassWord:(NSString *)passWord{
    NSString *regular = @"^(?![0-9~!@#$%^&*,._-]+$)(?![a-zA-Z~!@#$%^&*,._-]+$)[a-zA-Z0-9~!@#$%^&*,._-]{6,20}";
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    BOOL isRight = [Predicate evaluateWithObject:passWord];
    return isRight;
}

@end
