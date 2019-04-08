//
//  WJTimerProxy.h
//  Timer
//
//  Created by 曾维俊 on 2019/4/6.
//  Copyright © 2019年 Nius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WJTimerProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
