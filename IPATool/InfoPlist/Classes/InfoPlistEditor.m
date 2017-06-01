//
//  InfoPlistEditor.m
//  IPATool
//
//  Created by 吴双 on 2017/6/1.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "InfoPlistEditor.h"
#import "CLArguments+InfoPlist.h"
#import "InfoPlistReader.h"
#import "InfoPlistBuddy.h"

@interface InfoPlistEditor ()

@property (nonatomic, strong, readonly) InfoPlistReader *reader;

@end

@implementation InfoPlistEditor

- (instancetype)initWithArguments:(CLArguments *)arguments {
	self = [super init];
	if (self) {
		_path = [arguments fullPathValueForKey:CLK_InfoPlist_Input];
		_key = [arguments stringValueForKey:CLK_InfoPlist_Key];
		_value = [arguments stringValueForKey:CLK_InfoPlist_Object];
		_type = [arguments stringValueForKey:CLK_InfoPlist_Type];
		_pluginEnable = [arguments hasFlags:CLK_InfoPlist_Plugin];
		_reader = [InfoPlistReader readerWithArguments:arguments];
	}
	return self;
}

+ (instancetype)editorWithArguments:(CLArguments *)arguments {
	return [[self alloc] initWithArguments:arguments];
}

- (NSError *)edit {
	id res = [self.reader read];
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	}
	
	NSString *orig = res;
	
	InfoPlistBuddy *buddy = [InfoPlistBuddy setBuddyWithPath:self.path key:self.key value:self.value type:self.type];
	if (buddy.error) {
		return buddy.error;
	}
	res = buddy.taskResult;
	
	if ([res isKindOfClass:[NSString class]]) {
		if (self.pluginEnable) {
			//	TODO: Edit plugin's value with matched key. Use 'orig' var to match prefix and replace it by self.value
			//	1. Enum all plugin
			//	2. Match prefix
			//	3. Replace prefix by self.value
			orig = nil;
		}
	}
	
	return res;
}

@end
