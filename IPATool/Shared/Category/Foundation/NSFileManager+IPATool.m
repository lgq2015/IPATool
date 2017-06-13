//
//  NSFileManager+IPATool.m
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSFileManager+IPATool.h"

#define IFErrorReturn if (error) return error;

@implementation NSFileManager (IPATool)

- (NSError *)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath autoCover:(BOOL)autoCover {
	NSError *error = nil;
	if ([self fileExistsAtPath:dstPath]) {
		[self removeItemAtPath:dstPath error:&error];
		IFErrorReturn;
	}
	[self moveItemAtPath:srcPath toPath:dstPath error:&error];
	return error;
}

- (NSError *)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath autoCover:(BOOL)autoCover {
	NSError *error = nil;
	if ([self fileExistsAtPath:dstPath]) {
		[self removeItemAtPath:dstPath error:&error];
		IFErrorReturn;
	}
	[self copyItemAtPath:srcPath toPath:dstPath error:&error];
	return error;
}

@end
