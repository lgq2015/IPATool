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
#import "ITInfoPlist.h"

@interface InfoPlistEditor ()

@property (nonatomic, strong, readonly) InfoPlistBuddy *buddy;

@property (nonatomic, strong, readonly) InfoPlistReader *reader;

@end

@implementation InfoPlistEditor

- (instancetype)initWithInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key value:(NSString *)value type:(NSString *)type {
	self = [super init];
	if (self) {
		_infoPlist = infoPlist;
		_key = [key copy];
		_value = [value copy];
		_type = [type copy];
		
		_buddy = [InfoPlistBuddy setBuddyWithPath:infoPlist.path key:key value:value type:type];
		_reader = [InfoPlistReader readerWithInfoPlist:infoPlist key:key];
	}
	return self;
	
}

+ (instancetype)editorWithInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key value:(NSString *)value type:(NSString *)type {
	return [[self alloc] initWithInfoPlist:infoPlist key:key value:value type:type];
}

- (NSError *)edit {
	id res = [self.reader read];
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	}
	
//	NSString *orig = res;
	
	InfoPlistBuddy *buddy = self.buddy;
	if (buddy.error) {
		return buddy.error;
	}
	res = buddy.taskResult;
	
//	if ([res isKindOfClass:[NSString class]] && [self.type isEqualToString:@"string"] && self.pluginEnable && self.app) {
//		//	TODO: Edit plugin's value with matched key. Use 'orig' var to match prefix and replace it by self.value
//		//	1. Enum all plugin
//		NSArray<ITPlugin *> *plugins = self.app.plugins;
//		
//		NSMutableDictionary *errors = [NSMutableDictionary dictionary];
//		
//		for (ITPlugin *plugin in plugins) {
//			ITInfoPlist *infoPlist = plugin.infoPlist;
//			NSString *infoPlistPath = infoPlist.path;
//			
//			//	2. Match prefix
//			InfoPlistBuddy *readBuddy = [InfoPlistBuddy getBuddyWithPath:infoPlistPath key:self.key];
//			if (readBuddy.error) {
//				errors[plugin.path] = readBuddy.error;
//				continue;
//			}
//			
//			id res = readBuddy.taskResult;
//			if ([res isKindOfClass:[NSError class]]) {
//				errors[plugin.path] = res;
//			}
//			
//			NSString *extensionValue = res;
//			//	3. Replace prefix by self.value
//			if ([extensionValue hasPrefix:orig]) {
//				extensionValue = [extensionValue stringByReplacingOccurrencesOfString:orig withString:self.value];
//			}
//			
//			InfoPlistBuddy *writeBuddy = [InfoPlistBuddy setBuddyWithPath:infoPlistPath key:self.key value:extensionValue type:self.type];
//			
//			if (writeBuddy.error) {
//				errors[plugin.path] = writeBuddy.error;
//				continue;
//			}
//			
//			res = writeBuddy.taskResult;
//			if ([res isKindOfClass:[NSError class]]) {
//				errors[plugin.path] = res;
//			}
//		}
//		
//		if (errors.count) {
//			res = errors.allValues.firstObject;
//		}
//	}
	
	return res;
}

@end
