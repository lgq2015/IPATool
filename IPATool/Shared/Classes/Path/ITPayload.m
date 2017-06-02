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
		NSArray *list = [self contentComponments];
		NSString *path = nil;
		for (NSString *componment in list) {
			if ([componment.pathExtension isEqualToString:@"app"]) {
				path = componment;
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
