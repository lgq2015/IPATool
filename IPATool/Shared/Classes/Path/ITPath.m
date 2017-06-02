//
//  ITPath.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPath.h"

#import "ITIPA.h"
#import "ITPayload.h"
#import "ITApp.h"
#import "ITPlugin.h"

@implementation ITPath

- (ITApp *)app {
	return nil;
}

+ (instancetype)packagePathWithPath:(NSString *)path {
	MUPath *obj = [[MUPath alloc] initWithPath:path];
	
	if ([obj.lastPathComponment isEqualToString:@"Payload"]) {
		return [[ITPayload alloc] initWithPath:path];
	}
	
	if ([obj.pathExtension isEqualToString:@"app"]) {
		return [[ITApp alloc] initWithPath:path];
	}
	
	if ([obj.pathExtension isEqualToString:@"appex"]) {
		return [[ITPlugin alloc] initWithPath:path];
	}
	
	if ([obj containsSubpath:@"Payload"]) {
		return [[ITIPA alloc] initWithPath:path];
	}
	
	return nil;
}

@end
