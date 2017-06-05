//
//  IPAResult.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/5.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "IPAResult.h"

@implementation IPAResult

+ (instancetype)succeed:(NSString *)output {
	IPAResult *result = [IPAResult new];
	result->_output = [output copy];
	return result;
}

+ (instancetype)failed:(NSError *)error {
	IPAResult *result = [IPAResult new];
	result->_error = error;
	return result;
}

- (BOOL)isSucceed {
	return self.error == nil;
}

- (BOOL)isFailed {
	return self.error != nil;
}

- (void)println {
	if (self.isSucceed) {
		printf("%s\n", self.output.UTF8String);
	} else {
		printf("%s\n", self.error.localizedDescription.UTF8String);
	}
}

@end

IPAResult *IPAFailed(NSError *error) {
	return [IPAResult failed:error];
}

IPAResult *IPASucceed(NSString *output) {
	return [IPAResult succeed:output];
}

IPAResult *IPAReturn(id result) {
	if ([result isKindOfClass:[IPAResult class]]) {
		return result;
	}
	else if ([result isKindOfClass:[NSError class]]) {
		return IPAFailed(result);
	}
	else {
		return IPASucceed(result);
	}
}
