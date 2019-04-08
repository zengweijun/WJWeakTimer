//
//  WJCADisplayLinkHelper.m
//  Timer
//
//  Created by 曾维俊 on 2019/4/7.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import "WJCADisplayLinkHelper.h"
#import "WJTimerProxy.h"
#import "WJWeakTimerDefines.h"

@interface WJCADisplayLinkHelper()

@property (nonatomic, weak)      id target;
@property (nonatomic, assign)   SEL selector;

@property (nonatomic, strong, readwrite) CADisplayLink *timer;

@end

@implementation WJCADisplayLinkHelper

#pragma mark - Class method
#pragma mark Convenient method

+ (WJCADisplayLinkHelper *)displayLinkWithTarget:(id)target selector:(SEL)sel {
    WJCADisplayLinkHelper *timerHelper = [[WJCADisplayLinkHelper alloc] initSelf];
    timerHelper.target = target;
    timerHelper.selector = sel;
    timerHelper.timer = [CADisplayLink displayLinkWithTarget:[WJTimerProxy proxyWithTarget:timerHelper] selector:@selector(timerAction:)];
    return timerHelper;
}

#pragma mark - Private method

- (instancetype)initSelf {
    if (self = [super init]) {
    }
    return self;
}

- (void)timerAction:(CADisplayLink *)link {
    if (self.target &&
        self.selector &&
        [self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
    }
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        [self setTimer:nil];
    }
    WJWeakTimerLog(@"%s", __func__);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %p [CADisplayLink: %p]", self.class,self, self.timer];
}

@end
