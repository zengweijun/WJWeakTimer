//
//  WJGCDTimerHelper.m
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import "WJGCDTimerHelper.h"
#import "WJWeakTimerDefines.h"

static inline dispatch_source_t gcdTimer(void(^task)(void), NSTimeInterval delay, NSTimeInterval timerInterval, BOOL repeats, BOOL async) {
    
    if (task == nil || delay < 0 || (timerInterval <= 0 && repeats == YES)) {
        return nil;
    }
    
    // 创建队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay*NSEC_PER_SEC),
                              (uint64_t)timerInterval * NSEC_PER_SEC,
                              0);
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
    });
    return timer;
}

@interface WJGCDTimerHelper() {
    dispatch_semaphore_t _lock;
    dispatch_source_t _timer;
}

@property (nonatomic, assign) BOOL isRunning;

@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, assign) BOOL async;
@property (nonatomic, assign) NSTimeInterval timerInterval;

@property (nonatomic, strong, readwrite) id userInfo;
@property (nonatomic, copy) WJGCDTimerCallback timerCallback;

@end

@implementation WJGCDTimerHelper

#pragma mark - Public method

+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                         block:(WJGCDTimerCallback)block {
    return [self scheduledTimer:interval
                        repeats:YES
                          block:block];
}

+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                       repeats:(BOOL)repeats
                         block:(WJGCDTimerCallback)block {
    return [self scheduledTimerWithDelay:interval
                                interval:interval
                                 repeats:repeats
                                   async:NO
                                   block:block];
}

+ (instancetype)scheduledTimerWithDelay:(NSTimeInterval)delay
                               interval:(NSTimeInterval)interval
                                repeats:(BOOL)repeats
                                  async:(BOOL)async
                                  block:(WJGCDTimerCallback)block {
    
    return [[self alloc] initWithTask:block
                                delay:delay
                        timerInterval:interval
                              repeats:repeats
                                async:async
                           startTimer:YES];
}

+ (instancetype)scheduledTimerWithTarget:(id)aTarget
                                selector:(SEL)aSelector
                                   delay:(NSTimeInterval)delay
                                interval:(NSTimeInterval)interval
                                 repeats:(BOOL)yesOrNo
                                   async:(BOOL)async {
    
    __weak typeof(aTarget) weakTarget = aTarget;
    __weak typeof(self) weakSelf = self;
    WJGCDTimerHelper *timerHelper = [[self alloc] initWithTask:^(WJGCDTimerHelper * _Nonnull timerHelper) {
        __strong typeof(weakTarget) strongTarget = weakTarget;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongTarget && [strongTarget respondsToSelector:aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongTarget performSelector:aSelector withObject:strongSelf];
#pragma clang diagnostic pop
        }
    }
                                                         delay:delay
                                                 timerInterval:interval
                                                       repeats:yesOrNo
                                                         async:async
                                                    startTimer:YES];
    
    return timerHelper;
}

- (instancetype)initWithTimerInterval:(NSTimeInterval)timerInterval
                              repeats:(BOOL)yesOrNo
                                async:(BOOL)async
                                block:(WJGCDTimerCallback)block {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
    return [self initWithTask:block
                        delay:timerInterval
                timerInterval:timerInterval
                      repeats:yesOrNo
                        async:async
                   startTimer:NO];
#pragma clang diagnostic pop
}

- (void)resumeTimer {
    if (_timer) {
        dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
        if (!self.isRunning) {
            dispatch_resume(_timer);
            self.isRunning = YES;
        }
        dispatch_semaphore_signal(_lock);
        return;
    }
    
    [self _createTimerAndResumeWithDelay:self.timerInterval];
    [self resumeTimer];
}

- (void)stopTimer {
    if (_timer) {
        dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
        if (self.isRunning) {
            dispatch_source_cancel(_timer);
            _timer = nil;
            self.isRunning = NO;
        }
        dispatch_semaphore_signal(_lock);
    }
}

- (void)pauseTimer {
    [self stopTimer];
}

#pragma mark - Initializer method

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithTask:(WJGCDTimerCallback)task
                       delay:(NSTimeInterval)delay
               timerInterval:(NSTimeInterval)timerInterval
                     repeats:(BOOL)yesOrNo
                       async:(BOOL)async
                  startTimer:(BOOL)startTimer {
    if (self = [super init]) {
#pragma clang diagnostic pop
        
        self.repeats = yesOrNo;
        self.async = async;
        self.timerInterval = timerInterval;
        self.timerCallback = task;
        self.isRunning = NO;
        _lock = dispatch_semaphore_create(1);
        
        [self _createTimerAndResumeWithDelay:delay];
        
        if (startTimer) {
            [self resumeTimer];
        }
    }
    return self;
}

#pragma mark - Private method

- (void)_createTimerAndResumeWithDelay:(NSTimeInterval)delay {
    __weak typeof(self) weakSelf = self;
    _timer = gcdTimer(^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.timerCallback) {
            strongSelf.timerCallback(strongSelf);
        }
        
        if (strongSelf.repeats == NO) { // 如果不重复，执行一次就x取消
            [strongSelf stopTimer];
        }
    }, delay, self.timerInterval, self.repeats, self.async);
}

- (void)dealloc {
    [self stopTimer];
    WJWeakTimerLog(@"%s & CGDTimerIsDestroyed", __func__);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %p [GCDTimer: %p]", self.class,self, _timer];
}

@end
