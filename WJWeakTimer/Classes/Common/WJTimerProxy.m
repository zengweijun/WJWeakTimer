//
//  WJTimerProxy.m
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import "WJTimerProxy.h"
#import "WJWeakTimerDefines.h"

@interface WJTimerProxy()

@property (nonatomic, weak) id target;

@end

@implementation WJTimerProxy

+ (instancetype)proxyWithTarget:(id)target {
    WJTimerProxy *proxy = [WJTimerProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

- (void)dealloc {
    WJWeakTimerLog(@"%s", __func__);
}

@end
