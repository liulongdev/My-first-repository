//
//  MARNetworkResponse.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+MARModel.h>

@interface MARNetworkResponse : NSObject <MARModelDelegate>

@property (nonatomic, assign) NSInteger errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) NSString *body;

- (BOOL)isSuccess;

@end
