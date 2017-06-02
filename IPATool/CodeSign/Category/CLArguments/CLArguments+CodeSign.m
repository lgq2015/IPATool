//
//  CLArguments+CodeSign.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+CodeSign.h"
#import "CodeSign.h"
#import "CSTask.h"

@implementation CLArguments (CodeSign)

- (void)initCodeSign {
	[self cs_initCommand_CodeSign];
}

- (void)cs_initCommand_CodeSign {
	NSString *command = @"code-sign";
	[self setCommand:command explain:@"Code sign a binary file or a package."];
	[self setKey:CLK_CodeSign_Certificate abbr:@"c" optional:NO example:@"iPhone Developer: xxx" explain:@"Sign with this certificate." forCommand:command];
	[self setKey:CLK_CodeSign_MobileProvision abbr:@"m" optional:NO example:@"/path/to/.mobileprovision" explain:@"Mobile provision file" forCommand:command];
	[self setKey:CLK_CodeSign_Input abbr:@"i" optional:NO example:@"/path/to/file" explain:@"Should signed file or directory." forCommand:command];
	[self setKey:CLK_CodeSign_Entitlements abbr:@"e" optional:YES example:@"/path/to/entitlements.plist" explain:@"Entitlements file." forCommand:command];
	[self setFlag:CLK_CodeSign_Plugin abbr:@"p" explain:@"Auto sign plugin in input package" forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		id res = [CodeSign signWithArguments:arguments];
		if ([res isKindOfClass:[NSError class]]) {
			NSError *error = res;
			[error ipa_println];
			return error;
		} else {
			printf("Sign %s succeed!\n", [arguments fullPathValueForKey:CLK_CodeSign_Input].UTF8String);
			return nil;
		}
	}];
}

@end
