//
//  WJGCDTimerHelper.h
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WJGCDTimerHelper;
typedef void(^WJGCDTimerCallback)(WJGCDTimerHelper *timerHelper);

/**
 该类是对GCDTimer的封装，使用无需考虑定时器生命周期
 外部只需选择使用合适的方法就可以实现计时功能，不必考虑计时器内存释放问题
 
 由于GCDTimer不依赖RunLoop，相对NSTimer会更加准确
 */
@interface WJGCDTimerHelper : NSObject

/**
 调用计时器开始计时

 @param interval 计时间隔
 @param block 计时回调
 @return ‘WJGCDTimerHelper’实例
 */
+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                         block:(WJGCDTimerCallback)block;

/**
 调用计时器开始计时

 @param interval 计时间隔
 @param repeats YES：重复计时，NO：单次计时
 @param block 计时回调
 @return ‘WJGCDTimerHelper’实例
 */
+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                       repeats:(BOOL)repeats
                         block:(WJGCDTimerCallback)block;

/**
 调用计时器开始计时

 @param delay 延迟多少秒后开始计时
 @param interval 计时间隔
 @param repeats YES：重复计时，NO：单次计时
 @param async 是否在子线程中执行计时
 @param block 计时回调
 @return ‘WJGCDTimerHelper’实例
 */
+ (instancetype)scheduledTimerWithDelay:(NSTimeInterval)delay
                               interval:(NSTimeInterval)interval
                                repeats:(BOOL)repeats
                                  async:(BOOL)async
                                  block:(WJGCDTimerCallback)block;

/**
 调用计时器开始计时

 @param aTarget 接受消息的目标对象
 @param aSelector 接受消息的选择器
 @param delay 延迟多少秒后开始计时
 @param interval 计时间隔
 @param yesOrNo YES：重复计时，NO：单次计时
 @param async 是否在子线程中执行计时
 @return ‘WJGCDTimerHelper’实例
 */
+ (instancetype)scheduledTimerWithTarget:(id)aTarget
                                selector:(SEL)aSelector
                                   delay:(NSTimeInterval)delay
                                interval:(NSTimeInterval)interval
                                 repeats:(BOOL)yesOrNo
                                   async:(BOOL)async;

#pragma mark - Instance method
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 指定初始化方法

 @param timerInterval 计时间隔
 @param yesOrNo YES：重复计时，NO：单次计时
 @param async 是否在子线程中执行计时
 @param block 计时回调
 @return ‘WJGCDTimerHelper’实例
 */
- (instancetype)initWithTimerInterval:(NSTimeInterval)timerInterval
                              repeats:(BOOL)yesOrNo
                                async:(BOOL)async
                                block:(WJGCDTimerCallback)block
                        NS_DESIGNATED_INITIALIZER;

/** 关闭计时器 */
- (void)stopTimer;

/** 重新启动计时器 */
- (void)resumeTimer;

/** 暂停计时器 */
- (void)pauseTimer;


@end

NS_ASSUME_NONNULL_END
