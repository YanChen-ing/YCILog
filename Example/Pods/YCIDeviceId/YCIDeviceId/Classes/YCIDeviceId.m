//
//  YCIDeviceId.m
//
//
//

#import "YCIDeviceId.h"
#import "UICKeyChainStore.h"

static NSString *const DEVICE_ID_KEY = @"yci.deviceId";

@implementation YCIDeviceId

+ (NSString *)get {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuidUserDefaults = [defaults objectForKey:DEVICE_ID_KEY];
    
    NSString *uuid = [UICKeyChainStore stringForKey:DEVICE_ID_KEY];
    
    if ( uuid && !uuidUserDefaults) {
        [defaults setObject:uuid forKey:DEVICE_ID_KEY];
        [defaults synchronize];
        
    }  else if ( !uuid && !uuidUserDefaults ) {
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        
        [UICKeyChainStore setString:uuidString forKey:DEVICE_ID_KEY];
        
        [defaults setObject:uuidString forKey:DEVICE_ID_KEY];
        [defaults synchronize];
        
        uuid = [UICKeyChainStore stringForKey:DEVICE_ID_KEY];
        
    } else if ( ![uuid isEqualToString:uuidUserDefaults] ) {
        [UICKeyChainStore setString:uuidUserDefaults forKey:DEVICE_ID_KEY];
        uuid = [UICKeyChainStore stringForKey:DEVICE_ID_KEY];
    }
    
    return uuid;
}

@end

