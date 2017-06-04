//
//  NSString+IPATool.m
//  IPATool
//
//  Created by 吴双 on 2017/6/3.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSString+IPATool.h"

@implementation NSString (IPATool)

- (BOOL)isIPA {
	NSString *payload = [self stringByAppendingPathComponent:@"Payload"];
	return [[NSFileManager defaultManager] fileExistsAtPath:payload];
}

- (BOOL)isPayload {
	return [self.lastPathComponent isEqualToString:@"Payload"];
}

- (BOOL)isApp {
	return [self.pathExtension isEqualToString:@"app"];
}

- (BOOL)isMobileProvision {
	return [self.pathExtension isEqualToString:@"mobileprovision"];
}

- (BOOL)isInfoPlist {
	return [self.lastPathComponent isEqualToString:@"Info.plist"];
}

@end
