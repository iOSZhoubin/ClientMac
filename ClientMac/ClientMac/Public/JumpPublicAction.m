//
//  JumpPublicAction.m
//  MacOSJump
//
//  Created by jumpapp1 on 2019/4/18.
//  Copyright © 2019年 zb. All rights reserved.
//

#import "JumpPublicAction.h"

//wifi信息
#import <sys/socket.h>
#import <ifaddrs.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#include <netdb.h>
#import <dlfcn.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@implementation JumpPublicAction







#pragma mark -- 获取本机IP地址和Mac地址

+ (NSString *)getDeviceIPAddress {
    
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


//+(NSString *)getDeviceMacAddress{
//
//    NSString *macDeviceAddress = @"";
//    kern_return_t kr;
//    CFMutableDictionaryRef matchDict;
//    io_iterator_t iterator;
//    io_registry_entry_t entry;
//
//    matchDict = IOServiceMatching("IOEthernetInterface");
//    kr = IOServiceGetMatchingServices(kIOMasterPortDefault, matchDict, &iterator);
//
//    NSDictionary *resultInfo = nil;
//
//    while ((entry = IOIteratorNext(iterator)) != 0)
//    {
//        CFMutableDictionaryRef properties=NULL;
//        kr = IORegistryEntryCreateCFProperties(entry,
//                                               &properties,
//                                               kCFAllocatorDefault,
//                                               kNilOptions);
//        if (properties)
//        {
//            resultInfo = (__bridge_transfer NSDictionary *)properties;
//            NSString *bsdName = [resultInfo objectForKey:@"BSD Name"];
//            NSData *macData = [resultInfo objectForKey:@"IOMACAddress"];
//            if (!macData)
//            {
//                continue;
//            }
//
//            NSMutableString *macAddress = [[NSMutableString alloc] init];
//            const UInt8 *bytes = [macData bytes];
//            for (int i=0; i<macData.length; i++)
//            {
//                [macAddress appendFormat:@"%02x",*(bytes+i)];
//            }
//
//            //打印Mac地址
//            //            if (bsdName && macAddress)
//            //            {
//            //                NSLog(@"网卡:%@\nMac地址:%@\n",bsdName,macAddress);
//            //            }
//            //
//            macDeviceAddress = macAddress;
//
//        }
//    }
//
//    IOObjectRelease(iterator);
//
//
//    return macDeviceAddress;
//
//}

+(NSString *)getDeviceMacAddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    
    ifm = (struct if_msghdr *)buf;
    
    sdl = (struct sockaddr_dl *)(ifm + 1);
    
    ptr = (unsigned char *)LLADDR(sdl);
    
    
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    // release pointer
    free(buf);
    
    return [outstring lowercaseString];
}


//密码MD5

+(NSString *)md5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16];
    for (int i = 0; i< 16; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


//正则校验邮箱
+(BOOL)isEmailAdress:(NSString *)email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:email];
}


/**
 判断特殊字符
 
 @param intriduction 输入的字符
 @return YES-通过 NO-不通过
 */
+(BOOL)specialRight:(NSString *)intriduction{
    
    NSString *newStr = [intriduction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray *specialStringArray = [NSMutableArray array];
    
    NSString *string = @"~,￥,#,&,*,<,>,《,》,(,),[,],{,},【,】,^,@,/,￡,¤,|,§,¨,「,」,『,』,￠,￢,￣,（,）,——,+,|,$,€, ,¥,!,%";

    BOOL isRight = NO;
    
    NSArray *array = [string componentsSeparatedByString:@","];
    
    [specialStringArray addObjectsFromArray:array];
    
    for (NSInteger i=0; i<specialStringArray.count; i++) {
        
        if ([newStr rangeOfString:specialStringArray[i]].location != NSNotFound) {
            
            isRight = NO;
            
            break;
            
        }else{
            
            isRight = YES;
            
            continue;
        }
    }
    
    return isRight;
}

@end
