//
//  CustomMessageCellView.h
//  MacVpn
//
//  Created by jumpapp1 on 2019/6/24.
//  Copyright © 2019年 zb. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomMessageCellView : NSTableCellView

-(void)refreshWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
