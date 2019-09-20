//
//  InterfaceHeader.h
//  ClientMac
//
//  Created by jumpapp1 on 2019/8/12.
//  Copyright © 2019年 zb. All rights reserved.
//

#ifndef InterfaceHeader_h
#define InterfaceHeader_h

//获取注册title
#define Mac_RegInfoName @"/mobile/getRegInfoName.action"
//获取短信验证码
#define Mac_CreatCode @"/mobile/getMessageCode.action"
//登录
#define Mac_Login @"/mobile/mobileLogin.action"
//修改个人信息
#define Mac_Register @"/mobile/updateUser.action"
//获取个人信息
#define Mac_GetUserInfo @"/mobile/getUserMessage.action"
//获取部门组织树
#define Mac_CompanyTree @"/mobile/getDepTree.action"
//获取配置的登录方式
#define Mac_GetloginType @"/mobile/getMobileConfig.action"
//获取检查项
#define Mac_CheckEntry @"/mobile/getCheck.action"
//获取服务器信息
#define Mac_ServerInfo @"/mobile/getServiceInfo.action"
//校验手机号是否为内网手机号
#define Mac_IsIntranet @"/mobile/getCheckNetMobile.action"
//更新手机号到设备详情
#define Mac_UpdataPhone @"/mobile/updateDevinfoPhone.action"
//注册用户
#define Mac_Registed @"/mobile/registUser.action"
//查看设备是否在线
#define Mac_DeviceisOnline @"/mobile/getMachineIsOnline.action"
//上报告警信息
#define Mac_Waring @"/mobile/setWarnInfo.action"


#endif /* InterfaceHeader_h */
