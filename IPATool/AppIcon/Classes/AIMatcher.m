//
//  AIMatcher.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "AIMatcher.h"
#import "CLArguments+AppIcon.h"
#import "AIIconName.h"
#import "AIIconNameSet.h"
#import "NSError+AppIcon.h"

static AIScaleOptions AIScaleOptionsInArguments(CLArguments *arguments) {
	AIScaleOptions scaleOptions = AIScaleNone;
	NSString *scale = [arguments stringValueForKey:CLK_AppIcon_Scale];
	if (scale) {
		if ([scale containsString:@"1"]) {
			scaleOptions |= AIScale1;
		}
		if ([scale containsString:@"2"]) {
			scaleOptions |= AIScale2;
		}
		if ([scale containsString:@"3"]) {
			scaleOptions |= AIScale3;
		}
		if ([scale isEqualToString:@"all"]) {
			scaleOptions |= AIScaleAll;
		}
	} else {
		scaleOptions = AIScaleAll;
	}
	return scaleOptions;
}

static AIDeviceOptions AIDeviceOptionsInArguments(CLArguments *arguments) {
	AIDeviceOptions deviceOptions = AIDeviceNone;
	NSString *input = [arguments stringValueForKey:CLK_AppIcon_Device];
	if (input) {
		if ([input isEqualToString:@"iPhone"]) {
			deviceOptions = AIDevicePhone;
		}
		if ([input isEqualToString:@"iPad"]) {
			deviceOptions = AIDevicePad;
		}
	} else {
		deviceOptions = AIDeviceAll;
	}
	return deviceOptions;
}

static NSString *AIAppPathInArguments(CLArguments *arguments) {
	return [arguments fullPathValueForKey:CLK_AppIcon_AppPath];
}

@interface AIMatcher ()
{
	AIScaleOptions _scaleOptions;
	AIDeviceOptions _deviceOptions;
}

@end

@implementation AIMatcher

- (instancetype)initWithArguments:(CLArguments *)arguments {
	self = [super init];
	if (self) {
		_appPath = AIAppPathInArguments(arguments).copy;
		_scaleOptions = AIScaleOptionsInArguments(arguments);
		_deviceOptions = AIDeviceOptionsInArguments(arguments);
	}
	return self;
}

+ (instancetype)matcherWithArguments:(CLArguments *)arguments {
	return [[self alloc] initWithArguments:arguments];
}

- (BOOL)isMatchScale:(NSUInteger)scale {
	AIScaleOptions options = self.scaleOptions;
	AIScaleOptions targetFlag = 1 < (scale - 1);
	return OptionsHasFlag(options, targetFlag);
}

- (BOOL)isMatchPhone {
	AIDeviceOptions options = self.deviceOptions;
	return OptionsHasFlag(options, AIDevicePhone);
}

- (BOOL)isMatchPad {
	AIDeviceOptions options = self.deviceOptions;
	return OptionsHasFlag(options, AIDevicePad);
}

- (BOOL)isMatchAllDevice {
	AIDeviceOptions options = self.deviceOptions;
	return OptionsHasFlag(options, AIDeviceAll);
}

- (id)match {
	NSFileManager *SharedFileManager = [NSFileManager defaultManager];
	NSString *path = self.appPath;
	BOOL isDirectory = NO;
	if (![SharedFileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
		return [NSError ai_errorWithCode:AIErrorCodeNotFoundPackage description:@"The package not found."];
	}
	if (!isDirectory) {
		return [NSError ai_errorWithCode:AIErrorCodeAppIsNotPackage description:@"The path inputted is not a package"];
	}
	NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"info.plist"]];
	if (!info) {
		return [NSError ai_errorWithCode:AIErrorCodeNoInfoPlistfile description:@"Can not read the info.plist."];
	}
	AIIconNameSet *icons = [AIIconNameSet set];
	
	if (self.isMatchPhone) {
		AIIconNameSet *set = [AIIconNameSet set];
		NSArray *list = info[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
		for (NSString *name in list) {
			NSSet *fileName = [self MatchedIconFilesWithFileName:name isPad:NO];
			[set addIconNames:fileName.allObjects];
		}
		[icons addIconNames:set.allObjects];
	}
	
	if (self.isMatchPad) {
		AIIconNameSet *set = [AIIconNameSet set];
		NSArray *list = info[@"CFBundleIcons~ipad"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
		for (NSString *name in list) {
			NSSet *fileName = [self MatchedIconFilesWithFileName:name isPad:YES];
			[set addIconNames:fileName.allObjects];
		}
		[icons addIconNames:set.allObjects];
	}
	
	if (self.isMatchAllDevice) {
		AIIconNameSet *set = [AIIconNameSet set];
		NSArray *list = info[@"CFBundleIconFiles"];
		for (NSString *name in list) {
			NSSet *fileName = [self MatchedIconFilesWithFileName:name isPad:YES];
			[set addIconNames:fileName.allObjects];
		}
		[icons addIconNames:set.allObjects];
	}
	
	return [icons allObjects];
}

#define FileExist(file) [[NSFileManager defaultManager] fileExistsAtPath:file]
#define ReturnIfIconExist(icon) if ([icon existInPath:path]) {return icon.name;}

- (NSString *)MatchedIconFileWithFileName:(NSString *)input scale:(NSUInteger)scale isPad:(BOOL)isPad {
	NSString *path = self.appPath;
	AIIconName *orig = [AIIconName nameWithName:input];
	AIIconName *name = [AIIconName nameWithName:input];
	name.hasPNGPathExtension = YES;
	if (scale > 1 && isPad) {
		name.scale = scale;
		name.isPad = isPad;
		ReturnIfIconExist(name);
	}
	
	if (scale > 1) {
		name.scale = scale;
		ReturnIfIconExist(name);
	}
	
	if (isPad) {
		name.isPad = isPad;
		ReturnIfIconExist(name);
	}
	
	ReturnIfIconExist(orig);
	return nil;
}

- (NSSet *)MatchedIconFilesWithFileName:(NSString *)input isPad:(BOOL)isPad {
	NSMutableSet *list = [NSMutableSet set];
	for (int i = 1; i < 4; i++) {
		if (![self isMatchScale:i]) {
			continue;
		}
		NSString *file = [self MatchedIconFileWithFileName:input scale:i isPad:isPad];
		if (file) {
			[list addObject:file];
		}
	}
	return [list copy];
}


@end
