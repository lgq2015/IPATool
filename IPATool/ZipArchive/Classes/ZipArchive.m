//
//  ZipArchive.m
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ZipArchive.h"

#import "CommandLine.h"
#import "NSFileManager+IPATool.h"

/** 
 *	cd /path
 */
//	zip -qry output.zip input_file

//	TODO:	to.xxx.app 可能为空

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
	{
		IPAVerbose("Unpack: %s\n", file.lastPathComponent.UTF8String);
	}
	id res = CLLaunchWithArguments(@[@"/usr/bin/unzip", @"-q", file.path, @"-d", to.path]);
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	} else {
		return nil;
	}
}

+ (NSError *)cd:(NSString *)directory zip:(NSString *)file to:(NSString *)to {
	{
		if ([file isEqualToString:@"."]) {
			IPAVerbose("Package: %s\n", directory.lastPathComponent.UTF8String);
		} else {
			IPAVerbose("package: %s\n", file.UTF8String);
		}
	}
	id res = CLLaunchInDirectoryWithArguments(directory, @[@"/usr/bin/zip", @"-qry", to, file]);
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	} else {
		return nil;
	}
}

+ (NSError *)from:(ITPath *)from to:(ITPath *)to {
	NSString *path = from.path;
	if (path.isZip) {
		return [self __zip:[ITZip.alloc initWithPath:path] to:to];
	}
	else if (path.isIPA) {
		return [self __ipa:[ITIPA.alloc initWithPath:path] to:to];
	}
	else if (path.isPayload) {
		return [self __payload:[ITPayload.alloc initWithPath:path] to:to];
	}
	else if (path.isApp) {
		return [self __app:[ITApp.alloc initWithPath:path] to:to];
	} else {
		return [self errorWithCode:1 opera:@"analyse" path:path];
	}
}

+ (NSError *)errorWithCode:(NSInteger)code opera:(NSString *)opera path:(NSString *)path {
	NSString *description = [NSString stringWithFormat:@"Can not %@ the path: %@", opera, path];
	return [NSError errorWithDomain:@"com.unique.ipatool.archive" code:1 userInfo:@{NSLocalizedDescriptionKey:description}];
}

+ (NSError *)__zip:(ITZip *)zip to:(ITPath *)to {
	NSString *path = to.path;
	if (path.isZip) {
		[[NSFileManager defaultManager] moveItemAtPath:zip.path toPath:to.path autoCover:YES];
	}
	else if (path.isIPA) {
		return [self unzip:zip to:[ITIPA.alloc initWithPath:path]];
	}
	
	ITIPA *ipa = [ITIPA tempPath];
	NSError *error = [self unzip:zip to:ipa]; if (error) {return error;}
	
	if (path.isPayload) {
		return [[NSFileManager defaultManager] copyItemAtPath:ipa.payload.path toPath:path autoCover:YES];
	}
	else if (path.isApp) {
		return [[NSFileManager defaultManager] copyItemAtPath:ipa.payload.app.path toPath:path autoCover:YES];
	} else {
		return [self errorWithCode:2 opera:@"output" path:path];
	}
}

+ (NSError *)__ipa:(ITIPA *)ipa to:(ITPath *)to {
	NSString *path = to.path;
	if (path.isZip) {
		return [self zipIPA:ipa to:[ITZip.alloc initWithPath:path]];
	}
	else if (path.isIPA) {
		return [[NSFileManager defaultManager] copyItemAtPath:ipa.path toPath:path autoCover:YES];
	}
	else if (path.isPayload) {
		return [[NSFileManager defaultManager] copyItemAtPath:ipa.payload.path toPath:path autoCover:YES];
	}
	else if (path.isApp) {
		return [[NSFileManager defaultManager] copyItemAtPath:ipa.payload.app.path toPath:path autoCover:YES];
	} else {
		return [self errorWithCode:2 opera:@"output" path:path];
	}
}

+ (NSError *)__payload:(ITPayload *)payload to:(ITPath *)to {
	NSString *path = to.path;
	if (path.isZip) {
		return [self zipPayload:payload to:[ITZip.alloc initWithPath:path]];
	}
	else if (path.isIPA) {
		ITIPA *ipa = [[ITIPA alloc] initWithPath:path];
		return [[NSFileManager defaultManager] copyItemAtPath:payload.path toPath:ipa.payload.path autoCover:YES];
	}
	else if (path.isPayload) {
		return [[NSFileManager defaultManager] copyItemAtPath:payload.path toPath:path autoCover:YES];
	}
	else if (path.isApp) {
		return [[NSFileManager defaultManager] copyItemAtPath:payload.app.path toPath:path autoCover:YES];
	} else {
		return [self errorWithCode:2 opera:@"output" path:path];
	}
}

+ (NSError *)__app:(ITApp *)app to:(ITPath *)to {
	NSString *path = to.path;
	if (path.isZip) {
		return [self zipApp:app to:[ITZip.alloc initWithPath:path]];
	}
	else if (path.isIPA) {
		ITIPA *ipa = [[ITIPA alloc] initWithPath:path];
		return [[NSFileManager defaultManager] copyItemAtPath:app.path toPath:[ipa.payload.path stringByAppendingPathComponent:app.lastPathComponent] autoCover:YES];
	}
	else if (path.isPayload) {
		ITPayload *payload = [[ITPayload alloc] initWithPath:path];
		[payload createDirectoryIfNeeds];
		return [[NSFileManager defaultManager] copyItemAtPath:app.path toPath:[payload.path stringByAppendingPathComponent:app.lastPathComponent] autoCover:YES];
	}
	else if (path.isApp) {
		return [[NSFileManager defaultManager] copyItemAtPath:app.path toPath:path autoCover:YES];
	} else {
		return [self errorWithCode:2 opera:@"output" path:path];
	}
}

@end
