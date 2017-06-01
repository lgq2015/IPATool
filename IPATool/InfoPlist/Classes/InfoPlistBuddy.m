//
//  InfoPlistBuddy.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "InfoPlistBuddy.h"
#import "CommandLine.h"
#import "CLArguments+InfoPlist.h"
#import "NSError+InfoPlist.h"

static id IPGetInfoPlistPathInPath(NSString *path) {
	NSFileManager *fmgr = [NSFileManager defaultManager];
	if ([path.lastPathComponent isEqualToString:@"Payload"]) {
		NSArray *sub = [fmgr contentsOfDirectoryAtPath:path error:nil];
		if (sub.count == 0) {
			return [NSError ip_errorWithCode:IPErrorCodeNotFoundInfoPlist description:@"No .app package in Payload."];
		}
		else {
			NSUInteger count = 0;
			NSString *appName = nil;
			for (NSString *name in sub) {
				count += [name.pathExtension isEqualToString:@"app"] ? 1 : 0;
				appName = [name.pathExtension isEqualToString:@"app"] ? name : appName;
			}
			
			if (count > 1) {
				return [NSError ip_errorWithCode:IPErrorCodeNotFoundInfoPlist description:@"More then 1 .app file in Payload."];
			}
			
			else {
				path = [path stringByAppendingPathComponent:appName];
			}
		}
	}
	
	if ([path.pathExtension isEqualToString:@"app"]) {
		path = [path stringByAppendingPathComponent:@"Info.plist"];
	}
	
	if (![path.lastPathComponent isEqualToString:@"Info.plist"]) {
		return [NSError ip_errorWithCode:IPErrorCodeNotFoundInfoPlist description:@"Can not find info.plist for this directory."];
	}
	
	return path;
}

@implementation InfoPlistBuddy

- (instancetype)initWithPath:(NSString *)path format:(NSString *)format key:(NSString *)key type:(NSString *)type value:(NSString *)value {
	self = [super init];
	if (self) {
		_key = [key copy];
		if (![_key hasPrefix:@":"]) {
			_key = [@":" stringByAppendingString:_key];
		}
		
		_format = [format copy];
		
		_type = [type copy];
		
		_value = [value copy];
		
		id res = IPGetInfoPlistPathInPath(path);
		if ([res isKindOfClass:[NSError class]]) {
			_error = res;
		} else {
			_path = res;
		}
	}
	return self;
}

- (instancetype)initWithArguments:(CLArguments *)arguments {
	NSString *key = [arguments stringValueForKey:CLK_InfoPlist_Key];
	
	NSString *format = @{@"info-set": @"Set",
						 @"info-get": @"Print",
						 @"info-add": @"Add",
						 @"info-del": @"Delete"}[arguments.command];
	
	NSString *type = @{@"string":@"string",
					   @"array":@"array",
					   @"dict":@"dict",
					   @"dictionary":@"dict",
					   @"number":@"integer",
					   @"bool":@"bool"}[[arguments stringValueForKey:CLK_InfoPlist_Type]];
	
	NSString *value = [arguments stringValueForKey:CLK_InfoPlist_Object];
	
	NSString *path = [arguments stringValueForKey:CLK_InfoPlist_Input];


	self = [self initWithPath:path format:format key:key type:type value:value];
	return self;
}

+ (instancetype)buddyWithArguments:(CLArguments *)arguments {
	return [[self alloc] initWithArguments:arguments];
}

+ (instancetype)getBuddyWithPath:(NSString *)path key:(NSString *)key {
	return [[self alloc] initWithPath:path format:@"Print" key:key type:nil value:nil];
}

+ (instancetype)setBuddyWithPath:(NSString *)path key:(NSString *)key value:(NSString *)value type:(NSString *)type {
	return [[self alloc] initWithPath:path format:@"Set" key:key type:type value:value];
}

- (NSString *)command {
	if ([self.format isEqualToString:@"Print"]) {
		return [NSString stringWithFormat:@"%@ %@", self.format, self.key];
	}
	else if ([self.format isEqualToString:@"Set"]) {
		return [NSString stringWithFormat:@"%@ %@ %@", self.format, self.key, self.value];
	}
	else if ([self.format isEqualToString:@"Add"]) {
		if ([self.type isEqualToString:@"array"] || [self.type isEqualToString:@"dict"]) {
			return [NSString stringWithFormat:@"%@ %@ %@", self.format, self.key, self.type];
		} else {
			return [NSString stringWithFormat:@"%@ %@ %@", self.format, self.key, self.value];
		}
	}
	else {
		return nil;
	}
}

- (NSArray *)taskArguments {
	return @[@"/usr/libexec/PlistBuddy", @"-c", self.command, self.path];
}

- (id)taskResult {
	if (self.error) {
		return self.error;
	} else {
		id res = CLLaunchWithArguments(self.taskArguments);
		return res;
	}
}

@end
