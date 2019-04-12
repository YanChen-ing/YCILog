//
//  YCILogCrashManager.m
//  Pods
//
//  Created by yanchen on 2017/6/20.
//
//

#import "YCILogCrashManager.h"

#import "sys/utsname.h"
#import <execinfo.h>

#import <CrashReporter/CrashReporter.h>
#import <CrashReporter/PLCrashReportTextFormatter.h>

#import <mach-o/dyld.h>

intptr_t calculateSlideAddress(void) {
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            intptr_t vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
            return vmaddr_slide;
        }
    }
    return 0;
}

@implementation YCILogCrashManager

#pragma mark - ------- Singleton
+ (instancetype)sharedInstance{
    
    static YCILogCrashManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (NSString *)startPLCrashReporter{
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    NSError *err;
    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport]) {
        return [self handleCrashReport];
    }
    // Enable the Crash Reporter
    if (![crashReporter enableCrashReporterAndReturnError: &err]) {
        NSLog(@"Warning: Could not enable crash reporter: %@", err);
    }
    
    return nil;
}

- (NSString *)handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return nil;
    }
    
    // We could send the report from here, but we'll just print out some debugging info instead
    PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
    if (report == nil) {
        NSLog(@"Could not parse crash report");
        [crashReporter purgePendingCrashReport];
        return nil;
    }
    
    // send the report
    NSString *time = [NSString stringWithFormat:@"Crashed on %@", report.systemInfo.timestamp];
    NSString *info = [NSString stringWithFormat:@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address];
    NSString *humanReadText = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
    
    intptr_t slide = calculateSlideAddress();
    NSString *slideAddress = [NSString stringWithFormat:@"Slide Address: 0x%lx", slide];
    
    NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", time, info, humanReadText, slideAddress];
    
    return content;
    
}

- (void)uploadCrashReportSuccess{
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    [crashReporter purgePendingCrashReport];
}




@end


