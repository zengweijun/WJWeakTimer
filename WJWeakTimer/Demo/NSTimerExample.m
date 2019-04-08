//
//  NSTimerExample.m
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import "NSTimerExample.h"
#import "WJWeakTimer.h"

@interface NSTimerExample ()

@property (nonatomic, strong) WJNSTimerHelper *timerHelper;
@property (nonatomic, assign) BOOL paused; // For Test


@end

@implementation NSTimerExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 100, 200, 150)];
    textView.text =
    @"11111111111111\n"
    "11111111111111\n"
    "11111111111111\n"
    "11111111111111\n"
    "11111111111111\n"
    "11111111111111\n"
    "11111111111111\n"
    "11111111111111\n"
    "11111111111111\n";
    textView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:textView];
    textView.backgroundColor = [UIColor lightGrayColor];
    
    NSLog(@"%s", __func__);
    
    /// Block Type
    // 当滑动界面中的textView是会导致计时器暂停计时
    self.timerHelper = [WJNSTimerHelper scheduledTimer:1 block:^(WJNSTimerHelper * _Nonnull timerHelper) {
        NSLog(@"----------DefaultRunLoopMode:%@", timerHelper);
    }];
    
    // 当滑动界面中的textView时不会导致计时器暂停计时
//    self.timerHelper = [WJNSTimerHelper scheduledTimerInCommonModes:3 repeats:NO block:^(WJNSTimerHelper * _Nonnull timerHelper) {
//        NSLog(@"----------CommonRunLoopModes:%@", timerHelper);
//    }];
    
    // Normal Type
//    self.timerHelper = [WJNSTimerHelper scheduledTimer:4 target:self selector:@selector(timerAction:) repeats:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.paused) {
        NSLog(@"pauseTimer");
        [self.timerHelper pauseTimer];
    } else {
        NSLog(@"resumeTimer");
        [self.timerHelper resumeTimer];
    }
    self.paused = !self.paused;
}

- (void)timerAction:(WJNSTimerHelper *)timerHelper {
    NSLog(@"%s  (%@)", __func__, timerHelper);
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
