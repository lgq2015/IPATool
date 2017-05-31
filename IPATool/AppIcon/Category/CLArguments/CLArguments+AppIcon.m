//
//  CLArguments+AppIcon.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+AppIcon.h"
#import "AppIcon.h"
#import "NSError+IPATool.h"

#define FileExist(file) [[NSFileManager defaultManager] fileExistsAtPath:file]

@implementation CLArguments (AppIcon)

- (void)initAppIcon {
	[self ai_initCommand_get];
	[self ai_initCommand_set];
}

- (void)ai_initCommand_get {
	NSString *command = @"icon-get";
	[self setCommand:command explain:@"Get all name for icon file from a folder named: *.app"];
	[self setKey:CLK_AppIcon_AppPath abbr:@"a" optional:NO example:@"/path/to/.app" explain:@"A path to a .app package." forCommand:command];
	[self setKey:CLK_AppIcon_Device abbr:@"d" optional:YES example:@"One of all(default)/iPhone/iPad" explain:@"Match the icon for this device." forCommand:command];
	[self setKey:CLK_AppIcon_Scale abbr:@"s" optional:YES example:@"N of 1/2/3 or all(default)" explain:@"Match the icon for this screen scale. If you want to Match two scale like \"All Retina\", you can input 23 for 2 scale and 3 scale." forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		id res = [AppIcon get:arguments];
		if ([res isKindOfClass:[NSArray class]]) {
			NSArray *icons = res;
			for (NSString *file in icons) {
				printf("%s\n", file.UTF8String);
			}
			return nil;
		}
		else if ([res isKindOfClass:[NSError class]]) {
			NSError *error = res;
			printf("%s\n", error.localizedDescription.UTF8String);
			return error;
		}
		return nil;
	}];
}

- (void)ai_initCommand_set {
	NSString *command = @"icon-set";
	[self setCommand:command explain:@"Set a new icon to the package."];
	[self setKey:CLK_AppIcon_AppPath abbr:@"a" optional:NO example:@"/path/to/.app" explain:@"A path to a .app package." forCommand:command];
	[self setKey:CLK_AppIcon_Device abbr:@"d" optional:YES example:@"One of all(default)/iPhone/iPad" explain:@"Match the icon for this device." forCommand:command];
	[self setKey:CLK_AppIcon_Scale abbr:@"s" optional:YES example:@"N of 1/2/3 or all(default)" explain:@"Match the icon for this screen scale. If you want to Match two scale like \"All Retina\", you can input 23 for 2 scale and 3 scale." forCommand:command];
	[self setKey:CLK_AppIcon_Icon abbr:@"i" optional:NO example:@"/path/to/icon.png" explain:@"A path to a .png file." forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		id res = [AppIcon set:arguments willSet:^(NSString *iconName) {
			CLVerbose(arguments, "Set Icon: %s\n", iconName.UTF8String);
		} didSet:nil];
		if ([res isKindOfClass:[NSError class]]) {
			NSError *error = res;
			[error ipa_println];
			return error;
		}
		else if ([res isKindOfClass:[NSArray class]]) {
			NSArray *list = res;
			printf("Done! Change %lu icon files.\n", list.count);
			return nil;
		}
		return nil;
	}];
}

@end
