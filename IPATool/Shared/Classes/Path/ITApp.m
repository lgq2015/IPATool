//
//  ITApp.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITApp.h"
#import "ITPayload.h"

@interface ITApp ()
{
	ITInfoPlist *_infoPlist;
	ITBinary *_binary;
	ITMobileProvision *_mobileProvision;
	NSArray *_plugins;
}

@end

@implementation ITApp

+ (instancetype)appPathWithPath:(NSString *)path {
	if ([path.lastPathComponent isEqualToString:@"Payload"]) {
		return [[ITPayload alloc] initWithPath:path].app;
	}
	
	if ([path.pathExtension isEqualToString:@"app"]) {
		return [[ITApp alloc] initWithPath:path];
	}
	
	return nil;
}

- (ITMobileProvision *)mobileProvision {
	if (!_mobileProvision) {
		_mobileProvision = [[ITMobileProvision alloc] initWithPath:[self.path stringByAppendingPathComponent:@"embedded.mobileprovision"]];
	}
	return _mobileProvision;
}

- (NSArray<ITPlugin *> *)plugins {
	if (!_plugins) {
		NSArray *pluginPathes = [self pluginNamesWithFullPath:YES];
		if (pluginPathes) {
			NSMutableArray *plugins = [NSMutableArray arrayWithCapacity:pluginPathes.count];
			for (NSString *path in pluginPathes) {
				ITPlugin *plugin = [[ITPlugin alloc] initWithPath:path];
				[plugins addObject:plugin];
			}
			pluginPathes = [plugins copy];
		}
		_plugins = pluginPathes;
	}
	return _plugins;
}

- (NSArray *)pluginNamesWithFullPath:(BOOL)fullPath {
	MUPath *pluginPath = [self pathByAppendingComponment:@"PlugIns"];
	NSArray *contents = [pluginPath contentComponments];
	if (!contents) {
		return nil;
	}
	
	if (fullPath) {
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:contents.count];
		NSString *path = pluginPath.path;
		for (NSString *componment in contents) {
			NSString *pluginItem = [path stringByAppendingPathComponent:componment];
			[array addObject:pluginItem];
		}
		contents = [array copy];
	}
	return contents;
}

@end
