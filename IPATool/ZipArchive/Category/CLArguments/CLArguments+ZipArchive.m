//
//  CLArguments+ZipArchive.m
//  IPATool
//
//  Created by 吴双 on 2017/6/3.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+ZipArchive.h"

#import "NSString+IPATool.h"
#import "ITPath.h"
#import "ZipArchive.h"

@implementation CLArguments (ZipArchive)

- (void)initZipArchive {
	[self za_initCommand_zip];
	[self za_initCommand_unzip];
}

- (void)za_initCommand_zip {
	NSString *command = @"zip";
	[self setCommand:command explain:@"Package an app."];
	[self setKey:CLK_ZipArchive_Input abbr:@"i" optional:NO example:@"/path/to/file" explain:@"A file path to operate." forCommand:command];
	[self setKey:CLK_ZipArchive_Output abbr:@"o" optional:YES example:@"/path/to/file" explain:@"Output path." forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		NSString *input = [arguments fullPathValueForKey:CLK_ZipArchive_Input];
		NSString *outputPath = [arguments fullPathValueForKey:CLK_ZipArchive_Output];
		ITZip *output = [[ITZip alloc] initWithPath:outputPath];
		
		NSError *error = nil;
		if (input.isApp) {
			ITApp *app = [[ITApp alloc] initWithPath:input];
			error = [ZipArchive zipApp:app to:output];
		}
		else if (input.isPayload) {
			ITPayload *payload = [[ITPayload alloc] initWithPath:input];
			error = [ZipArchive zipPayload:payload to:output];
		}
		else if (input.isIPA) {
			ITIPA *ipa = [[ITIPA alloc] initWithPath:input];
			error = [ZipArchive zipIPA:ipa to:output];
		}
		else {
			return [ZipArchive zip:[[ITPath alloc] initWithPath:input] to:output];
		}
		
		if (error) {
			[error ipa_println];
		}
		return error;
	}];
}

- (void)za_initCommand_unzip {
	NSString *command = @"unzip";
	[self setCommand:command explain:@"Unpackage an app."];
	[self setKey:CLK_ZipArchive_Input abbr:@"i" optional:NO example:@"/path/to/file" explain:@"A file path to operate." forCommand:command];
	[self setKey:CLK_ZipArchive_Output abbr:@"o" optional:YES example:@"/path/to/file" explain:@"Output path." forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		NSString *inputPath = [arguments fullPathValueForKey:CLK_ZipArchive_Input];
		NSString *outputPath = [arguments fullPathValueForKey:CLK_ZipArchive_Output];
		
		ITZip *input = [[ITZip alloc] initWithPath:inputPath];
		ITIPA *temp = [ITIPA tempPath];
		
		id res = [ZipArchive unzip:input to:temp];
		if ([res isKindOfClass:[NSError class]]) {
			NSError *error = res;
			[error ipa_println];
			return error;
		}
		
		if (outputPath.isIPA) {
			ITIPA *ipa = [[ITIPA alloc] initWithPath:outputPath];
			for (MUPath *path in temp.contentPathes) {
				MUPath *to = [ipa pathByAppendingComponent:path.lastPathComponent];
				[SharedFileManager moveItemAtPath:path.path toPath:to.path autoCover:YES];
			}
			return nil;
		}
		
		else if (outputPath.isPayload) {
			ITPayload *payload = [[ITPayload alloc] initWithPath:outputPath];
			[SharedFileManager moveItemAtPath:temp.payload.path toPath:payload.path autoCover:YES];
		}
		
		else if (outputPath.isApp) {
			ITApp *app = [[ITApp alloc] initWithPath:outputPath];
			[SharedFileManager moveItemAtPath:temp.payload.app.path toPath:app.path autoCover:YES];
		}
		
		return nil;
	}];
}

@end
