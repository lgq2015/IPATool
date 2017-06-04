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
#import "ITApp.h"

@implementation AppIcon

+ (id)get:(ITApp *)app device:(AIDeviceOptions)device scale:(AIScaleOptions)scale {
	AIMatcher *matcher = [AIMatcher matcherWithAppPath:app.path scale:scale device:device];
	id matched = [matcher match];
	return matched;
}

+ (NSError *)set:(ITApp *)app
		  device:(AIDeviceOptions)device
		   scale:(AIScaleOptions)scale
		withIcon:(NSString *)icon
		 willSet:(AIOnSetIcon)willSet
		  didSet:(AIOnSetIcon)didSet {
	
	id get = [self get:app device:device scale:scale];
	
	if ([get isKindOfClass:[NSArray class]]) {
		NSArray *list = get;
		if (icon.length == 0) {
			return [NSError ai_errorWithCode:AIErrorCodeNotInputPNGFile description:@"Can not change icon with the file named: (null)"];
		}
		NSImage *sourceImage = [[NSImage alloc] initWithContentsOfFile:icon];
		if (!sourceImage) {
			return [NSError ai_errorWithCode:AIErrorCodeNotInputPNGFile
								 description:[NSString stringWithFormat:@"Can not change icon with the file named: (%@)", icon.lastPathComponent]];
		}
		for (NSString *name in list) {
			!willSet?:willSet(name);
			NSString *filePath = [app.path stringByAppendingPathComponent:name];
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
