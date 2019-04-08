//
//  WJWeakTimerDefines.h
//  WJWeakTimer
//
//  Created by 曾维俊 on 2019/4/8.
//  Copyright © 2019 nius. All rights reserved.
//

#ifndef WJWeakTimerDefines_h
#define WJWeakTimerDefines_h

#if DEBUG
#define WJWeakTimerLog(format, ...)  fprintf(stderr, "=====> ********* %s *********\n",[[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define WJWeakTimerLog(format, ...)
#endif

#endif /* WJWeakTimerDefines_h */
