//
//  WJCADisplayLinkHelper.h
//  Timer
//
//  Created by 曾维俊 on 2019/4/7.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 该类是对CADisplayLink的封装，使用无需考虑定时器生命周期
 
 不必考虑计时器内存释放问题
 */
@interface WJCADisplayLinkHelper : NSObject

/** NSTimer 实例 */
@property (nonatomic, strong, readonly) CADisplayLink *timer;

/**
 创建定时器管理类

 @param target 接受消息的目标对象
 @param sel 接受消息的选择器
 @return ‘WJCADisplayLinkHelper’实例
 */
+ (WJCADisplayLinkHelper *)displayLinkWithTarget:(id)target selector:(SEL)sel;

#pragma mark - Instance method
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
