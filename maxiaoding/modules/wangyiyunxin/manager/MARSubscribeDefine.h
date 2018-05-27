//
//  MARSubscribeDefine.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/5/19.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#ifndef MARSubscribeDefine_h
#define MARSubscribeDefine_h

extern NSString *const MARSubscribeNetState;

extern NSString *const MARSubscribeOnlineState;

typedef NS_ENUM(NSInteger, MARCustomStateValue) {
    MARCustomStateValueOnlineExt = 10001,
};


typedef NS_ENUM(NSInteger, NTESOnlineState){
    MAROnlineStateNormal, //在线
    MAROnlineStateBusy,   //忙碌
    MAROnlineStateLeave,  //离开
};

#endif /* MARSubscribeDefine_h */
