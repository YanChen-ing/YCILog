//
//  YCILogCrashManager.h
//  Pods
//
//  Created by yanchen on 2017/6/20.
//
//

#import <Foundation/Foundation.h>

@interface YCILogCrashManager : NSObject

+ (instancetype)sharedInstance;

- (nullable NSString *)startPLCrashReporter;

- (void)uploadCrashReportSuccess;


@end
