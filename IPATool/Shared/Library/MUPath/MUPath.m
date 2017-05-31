//
//  MUPath.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUPath.h"
#import "CommandLine.h"

@implementation MUPath

- (instancetype)initWithPath:(NSString *)path {
	NSArray *componments = [path componentsSeparatedByString:@"/"];
	self = [self initWithComponments:componments];
	return self;
}

- (instancetype)initWithComponments:(NSArray<NSString *> *)componments {
	self = [super init];
	if (self) {
		_componments = componments;
	}
	return self;
}

+ (instancetype)tempPath {
	NSString *path = [NSString stringWithLaunchArguments:@[@"/usr/bin/mktemp", @"-d", @"-t", @"unique"]];
	MUPath *tempPath = [[self alloc] initWithPath:path];
	return tempPath;
}

- (NSString *)lastPathComponment {
	return self.componments.lastObject;
}

- (NSString *)path {
	if (_componments.count > 1) {
		return [self.componments componentsJoinedByString:@"/"];
	} else {
		return _componments.firstObject;
	}
	return nil;
}

- (MUPath *)superPath {
	if (self.componments.count) {
		NSMutableArray *componments = [NSMutableArray arrayWithArray:self.componments];
		[componments removeLastObject];
		MUPath *path = [[MUPath alloc] initWithComponments:componments];
		return path;
	} else {
		return nil;
	}
}

- (void)createDirectoryIfNeeds {
	
}

- (void)remove {
	BOOL res = [[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
	NSLog(@"BOOL res = %@", res ? @"YES" : @"NO");
}

- (NSString *)description {
	return self.path;
}

@end
