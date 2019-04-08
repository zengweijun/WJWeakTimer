//
//  WJNSTimerHelper.h
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WJNSTimerHelper;
typedef void(^WJNSTimerCallback)(WJNSTimerHelper *timerHelper);

/**
 该类是对NSTimer的封装，使用无需考虑定时器生命周期
 外部只需选择使用合适的方法就可以实现计时功能，不必考虑计时器内存释放问题
 
 如果需要准确计时，不推荐使用该类，因为NSTimer计时依赖于NSRunLoop循环
 RunLoop循环的速度又受到每次一循环周期内任务时间复杂度的影响，如果RunLoop任务过于繁重，会导致计时不准
 因此NSTimer并不准确，如果需要准确计时，推荐使用‘WJCGDTimerHelper’
 
 特殊场景推荐使用：如滑动UI是需要定时器暂停的业务场景
 */
@interface WJNSTimerHelper : NSObject

/** NSTimer 实例 */
@property (nonatomic, strong, readonly) NSTimer *timer;

/** 自定义信息 */
@property (nonatomic, strong, readonly) id userInfo;

#pragma mark - Class method
#pragma mark Convenient method

/**
 调用计时器开始计时(滑动UI时计时器会暂停)
 
 @param interval 计时间隔
 @param block 计时回调
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                         block:(WJNSTimerCallback)block;

/**
 调用计时器开始计时(滑动UI时计时器不会暂停)
 
 @param interval 计时间隔
 @param block 计时回调
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimerInCommonModes:(NSTimeInterval)interval
                                      block:(WJNSTimerCallback)block;

/**
 调用计时器开始计时(滑动UI时计时器会暂停)
 
 @param interval 计时间隔
 @param repeats YES：重复计时，NO：单次计时
 @param block 计时回调
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                       repeats:(BOOL)repeats
                         block:(WJNSTimerCallback)block;

/**
 调用计时器开始计时(滑动UI时计时器不会暂停)
 
 @param interval 计时间隔
 @param repeats YES：重复计时，NO：单次计时
 @param block 计时回调
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimerInCommonModes:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                      block:(WJNSTimerCallback)block;


/**
 调用计时器开始计时

 @param interval 计时间隔
 @param repeats YES：重复计时，NO：单次计时
 @param pauseWhenSlidingUI
    YES：滑动UI的时候计时器会暂停
    NO：不论是否滑动UI都保持计时
 @param block 计时回调
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                       repeats:(BOOL)repeats
            pauseWhenSlidingUI:(BOOL)pauseWhenSlidingUI
                         block:(WJNSTimerCallback)block;

/**
 调用计时器开始计时(滑动UI时计时器会暂停)
 
 @param interval 计时间隔
 @param aTarget 接受消息的目标对象
 @param aSelector 接受消息的选择器
 @param repeats YES：重复计时，NO：单次计时
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                        target:(id)aTarget
                      selector:(SEL)aSelector
                       repeats:(BOOL)repeats;

/**
 调用计时器开始计时

 @param interval 计时间隔
 @param aTarget 接受消息的目标对象
 @param aSelector 接受消息的选择器
 @param repeats YES：重复计时，NO：单次计时
 @param pauseWhenSlidingUI
    YES：滑动UI的时候计时器会暂停
    NO：不论是否滑动UI都保持计时
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimer:(NSTimeInterval)interval
                        target:(id)aTarget
                      selector:(SEL)aSelector
                       repeats:(BOOL)repeats
            pauseWhenSlidingUI:(BOOL)pauseWhenSlidingUI;

/**
 调用计时器开始计时

 @param delay 延迟多少秒后开始计时
 @param interval 计时间隔
 @param aTarget 接受消息的目标对象
 @param aSelector 接受消息的选择器
 @param userInfo 自定义信息
 @param yesOrNo YES：重复计时，NO：单次计时
 @param runLoop 计时器所处的timer对象(传入nil默认使用当前所在RunLoop)
 @param mode 计时器所处RunLoop的Mode(传入nil默认使用NSDefaultRunLoopMode)
 @return ‘WJNSTimerHelper’实例
 */
+ (instancetype)scheduledTimerWithDelay:(NSTimeInterval)delay
                               interval:(NSTimeInterval)interval
                                 target:(id)aTarget
                               selector:(SEL)aSelector
                               userInfo:(nullable id)userInfo
                                repeats:(BOOL)yesOrNo
                              inRunLoop:(NSRunLoop *_Nullable)runLoop
                           runLoopModel:(NSRunLoopMode _Nullable)mode;

#pragma mark - Instance method
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 指定初始化方法(需要手动添加到RunLoop)
 
 @param interval 计时间隔
 @param aTarget 接受消息的目标对象
 @param aSelector 接受消息的选择器
 @param userInfo 自定义信息
 @param yesOrNo YES：重复计时，NO：单次计时
 @return ‘WJNSTimerHelper’实例
 */
- (instancetype)initTimerHelperWithInterval:(NSTimeInterval)interval
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo NS_DESIGNATED_INITIALIZER;

/** 关闭计时器 */
- (void)stopTimer;

/** 重新启动计时器 */
- (void)resumeTimer;

/** 暂停计时器 */
- (void)pauseTimer;

@end

NS_ASSUME_NONNULL_END
