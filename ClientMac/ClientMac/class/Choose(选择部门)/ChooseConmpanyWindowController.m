//
//  ChooseConmpanyWindowController.m
//  MacOSJump
//
//  Created by jumpapp1 on 2019/3/5.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "ChooseConmpanyWindowController.h"
#import "JumpCompanyModel.h"

@interface ChooseConmpanyWindowController ()<NSOutlineViewDelegate,NSOutlineViewDataSource>

@property (weak) IBOutlet NSOutlineView *outlineView;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (strong,nonatomic) NSMutableDictionary *dataDict;

@property (strong,nonatomic) NSAlert *alert;

@end

@implementation ChooseConmpanyWindowController

-(NSAlert *)alert{
    
    if(!_alert){
        
        _alert = [[NSAlert alloc]init];
        
        _alert.messageText = @"温馨提示";
        
        _alert.informativeText = @"请选择部门";

        //设置提示框的样式
        _alert.alertStyle = NSAlertStyleWarning;
        
    }
    
    return _alert;
}

-(NSMutableDictionary *)dataDict{
    
    if(!_dataDict){
        
        _dataDict = [NSMutableDictionary dictionary];
    }
    
    return _dataDict;
}

-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.outlineView.delegate = self;
    
    self.outlineView.dataSource = self;
    
    [self getCompany];

}

#pragma mark --- NSOutlineViewDataSource

//显示有多少个节点
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item{
    
    
    if (item == nil) {
        
        return self.dataArray.count;
    }
    
    NSDictionary *dict = item;
    
    return [dict[@"children"] count];
    
}

//每个节点的数据
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item{
    
    if (item == nil) {
        
        return self.dataArray[index];
        
    }
    
    NSDictionary *dict = item;
    
    NSArray *array = dict[@"children"];
    
    return array[index];
    
    
}


//节点是否展开
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    
    
    NSDictionary *dict = item;
    
    NSArray *array = dict[@"children"];
    
    if(array.count > 0){
        
        return YES;
    }
    
    return NO;
}



//节点显示的内容
- (nullable id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn byItem:(nullable id)item{
    
    NSDictionary *dict = item;
    
    NSString *str = SafeString(dict[@"text"]);
    
    return str;
    
}


#pragma mark --- NSOutlineViewDelegate

//单击某一行
- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
    
    NSOutlineView *outlineView = notification.object;
    
    NSDictionary *selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    
    NSInteger selectRow = [outlineView selectedRow];
    
//    if(selectRow != 0){
    if(selectRow >= 0){

        self.dataDict[@"text"] = SafeString(selectedItem[@"text"]);
        self.dataDict[@"id"] = SafeString(selectedItem[@"id"]);
    
    }else{
        
        self.dataDict[@"text"] = @"";
        self.dataDict[@"id"] = @"";
    }
    
//    NSArray *array = selectedItem[@"children"];
//
//    if(array.count > 0){
//
//        self.dataDict[@"text"] = @"";
//        self.dataDict[@"id"] = @"";
//
//    }else{
//
//        self.dataDict[@"text"] = SafeString(selectedItem[@"text"]);
//        self.dataDict[@"id"] = SafeString(selectedItem[@"id"]);

//    }
}


#pragma mark --- 确认选择

- (IBAction)finishAction:(NSButton *)sender {
    
    if(SafeString(self.dataDict[@"text"]).length > 0){
        
        [self.delegate selectCompany:self.dataDict];
        
        [self.window orderOut:nil];//关闭当前窗口

    }else{

        [self.alert beginSheetModalForWindow:self.window completionHandler:nil];
    }
}




#pragma mark --- 获取公司组织架构

-(void)getCompany{
    
    L2CWeakSelf(self);
    
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac_userMessage"];

     NSString *userId = SafeString(defaultDict[@"userId"]);
    
    [AFNHelper macPost:Mac_CompanyTree parameters:@{@"userId":userId} success:^(id responseObject) {
        
        NSArray *childArray = responseObject;
        
        self.dataArray = childArray.mutableCopy;
        
        [weakself.outlineView reloadData];
        
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

- (IBAction)refresh:(NSButton *)sender {
    
    [self getCompany];

}

@end
