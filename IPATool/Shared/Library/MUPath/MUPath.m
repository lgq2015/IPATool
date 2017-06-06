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
	NSArray *components = [path componentsSeparatedByString:@"/"];
	self = [self initWithComponents:components];
	return self;
}

- (instancetype)initWithMUPath:(MUPath *)path {
	NSArray *components = path.components;
	self = [self initWithComponents:components];
	return self;
}

- (instancetype)initWithComponents:(NSArray<NSString *> *)components {
	self = [super init];
	if (self) {
		_components = components;
	}
	return self;
}

+ (instancetype)tempPath {
	NSString *path = [NSString stringWithLaunchArguments:@[@"/usr/bin/mktemp", @"-d", @"-t", @"unique"]];
	MUPath *tempPath = [[self alloc] initWithPath:path];
	return tempPath;
}

- (NSString *)lastPathComponent {
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
			for (NSString *component in contents) {
				MUPath *item = [self pathByAppendingComponent:component];
				[paths addObject:item];
			}
			contents = [paths copy];
		}
		return contents;
	}
	return nil;
}

- (NSArray<NSString *> *)contentComponents {
	if (self.isFolder) {
		NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil];
		return contents;
	}
	return nil;
}

- (NSString *)path {
	if (_components.count > 1) {
		return [self.components componentsJoinedByString:@"/"];
	} else {
		return _components.firstObject;
	}
	return nil;
}

- (instancetype)superPath {
	if (self.components.count) {
		NSMutableArray *components = [NSMutableArray arrayWithArray:self.components];
		[components removeLastObject];
		MUPath *path = [[MUPath alloc] initWithComponents:components];
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

- (BOOL)isFile {
	BOOL isFolder = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:&isFolder]) {
		if (!isFolder) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)is:(NSString *)fileName {
	return [self.lastPathComponent.lowercaseString isEqualToString:fileName.lowercaseString];
}

- (BOOL)isA:(NSString *)pathExtension {
	return [self.pathExtension.lowercaseString isEqualToString:pathExtension.lowercaseString];
}

- (BOOL)containsSubpath:(NSString *)subpath {
	if (!self.isFolder) {
		return NO;
	}
	NSString *path = [self.path stringByAppendingPathComponent:subpath];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (instancetype)pathByAppendingComponent:(NSString *)component {
	NSString *path = [self.path stringByAppendingPathComponent:component];
	return [[[self class] alloc] initWithPath:path];
}

- (instancetype)pathByReplacingLastPastComponent:(NSString *)component {
	return [self.superPath pathByAppendingComponent:component];
}

- (void)createDirectoryIfNeeds {
	NSFileManager *fmgr = [NSFileManager defaultManager];
	NSString *path = self.path;
	BOOL isDirectory = NO;
	if ([fmgr fileExistsAtPath:path isDirectory:&isDirectory]) {
		if (isDirectory) {
			return;
		}
		[fmgr removeItemAtPath:path error:nil];
	}
	[fmgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)remove {
	BOOL res = [[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
	NSLog(@"BOOL res = %@", res ? @"YES" : @"NO");
}

- (NSString *)description {
	return self.path;
}

@end
