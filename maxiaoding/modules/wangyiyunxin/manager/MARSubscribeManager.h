//
//  MARSubscribeManager.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/5/19.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@interface MARSubscribeManager : NSObject

+ (instancetype)sharedManager;

- (void)start;

- (NSDictionary<NIMSubscribeEvent *, NSString *> *)eventsForType:(NSInteger)type;

- (void)subscribeTempUserOnlineState:(NSString *)userId;

- (void)unsubscribeTempUserOnlineState:(NSString *)userId;

@end
