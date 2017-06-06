//
//  ZipArchive.m
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ZipArchive.h"

#import "CommandLine.h"

/** 
 *	cd /path
 */
//	zip -qry output.zip input_file

@implementation ZipArchive

+ (NSError *)zipIPA:(ITIPA *)ipa to:(ITZip *)to {
	NSError *error = [self cd:ipa.path zip:@"." to:to.lastPathComponent];
	if (!error) {
		MUPath *path = [ipa pathByAppendingComponent:to.lastPathComponent];
		[SharedFileManager moveItemAtPath:path.path toPath:to.path autoCover:YES];
	}
	return error;
}

+ (NSError *)zipPayload:(ITPayload *)payload to:(ITZip *)to {
	NSError *error = [self cd:payload.superPath.path zip:@"Payload" to:to.lastPathComponent];
	if (!error) {
		MUPath *path = [payload pathByReplacingLastPastComponent:to.lastPathComponent];
		if (path.exist) {
			[SharedFileManager moveItemAtPath:path.path toPath:to.path autoCover:YES];
		}
	}
	return error;
}

+ (NSError *)zipApp:(ITApp *)app to:(ITZip *)to {
	ITPath *tempPath = [ITPath tempPath];
	ITPayload *payload = [[ITPayload alloc] initWithMUPath:[tempPath pathByAppendingComponent:@"Payload"]];
	[payload createDirectoryIfNeeds];
	NSString *fromApp = app.path;
	NSString *toApp = [payload pathByAppendingComponent:app.lastPathComponent].path;
	[SharedFileManager copyItemAtPath:fromApp toPath:toApp autoCover:YES];
	return [self zipPayload:payload to:to];
}

+ (NSError *)zip:(ITPath *)file to:(ITZip *)to {
	NSError *error = [self cd:file.superPath.path zip:file.lastPathComponent to:to.lastPathComponent];
	if (!error) {
		MUPath *path = [file pathByReplacingLastPastComponent:to.lastPathComponent];
		[SharedFileManager moveItemAtPath:path.path toPath:to.path autoCover:YES];
	}
	return error;
}

+ (NSError *)unzip:(ITZip *)file to:(ITIPA *)to {
	id res = CLLaunchWithArguments(@[@"/usr/bin/unzip", @"-q", file.path, @"-d", to.path]);
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	} else {
		return nil;
	}
}

+ (NSError *)cd:(NSString *)directory zip:(NSString *)file to:(NSString *)to {
	//	TODO
	id res = CLLaunchInDirectoryWithArguments(directory, @[@"/usr/bin/zip", @"-qry", to, file]);
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	} else {
		return nil;
	}
}

@end
