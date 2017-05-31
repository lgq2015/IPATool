//
//  InfoPlist.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "InfoPlist.h"
#import "CommandLine.h"
#import "InfoPlistBuddy.h"

@implementation InfoPlist

+ (id)get:(CLArguments *)arguments {
	InfoPlistBuddy *buddy = [InfoPlistBuddy buddyWithArguments:arguments];
	if (buddy.error) {
		return buddy.error;
	}
	id res = buddy.taskResult;
	return res;
}

+ (id)set:(CLArguments *)arguments {
	id res = [self get:arguments];
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	}
	
	NSString *orig = res;
	
	InfoPlistBuddy *buddy = [InfoPlistBuddy buddyWithArguments:arguments];
	if (buddy.error) {
		return buddy.error;
	}
	res = buddy.taskResult;
	return res;
}

@end
