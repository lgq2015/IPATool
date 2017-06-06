//
//  ITPayload.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPayload.h"

@interface ITPayload ()
{
	ITApp *_app;
}

@end

@implementation ITPayload

- (ITApp *)app {
	if (!_app) {
		NSArray *list = [self contentComponents];
		NSString *path = nil;
		for (NSString *component in list) {
			if ([component.pathExtension isEqualToString:@"app"]) {
				path = component;
				break;
			}
		}
		if (path) {
			path = [self.path stringByAppendingPathComponent:path];
			_app = [[ITApp alloc] initWithPath:path];
		}
	}
	return _app;
}

@end
