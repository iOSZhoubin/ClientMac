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

}

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem{

//    NSString *str = tabViewItem.label;
//
//    if([str isEqualToString:@"登录"]){
//
//        return NO;
//    }
    
    return YES;
}


- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem{
    
    JumpLog(@"将要点击某个item");
    
//    [self.tabView selectTabViewItem:self.registerItem]; //指定显示在某一个item上
}



@end
