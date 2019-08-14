//
//  FirstPageViewController.m
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/7.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "FirstPageViewController.h"
#import "LoginViewController.h"
#import "JumpRegistereViewController.h"
#import "CheckupViewController.h"
#import "AgreeInternetViewController.h"

@interface FirstPageViewController ()<NSTabViewDelegate>

//登录
@property (strong,nonatomic) LoginViewController *loginVc;
@property (weak) IBOutlet NSTabViewItem *loginItem;
//注册
@property (strong,nonatomic) JumpRegistereViewController *registerVc;
@property (weak) IBOutlet NSTabViewItem *registerItem;
//安检
@property (strong,nonatomic) CheckupViewController *checkupVc;
@property (weak) IBOutlet NSTabViewItem *checkupItem;
//入网
@property (strong,nonatomic) AgreeInternetViewController *agreeInternetVc;
@property (weak) IBOutlet NSTabViewItem *agreeInItem;
//tabView
@property (weak) IBOutlet NSTabView *tabView;

//通知传过来的
@property (copy,nonatomic) NSString *titleStr;

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabView.delegate = self;
    
    
    //添加对应的控制器
    self.loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    self.registerVc = [[JumpRegistereViewController alloc]initWithNibName:@"JumpRegistereViewController" bundle:nil];
    self.checkupVc = [[CheckupViewController alloc]initWithNibName:@"CheckupViewController" bundle:nil];
    self.agreeInternetVc = [[AgreeInternetViewController alloc]initWithNibName:@"AgreeInternetViewController" bundle:nil];

    
    self.loginItem.view = self.loginVc.view;
    self.registerItem.view = self.registerVc.view;
    self.checkupItem.view = self.checkupVc.view;
    self.agreeInItem.view = self.agreeInternetVc.view;
    
    [KNotification addObserver:self selector:@selector(notifi:) name:@"FirstPageViewController" object:nil];
}

- (void)notifi:(NSNotification *)note{
    
    self.titleStr = SafeString(note.userInfo[@"title"]);
    
    if([self.titleStr isEqualToString:@"登录"]){
        
        [self.tabView selectTabViewItem:self.loginItem];
        
    }else if ([self.titleStr isEqualToString:@"注册"]){
        
        [self.tabView selectTabViewItem:self.registerItem];

    }else if ([self.titleStr isEqualToString:@"安检"]){
        
        [self.tabView selectTabViewItem:self.checkupItem];

    }else if ([self.titleStr isEqualToString:@"入网"]){

        [self.tabView selectTabViewItem:self.agreeInItem];

    }
    
}

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem{

    NSString *str = tabViewItem.label;

    if([self.titleStr isEqualToString:@"登录"]){
        
        if([str isEqualToString:@"登录"]){
            
            return YES;
            
        }else{
            
            return NO;
        }
        
    }else if ([self.titleStr isEqualToString:@"注册"]){
        
        if([str isEqualToString:@"注册"]){
            
            return YES;
            
        }else{
            
            return NO;
        }
        
    }else if ([self.titleStr isEqualToString:@"安检"]){
        
        if([str isEqualToString:@"安检"]){
            
            return YES;
            
        }else{
            
            return NO;
        }
        
    }else if ([self.titleStr isEqualToString:@"入网"]){
        
        if([str isEqualToString:@"入网"]){
            
            return YES;
            
        }else{
            
            return NO;
        }
        
    }else{
        
        if([str isEqualToString:@"登录"]){
            
            return YES;
            
        }else{
            
            return NO;
        }
    }
}


- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem{
    
    JumpLog(@"将要点击某个item");
    
//    [self tabView:tabView shouldSelectTabViewItem:tabViewItem];
    
//    [self.tabView selectTabViewItem:self.registerItem]; //指定显示在某一个item上
}



@end
