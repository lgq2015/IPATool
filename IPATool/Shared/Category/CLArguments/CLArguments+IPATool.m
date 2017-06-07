//
//  CLArguments+IPATool.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+IPATool.h"

#import "CLArguments+AppIcon.h"
#import "CLArguments+InfoPlist.h"
#import "CLArguments+CodeSign.h"
#import "CLArguments+ZipArchive.h"

#import "ITIPA.h"
#import "ITZip.h"

@implementation CLArguments (IPATool)

+ (instancetype)sharedInstance {
	static CLArguments *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] initWithRequireCommand:NO];
		[_sharedInstance initCommand];
		[_sharedInstance initMain];
	});
	return _sharedInstance;
}

- (void)initCommand {
	[self initAppIcon];
	[self initInfoPlist];
	[self initCodeSign];
	[self initZipArchive];
}

- (void)initMain {
	[self setCommand:nil explain:@"Operating a package, [--key -k value] input [output]"];
	[self setKey:@"certificate" abbr:@"c" optional:YES example:@"iPhone Developer: xxxx" explain:@"Optional, sign code if type in this key."];
	[self setKey:@"mobileprovision" abbr:@"m" optional:YES example:@"/path/to/.mobileprovision" explain:@"Optional, sign code and copy to .app if type in this key."];
	[self setKey:@"icon" abbr:@"i" optional:YES example:@"/path/to/image" explain:@"Optional, modify icon files in .app if type in this key."];
	[self setKey:@"bid" abbr:nil optional:YES example:@"com.unique.xxx" explain:@"Optional, modify CFBundleIdentifier in .app and all plugin if type in this key."];
	[self setCommand:nil task:^NSError *(CLArguments *arguments) {
		NSString *input = [arguments fullIOPathAtIndex:0];
		NSString *output = [arguments fullIOPathAtIndex:1];
		
		output = output.length > 0 ? output : input;
		
		ITPath *inputPath = [[ITPath alloc] initWithPath:input];
		ITPath *outputPath = [[ITPath alloc] initWithPath:output];
		
		ITApp *app = [arguments main_makeApp];
		[arguments main_opreaApp:app];
		[arguments main_package:inputPath to:outputPath];
		return nil;
	}];
}

- (ITApp *)main_makeApp {
	return nil;
}

- (void)main_opreaApp:(ITApp *)app {
	
}

- (IPAResult *)main_package:(ITPath *)in to:(ITPath *)to {
	return IPASucceed(nil);
}

@end
