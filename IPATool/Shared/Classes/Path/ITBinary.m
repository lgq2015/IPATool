//
//  ITBinary.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITBinary.h"
#import "CommandLine.h"
#import "NSArray+IPATool.h"

@implementation ITBinary

- (instancetype)initWithPath:(NSString *)path {
	self = [super initWithPath:path];
	if (self) {
		_executableBinary = self;
		_loadingBinary = self;
	}
	return self;
}

- (instancetype)initWithMUPath:(MUPath *)path {
	self = [super initWithMUPath:path];
	if (self) {
		_executableBinary = self;
		_loadingBinary = self;
	}
	return self;
}

- (instancetype)initWithComponments:(NSArray<NSString *> *)componments {
	self = [super initWithComponments:componments];
	if (self) {
		_executableBinary = self;
		_loadingBinary = self;
	}
	return self;
}

- (instancetype)initWithPath:(NSString *)path executableBinary:(ITBinary *)executableBinary loadingBinary:(ITBinary *)loadingBinary {
	self = [super initWithPath:path];
	if (self) {
		_executableBinary = executableBinary;
		_loadingBinary = loadingBinary;
	}
	return self;
}

- (NSArray<ITBinary *> *)loadedUserLibrary {
	id res = CLLaunchWithArguments(@[@"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/otool", @"-L", self.path]);
	if ([res isKindOfClass:[NSError class]]) {
		return nil;
	}
	NSString *logout = res;
	NSRegularExpression *dylibRegular = [NSRegularExpression regularExpressionWithPattern:@"\\t@.* \\(.*\\)"
																			 options:1 error:nil];
	
	NSRegularExpression *versionRegular = [NSRegularExpression regularExpressionWithPattern:@" \\(compatibility version .*, current version .*\\)"
																					options:1 error:nil];
	
	NSMutableArray *librarys = [NSMutableArray array];
	MUPath *executablePath = self.executableBinary.superPath;
	MUPath *loaderPath = self.loadingBinary.superPath;
	
	for (NSTextCheckingResult *result in [dylibRegular matchesInString:res options:1 range:NSMakeRange(0, logout.length)]) {
		NSString *matched = [logout substringWithRange:result.range];
		matched = [matched substringFromIndex:1];
		NSRange versionRange = [versionRegular firstMatchInString:matched options:1 range:NSMakeRange(0, matched.length)].range;
		matched = [matched stringByReplacingCharactersInRange:versionRange withString:@""];
		if ([matched hasPrefix:@"@executable_path"]) {
			matched = [matched stringByReplacingOccurrencesOfString:@"@executable_path" withString:executablePath.path];
		}
		if ([matched hasPrefix:@"@loader_path"]) {
			matched = [matched stringByReplacingOccurrencesOfString:@"@loader_path" withString:loaderPath.path];
		}
		[librarys addObject:matched];
	}
	
	librarys = [librarys arrayWithRemoveEqualObject];
	
	for (int i = 0; i < librarys.count; i++) {
		librarys[i] = [[self.class alloc] initWithPath:librarys[i] executableBinary:self.executableBinary loadingBinary:self];
	}
	return librarys;
}

- (NSArray<ITBinary *> *)loadedSystemLibrary {
	id res = CLLaunchWithArguments(@[@"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/otool", @"-L", self.path]);
	if ([res isKindOfClass:[NSError class]]) {
		return nil;
	}
	NSString *logout = res;
	NSRegularExpression *dylibRegular = [NSRegularExpression regularExpressionWithPattern:@"\\t/.* \\(.*\\)"
																				  options:1 error:nil];
	
	NSRegularExpression *versionRegular = [NSRegularExpression regularExpressionWithPattern:@" \\(compatibility version .*, current version .*\\)"
																					options:1 error:nil];
	
	for (NSTextCheckingResult *result in [dylibRegular matchesInString:res options:1 range:NSMakeRange(0, logout.length)]) {
		NSString *matched = [logout substringWithRange:result.range];
		matched = [matched substringFromIndex:1];
		NSRange versionRange = [versionRegular firstMatchInString:matched options:1 range:NSMakeRange(0, matched.length)].range;
		matched = [matched stringByReplacingCharactersInRange:versionRange withString:@""];
		printf("%s\n", matched.UTF8String);
	}
	return nil;
}

@end
