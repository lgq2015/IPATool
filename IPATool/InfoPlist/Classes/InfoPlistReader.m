//
//  InfoPlistReader.m
//  IPATool
//
//  Created by 吴双 on 2017/6/1.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "InfoPlistReader.h"
#import "CLArguments+InfoPlist.h"
#import "InfoPlistBuddy.h"

#import "ITInfoPlist.h"

@interface InfoPlistReader ()
{
	InfoPlistBuddy *_plistBuddy;
}

@property (nonatomic, strong, readonly) InfoPlistBuddy *plistBuddy;

@end

@implementation InfoPlistReader

- (instancetype)initWithInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key {
	self = [super init];
	if (self) {
		_infoPlist = infoPlist;
		_key = [key copy];
	}
	return self;
}

+ (instancetype)readerWithInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key {
	return [[self alloc] initWithInfoPlist:infoPlist key:key];
}

- (id)read {
	InfoPlistBuddy *buddy = self.plistBuddy;
	if (buddy.error) {
		return buddy.error;
	}
	id res = buddy.taskResult;
	return res;
}

- (InfoPlistBuddy *)plistBuddy {
	if (!_plistBuddy) {
		_plistBuddy = [InfoPlistBuddy getBuddyWithPath:self.plistBuddy.path key:self.key];
	}
	return _plistBuddy;
}

@end
