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

- (instancetype)initWithMUPath:(MUPath *)path {
	NSArray *componments = path.componments;
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
	return self.path.lastPathComponent;
}

- (NSString *)pathExtension {
	return self.path.pathExtension;
}

- (NSArray<MUPath *> *)contentPathes {
	if (self.isFolder) {
		NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil];
		if (contents) {
			NSMutableArray *paths = [NSMutableArray arrayWithCapacity:contents.count];
			for (NSString *componment in contents) {
				MUPath *item = [self pathWithAppendingComponment:componment];
				[paths addObject:item];
			}
			contents = [paths copy];
		}
		return contents;
	}
	return nil;
}

- (NSArray<NSString *> *)contentComponments {
	if (self.isFolder) {
		NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil];
		return contents;
	}
	return nil;
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

- (BOOL)isExist {
	return [[NSFileManager defaultManager] fileExistsAtPath:self.path];
}

- (BOOL)isFolder {
	BOOL isFolder = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:&isFolder]) {
		if (isFolder) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)containsSubpath:(NSString *)subpath {
	if (!self.isFolder) {
		return NO;
	}
	NSString *path = [self.path stringByAppendingPathComponent:subpath];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (instancetype)pathWithAppendingComponment:(NSString *)componment {
	NSString *path = [self.path stringByAppendingPathComponent:componment];
	return [[[self class] alloc] initWithPath:path];
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
