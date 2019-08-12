//
//  HistoryRecordViewController.m
//  MacOSJump
//
//  Created by jumpapp1 on 2019/3/19.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "HistoryRecordViewController.h"
#import "CustomMessageCellView.h"

@interface HistoryRecordViewController ()<NSTableViewDelegate,NSTableViewDataSource>

//tableview
@property (weak) IBOutlet NSTableView *tableView;
//数据源
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HistoryRecordViewController


-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"CustomMessageCellView" bundle:nil] forIdentifier:@"CustomMessageCellView"];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];

    self.dataArray = array.mutableCopy;

    [self.tableView reloadData];
    
    [KNotification addObserver:self selector:@selector(notifi:) name:@"HistoryRecordViewController" object:nil];

}


- (void)notifi:(NSNotification *)note{
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    
    self.dataArray = array.mutableCopy;
    
    [self.tableView reloadData];
}



#pragma mark --- NSTableViewDelegate,NSTableViewDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    
    return 75;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    if([tableColumn.identifier isEqualToString:@"oneColumn"]){
        
        NSTableCellView *oneCell = [tableView makeViewWithIdentifier:@"oneCell" owner:self];
        
        oneCell.textField.stringValue = self.dataArray[row][@"time"];
        
        return oneCell;
        
    }else if([tableColumn.identifier isEqualToString:@"twoColumn"]){
        
        NSTableCellView *twoCell = [tableView makeViewWithIdentifier:@"twoCell" owner:self];
        
        twoCell.textField.stringValue = self.dataArray[row][@"status"];
        
        return twoCell;
    
    }else{
        
        CustomMessageCellView *cellView = [tableView makeViewWithIdentifier:@"CustomMessageCellView" owner:self];
        
        NSString *content = self.dataArray[row][@"desc"];
        
        [cellView refreshWithContent:content];
        
        return cellView;
    }
}



#pragma mark --- 清空记录

- (IBAction)deleteRecords:(NSButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"status"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.dataArray = nil;
    
    [self.tableView reloadData];
}

-(void)dealloc{
    
    [KNotification removeObserver:self];
}

@end
