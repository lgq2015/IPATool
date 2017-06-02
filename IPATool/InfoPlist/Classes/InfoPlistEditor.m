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
#import "ITPath.h"
#import "ITApp.h"
#import "ITPlugin.h"

@interface InfoPlistEditor ()

@property (nonatomic, strong, readonly) InfoPlistReader *reader;

@property (nonatomic, strong, readonly) ITApp *app;

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
		_reader = [InfoPlistReader readerWithPath:_path key:_key];
		_app = [ITPath packagePathWithPath:_path].app;
	}
	return self;
}

+ (instancetype)editorWithArguments:(CLArguments *)arguments {
	return [[self alloc] initWithArguments:arguments];
}

- (instancetype)initWithPath:(NSString *)path key:(NSString *)key value:(NSString *)value type:(NSString *)type pluginEnable:(BOOL)pluginEnable {
	self = [super init];
	if (self) {
		_path = path;
		_key = key;
		_value = value;
		_type = type;
		_pluginEnable = pluginEnable;
	}
	return self;
}

+ (instancetype)editorWIthPath:(NSString *)path key:(NSString *)key value:(NSString *)value type:(NSString *)type pluginEnable:(BOOL)pluginEnable {
	return [[self alloc] initWithPath:path key:key value:value type:type pluginEnable:pluginEnable];
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
	
	if ([res isKindOfClass:[NSString class]] && [self.type isEqualToString:@"string"] && self.pluginEnable && self.app) {
		//	TODO: Edit plugin's value with matched key. Use 'orig' var to match prefix and replace it by self.value
		//	1. Enum all plugin
		NSArray<ITPlugin *> *plugins = self.app.plugins;
		
		NSMutableDictionary *errors = [NSMutableDictionary dictionary];
		
		for (ITPlugin *plugin in plugins) {
			ITInfoPlist *infoPlist = plugin.infoPlist;
			NSString *infoPlistPath = infoPlist.path;
			
			//	2. Match prefix
			InfoPlistBuddy *readBuddy = [InfoPlistBuddy getBuddyWithPath:infoPlistPath key:self.key];
			if (readBuddy.error) {
				errors[plugin.path] = readBuddy.error;
				continue;
			}
			
			id res = readBuddy.taskResult;
			if ([res isKindOfClass:[NSError class]]) {
				errors[plugin.path] = res;
			}
			
			NSString *extensionValue = res;
			//	3. Replace prefix by self.value
			if ([extensionValue hasPrefix:orig]) {
				extensionValue = [extensionValue stringByReplacingOccurrencesOfString:orig withString:self.value];
			}
			
			InfoPlistBuddy *writeBuddy = [InfoPlistBuddy setBuddyWithPath:infoPlistPath key:self.key value:extensionValue type:self.type];
			
			if (writeBuddy.error) {
				errors[plugin.path] = writeBuddy.error;
				continue;
			}
			
			res = writeBuddy.taskResult;
			if ([res isKindOfClass:[NSError class]]) {
				errors[plugin.path] = res;
			}
		}
		
		if (errors.count) {
			res = errors.allValues.firstObject;
		}
	}
	
	return res;
}

@end
