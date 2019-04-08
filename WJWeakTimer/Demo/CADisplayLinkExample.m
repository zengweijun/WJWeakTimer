//
//  CADisplayLinkExample.m
//  WJWeakTimer
//
//  Created by 曾维俊 on 2019/4/8.
//  Copyright © 2019 nius. All rights reserved.
//

#import "CADisplayLinkExample.h"
#import "WJWeakTimer.h"

@interface CADisplayLinkExample ()

@property (nonatomic, strong) WJCADisplayLinkHelper *linkTimerHelper;

@end

@implementation CADisplayLinkExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.linkTimerHelper = [WJCADisplayLinkHelper displayLinkWithTarget:self selector:@selector(doLinkAction:)];
    [self.linkTimerHelper.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)doLinkAction:(WJCADisplayLinkHelper *)timerHelper {
    NSLog(@"%s  (%@)", __func__, timerHelper);
}

@end
