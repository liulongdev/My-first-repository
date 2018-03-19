//
//  MARMultipleDelegateProxy.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/3/16.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARMultipleDelegateProxy.h"

@interface MARMultipleDelegateProxy ()
@property (nonatomic, strong) NSPointerArray *weakRefTargets;
@end

@implementation MARMultipleDelegateProxy

- (void)setDelegateTargets:(NSArray *)delegateTargets
{
    self.weakRefTargets = [NSPointerArray weakObjectsPointerArray];
    for (id delegate in delegateTargets) {
        [self.weakRefTargets addPointer:(__bridge  void *)delegate];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    for (id target in self.weakRefTargets) {
        if ([target respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (!sig) {
        for (id target in self.weakRefTargets) {
            if ((sig = [target methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    return sig;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    for (id target in self.weakRefTargets) {
        if ([target respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:target];
        }
    }
}

@end
