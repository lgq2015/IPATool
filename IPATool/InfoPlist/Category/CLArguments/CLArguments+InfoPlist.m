//
//  CLArguments+InfoPlist.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+InfoPlist.h"
#import "InfoPlist.h"

@implementation CLArguments (InfoPlist)

- (void)initInfoPlist {
	[self ip_initCommand_get];
	[self ip_initCommand_set];
}

- (void)ip_initCommand_get {
	NSString *command = @"info-get";
	[self setCommand:command explain:@"Get a value for key in info.plist"];
	[self setKey:CLK_InfoPlist_Input abbr:@"i" optional:NO example:@"/path/to/file" explain:@"You can type one of: Payload/*.app/info.plist" forCommand:command];
	[self setKey:CLK_InfoPlist_Key abbr:@"k" optional:NO example:@"CFBundleIdentifier or CFBundleIcons/CFBundlePrimaryIcon" explain:@"The key in info.plist." forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		id res = [InfoPlist get:arguments];
		if ([res isKindOfClass:[NSError class]]) {
			NSError *error = res;
			[error ipa_println];
			return error;
		}
		
		NSString *string = res;
		printf("%s\n", string.UTF8String);
		return nil;
	}];
}

- (void)ip_initCommand_set {
	NSString *command = @"info-set";
	[self setCommand:command explain:@"Set a value for key in info.plist"];
	[self setKey:CLK_InfoPlist_Input abbr:@"i" optional:NO example:@"/path/to/file" explain:@"You can type one of: Payload/*.app/info.plist" forCommand:command];
	[self setKey:CLK_InfoPlist_Key abbr:@"k" optional:NO example:@"CFBundleIdentifier or CFBundleIcons/CFBundlePrimaryIcon" explain:@"The key in info.plist." forCommand:command];
	[self setKey:CLK_InfoPlist_Object abbr:@"o" optional:YES example:@"com.unique.xxx" explain:@"The new value" forCommand:command];
	[self setOptionalKey:CLK_InfoPlist_Type abbr:@"t" defaultValue:@"string" example:@"a type" explain:@"One of \"string/number/bool/dictionary/array\"" forCommand:command];
	[self setFlag:CLK_InfoPlist_Plugin abbr:@"p" explain:@"Auto changing the value's prefix matched in plugin, If you change the bundle identifier, you should type it to change plugin's bundle identifier prefix, otherwise the app will be invalid after code sign." forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		id res = [InfoPlist set:arguments];
		if ([res isKindOfClass:[NSError class]]) {
			NSError *error = res;
			[error ipa_println];
			return error;
		}
		
		printf("Set value success!\n");
		return nil;
	}];
}

@end
