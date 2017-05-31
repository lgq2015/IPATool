//
//  AppIcon.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppIcon.h"
#import "CLArguments+AppIcon.h"
#import "AIMatcher.h"
#import "NSImage+AppIcon.h"
#import "NSError+AppIcon.h"

@implementation AppIcon

+ (id)get:(CLArguments *)arguments {
	AIMatcher *matcher = [AIMatcher matcherWithArguments:arguments];
	id mathed = [matcher match];
	return mathed;
}

+ (id)get:(NSString *)appPath device:(AIDeviceOptions)device scale:(AIScaleOptions)scale {
	return nil;
}

+ (id)set:(CLArguments *)arguments willSet:(AIOnSetIcon)willSet didSet:(AIOnSetIcon)didSet {
	id get = [self get:arguments];
	if ([get isKindOfClass:[NSArray class]]) {
		
		NSArray *list = get;
		NSString *path = [arguments fullPathValueForKey:CLK_AppIcon_AppPath];
		
		NSString *sourcePath = [arguments fullPathValueForKey:CLK_AppIcon_Icon];
		if (sourcePath.length == 0) {
			return [NSError ai_errorWithCode:AIErrorCodeNotInputPNGFile description:@"Can not change icon with the file named: (null)"];
		}
		NSImage *sourceImage = [[NSImage alloc] initWithContentsOfFile:sourcePath];
		if (!sourceImage) {
			return [NSError ai_errorWithCode:AIErrorCodeNotInputPNGFile description:[NSString stringWithFormat:@"Can not change icon with the file named: (%@)", sourcePath.lastPathComponent]];
		}
		for (NSString *name in list) {
			!willSet?:willSet(name);
			NSString *filePath = [path stringByAppendingPathComponent:name];
			NSData *data = [NSData dataWithContentsOfFile:filePath];
			NSImage *image = [[NSImage alloc] initWithData:data];
			NSSize size = image.size;
			image = [sourceImage imageWithSize:size];
			data = [image TIFFRepresentation];
			[data writeToFile:filePath atomically:YES];
			!didSet?:didSet(name);
		}
	}
	return get;
}

@end
