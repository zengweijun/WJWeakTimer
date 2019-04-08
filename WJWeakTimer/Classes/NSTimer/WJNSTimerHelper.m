//
//  WJNSTimerHelper.m
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import "WJNSTimerHelper.h"
#import "WJTimerProxy.h"
#import "WJWeakTimerDefines.h"

@interface WJNSTimerHelper()

@property (nonatomic, weak)      id target;
@property (nonatomic, assign)   SEL selector;

@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (nonatomic, strong, readwrite) id userInfo;
@property (nonatomic, copy) WJNSTimerCallback timerCallback;

@end

@implementation WJNSTimerHelper

#pragma mark - Class method
#pragma mark Convenient method


+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                         block:(WJNSTimerCallback)block {
    
    return [self scheduledTimer:interval
                        repeats:YES
                          block:block];
}

+ (instancetype)scheduledTimerInCommonModes:(NSTimeInterval)interval
                                      block:(WJNSTimerCallback)block {
    
    return [self scheduledTimerInCommonModes:interval
                                     repeats:YES
                                       block:block];
}

+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                       repeats:(BOOL)repeats
                         block:(WJNSTimerCallback)block {
    
    return [self scheduledTimer:interval
                        repeats:repeats
             pauseWhenSlidingUI:YES
                          block:block];
}

+ (instancetype)scheduledTimerInCommonModes:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                      block:(WJNSTimerCallback)block {
    
    return [self scheduledTimer:interval
                        repeats:repeats
             pauseWhenSlidingUI:NO
                          block:block];
}

+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                       repeats:(BOOL)repeats
            pauseWhenSlidingUI:(BOOL)pauseWhenSlidingUI
                         block:(WJNSTimerCallback)block {
    if (!block) {
        return nil;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    WJNSTimerHelper *timerHelper = [WJNSTimerHelper scheduledTimer:interval
                                                            target:nil
                                                          selector:nil
                                                           repeats:repeats
                                                pauseWhenSlidingUI:pauseWhenSlidingUI];
#pragma clang diagnostic pop
    
    timerHelper.timerCallback = block;
    return timerHelper;
}

+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                        target:(id)aTarget
                      selector:(SEL)aSelector
                       repeats:(BOOL)repeats {
    
    return [self scheduledTimer:interval
                         target:aTarget
                       selector:aSelector
                        repeats:repeats
             pauseWhenSlidingUI:YES];
}

+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                        target:(id)aTarget
                      selector:(SEL)aSelector
                       repeats:(BOOL)repeats
            pauseWhenSlidingUI:(BOOL)pauseWhenSlidingUI {
    
    return [self scheduledTimerWithDelay:interval
                                interval:interval
                                  target:aTarget
                                selector:aSelector
                                userInfo:nil
                                 repeats:repeats
                               inRunLoop:nil
                            runLoopModel:pauseWhenSlidingUI ? NSDefaultRunLoopMode : NSRunLoopCommonModes];
}

+ (instancetype)scheduledTimerWithDelay:(NSTimeInterval)delay
                               interval:(NSTimeInterval)interval
                                 target:(id)aTarget
                               selector:(SEL)aSelector
                               userInfo:(nullable id)userInfo
                                repeats:(BOOL)yesOrNo
                              inRunLoop:(NSRunLoop *)runLoop
                           runLoopModel:(NSRunLoopMode)mode {
    
    WJNSTimerHelper *timerHelper = [[WJNSTimerHelper alloc] initTimerHelperWithDelay:delay
                                                                            interval:interval
                                                                              target:aTarget
                                                                            selector:aSelector
                                                                            userInfo:userInfo
                                                                             repeats:yesOrNo];
    NSRunLoop *aRunLoop = runLoop ? runLoop : [NSRunLoop currentRunLoop];
    NSRunLoopMode aModel = mode ? mode : NSDefaultRunLoopMode;
    [aRunLoop addTimer:timerHelper.timer forMode:aModel];
    return timerHelper;
}

#pragma mark - Private method

- (void)timerAction:(NSTimer *)timer {
    if (self.target &&
        self.selector &&
        [self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
        return;
    }
    
    if (self.timerCallback){
        self.timerCallback(self);
    }
}

#pragma mark - Instance method
- (instancetype)initTimerHelperWithInterval:(NSTimeInterval)interval
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
    return [self initTimerHelperWithDelay:interval interval:interval target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
#pragma clang diagnostic pop
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initTimerHelperWithDelay:(NSTimeInterval)delay
                                interval:(NSTimeInterval)interval
                                  target:(id)aTarget
                                selector:(SEL)aSelector
                                userInfo:(nullable id)userInfo
                                 repeats:(BOOL)yesOrNo {
    if (self = [super init]) {
#pragma clang diagnostic pop
        self.target = aTarget;
        self.selector = aSelector;
        self.userInfo = userInfo;
        
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:delay]
                                              interval:interval
                                                target:[WJTimerProxy proxyWithTarget:self]
                                              selector:@selector(timerAction:)
                                              userInfo:userInfo
                                               repeats:yesOrNo];
    }
    return self;
}

- (void)resumeTimer {
    [self.timer setFireDate:[NSDate date]];
}

- (void)pauseTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)stopTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
        [self setTimer:nil];
    }
}

- (void)dealloc {
    [self stopTimer];
    WJWeakTimerLog(@"%s", __func__);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %p [NSTimer: %p]", self.class,self, self.timer];
}

@end
