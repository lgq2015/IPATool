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

@implementation CLArguments (IPATool)

+ (instancetype)sharedInstance {
	static CLArguments *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] initWithRequireCommand:NO];
		[_sharedInstance initCommand];
	});
	return _sharedInstance;
}

- (void)initCommand {
	[self initAppIcon];
	[self initInfoPlist];
	[self initCodeSign];
	[self initZipArchive];
	
}

@end
