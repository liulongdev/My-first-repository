//
//  css.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#ifndef css_h
#define css_h

// 颜色
#define APPNaviTint 0x666666
#define APPNaviBarTint 0xf9f9f9 // 0xff0062
#define MARColor_VCBackgound 0xf5f5f5

// 字体
#ifndef kSCALE
#define kSCALE(value)           (value * ([UIScreen mainScreen].bounds.size.width/320.0f))
#endif
#define MARFont(_fontSize) ([UIFont systemFontOfSize:kSCALE(_fontSize)])
#define MARBoldFont(_fontSize) ([UIFont boldSystemFontOfSize:kSCALE(_fontSize)])
#endif /* css_h */
