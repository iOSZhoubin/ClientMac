//
//  JumpCompanyModel.h
//  MacOSJump
//
//  Created by jumpapp1 on 2019/3/5.
//  Copyright © 2019年 zb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JumpCompanyModel : NSObject

//部门id
@property (copy,nonatomic) NSString *uid;
//1-还有子节点  0-无子节点
@property (copy,nonatomic) NSString *isLeaf;
//公司名称
@property (copy,nonatomic) NSString *text;
//子节点数组
@property (strong,nonatomic) NSMutableArray<JumpCompanyModel *> *children;

@end
