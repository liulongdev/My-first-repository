//
//  MARPhoneOperationVC.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"

@interface MARPhoneOperationVC : MARBaseViewController
@property (nonatomic, assign) MARPhoneOperationType operationType;
@property (nonatomic, strong) NSString *phoneNumber;
@end
