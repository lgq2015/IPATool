//
//  ITInfoPlist.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITInfoPlist.h"
#import "ITApp.h"

@implementation ITInfoPlist

- (NSDictionary *)info {
	return [NSDictionary dictionaryWithContentsOfFile:self.path];
}

- (ITPlugin *)plugin {
	MUPath *path = self.superPath;
	if ([path.pathExtension isEqualToString:@"appex"]) {
		return [[ITPlugin alloc] initWithMUPath:path];
	}
	return nil;
}

- (ITApp *)app {
	MUPath *path = self.superPath;
	if ([path.pathExtension isEqualToString:@"app"]) {
		return [[ITApp alloc] initWithMUPath:path];
	}
	return self.plugin.app;
}

@end
