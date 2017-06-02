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

#import "ITApp.h"

@interface InfoPlistReader ()
{
	InfoPlistBuddy *_plistBuddy;
}

@property (nonatomic, strong, readonly) InfoPlistBuddy *plistBuddy;

@end

@implementation InfoPlistReader

- (instancetype)initWithArguments:(CLArguments *)arguments {
	self = [super init];
	if (self) {
		_plistBuddy = [InfoPlistBuddy buddyWithArguments:arguments];
	}
	return self;
}

+ (instancetype)readerWithArguments:(CLArguments *)arguments {
	return [[self alloc] initWithArguments:arguments];
}

- (instancetype)initWithPath:(NSString *)path key:(NSString *)key {
	self = [super init];
	if (self) {
		_plistBuddy = [InfoPlistBuddy getBuddyWithPath:path key:key];
	}
	return self;
}

+ (instancetype)readerWithPath:(NSString *)path key:(NSString *)key {
	return [[self alloc] initWithPath:path key:key];
}

- (NSString *)path {
	return self.plistBuddy.path;
}

- (NSString *)key {
	return self.plistBuddy.key;
}

- (id)read {
	InfoPlistBuddy *buddy = self.plistBuddy;
	if (buddy.error) {
		return buddy.error;
	}
	id res = buddy.taskResult;
	if ([res isKindOfClass:[NSString class]]) {
		ITApp *app = [ITPath packagePathWithPath:[self.path stringByDeletingLastPathComponent]].app;
		ITBinary *binary = app.binary;
		NSLog(@"%@", binary.loadedUserLibrary);
	}
	return res;
}

@end
