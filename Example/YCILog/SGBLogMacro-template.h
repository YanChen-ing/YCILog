//
//  SGBLogMacro.h
//  mbodata
//
//  Created by yanchen on 2017/7/5.
//  Copyright © 2017年 yanchen. All rights reserved.
//

#ifndef SGBLogMacro_h
#define SGBLogMacro_h

#pragma mark - ------- 调试日志

/*
 这几级日志，仅在 XCode 调试控制台输出，不输出到系统控制台。
 VERBOSE < DEBUG < INFO < WARNING < ERROR
 
 TRACK 级别日志，控制应用内埋点输出，及BIZLog中自动追踪的开关。
 
 CONSOLE 级别日志，表示要输出到系统控制台中，无论什么模式，必定输出。
 
 */

 #ifndef __OPTIMIZE__
// = DEBUG , QA

// 这几级日志，仅在 XCode 调试控制台输出，不输出到系统控制台

#define ON_LOOG_VERBOSE
#define ON_LOOG_DEBUG
#define ON_LOOG_INFO
#define ON_LOOG_WARNING
#define ON_LOOG_ERROR

#define ON_LOOG_TRACK

#else
// = RELEASE

//#define ON_LOOG_VERBOSE
//#define ON_LOOG_DEBUG
//#define ON_LOOG_INFO
//#define ON_LOOG_WARNING
//#define ON_LOOG_ERROR

#define ON_LOOG_TRACK

#endif

////////////////////// 控制台级 必需要发送 /////////////////////

#define loog_Console(msg) \
[SGBLog console:msg];

/////////////////////// 追踪级 日志 /////////////////////
#ifdef ON_LOOG_TRACK

#define loog_Track(dictionary) \
[SGBLog track:dictionary :@"" :@"" line:0 context:nil];

#define loog_TrackEvent(event,content) \
[SGBLog trackEventWithEvent:event page:nil content:content];

#else

#define loog_Track(dictionary)
#define loog_TrackEvent(event,content)

#endif

/////////////////////// 详情级 日志 /////////////////////
#ifdef ON_LOOG_VERBOSE

#define loog_Verbose(format, ...) do { \
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];\
formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";\
printf("%s\n", [[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] UTF8String]);\
fprintf(stderr, " 💜 VERBOSE <%s : %d> %s -- %s",  \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
printf("\n"); \
} while (0);

//#define loog_Verbose(format, ...) NSLog(format, ##__VA_ARGS__);

#else

#define loog_Verbose(format, ...)

#endif


/////////////////////// 调试级 日志 /////////////////////
#ifdef ON_LOOG_DEBUG

#define loog_Debug(format, ...) do { \
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];\
formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";\
printf("%s\n", [[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] UTF8String]);\
fprintf(stderr, " 💚 DEBUG <%s : %d> %s -- %s",  \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
printf("\n"); \
} while (0);

#else

#define loog_Debug(format, ...)

#endif

/////////////////////// 信息级 日志 /////////////////////
#ifdef ON_LOOG_INFO

#define loog_Info(format, ...) do { \
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];\
formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";\
printf("%s\n", [[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] UTF8String]);\
fprintf(stderr, " 💙 INFO <%s : %d> %s -- %s",  \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
printf("\n"); \
} while (0);


#else

#define loog_Info(format, ...)

#endif


/////////////////////// 警告级 日志 /////////////////////
#ifdef ON_LOOG_WARNING

#define loog_Warning(format, ...) do { \
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];\
formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";\
printf("%s\n", [[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] UTF8String]);\
fprintf(stderr, " 💛 WARNING <%s : %d> %s -- %s",  \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
printf("\n"); \
} while (0);


#else

#define loog_Warning(format, ...)

#endif


//////////////////////// 错误级 日志 /////////////////////
#ifdef ON_LOOG_ERROR

#define loog_Error(format, ...) do { \
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];\
formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";\
printf("%s\n", [[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] UTF8String]);\
fprintf(stderr, " ❤️ ERROR <%s : %d> %s -- %s",  \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
printf("\n"); \
} while (0);

#else

#define loog_Error(format, ...)

#endif
