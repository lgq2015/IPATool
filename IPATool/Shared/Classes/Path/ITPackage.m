//
//  ITPackage.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPackage.h"

@interface ITPackage ()
{
	ITInfoPlist *_infoPlist;
	ITBinary *_binary;
}

@end

@implementation ITPackage

- (ITInfoPlist *)infoPlist {
	if (!_infoPlist) {
		_infoPlist = [[ITInfoPlist alloc] initWithPath:[self.path stringByAppendingPathComponent:@"Info.plist"]];
	}
	return _infoPlist;
}

- (ITBinary *)binary {
	if (!_binary) {
		NSDictionary *info = self.infoPlist.info;
		NSString *name = info[@"CFBundleExecutable"];
		_binary = [[ITBinary alloc] initWithPath:[self.path stringByAppendingPathComponent:name]];
	}
	return _binary;
}

@end
