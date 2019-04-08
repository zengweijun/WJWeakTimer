//
//  GCDTimerExample.m
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import "GCDTimerExample.h"
#import "WJWeakTimer.h"

@interface GCDTimerExample ()
@property (nonatomic, strong) WJGCDTimerHelper *timerHelper;
@property (nonatomic, assign) BOOL paused; // For Test
@end

@implementation GCDTimerExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%s", __func__);
    
    self.timerHelper =
    [WJGCDTimerHelper scheduledTimerWithTimerInterval:1 timerCallback:^(WJGCDTimerHelper * _Nonnull timerHelper) {
        NSLog(@"%@", timerHelper);
    }];
    
    
//    self.timerHelper = [WJGCDTimerHelper scheduledTimerWithTarget:self selector:@selector(doTask:) delay:2 timerInterval:1 repeats:YES async:NO];
    
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

- (void)doTask:(WJGCDTimerHelper *)timerHelper {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
