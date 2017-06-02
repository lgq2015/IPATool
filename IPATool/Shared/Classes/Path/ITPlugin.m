//
//  ITPlugin.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPlugin.h"
#import "ITApp.h"

@interface ITPlugin ()

@end

@implementation ITPlugin

- (ITApp *)app {
	MUPath *path = self.superPath.superPath;
	if ([path.pathExtension isEqualToString:@"app"]) {
		return [[ITApp alloc] initWithMUPath:path];
	}
	return nil;
}

- (ITPlugin *)plugins {
	return nil;
}

@end
