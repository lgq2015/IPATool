//
//  NSFileManager+IPATool.m
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSFileManager+IPATool.h"

@implementation NSFileManager (IPATool)

- (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath autoCover:(BOOL)autoCover {
	[self removeItemAtPath:dstPath error:nil];
	return [self moveItemAtPath:srcPath toPath:dstPath error:nil];
}

- (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath autoCover:(BOOL)autoCover {
	[self removeItemAtPath:dstPath error:nil];
	return [self copyItemAtPath:srcPath toPath:dstPath error:nil];
}

@end
