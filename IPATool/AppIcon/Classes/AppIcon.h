//
//  AppIcon.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "IPAMain.h"
#import "AppIconConst.h"

@class CLArguments;

typedef void(^AIOnSetIcon)(NSString *iconName);

@interface AppIcon : IPAMain

/**
 *	Get icon files
 *
 *	@return NSArray/NSError
 */

+ (id)get:(CLArguments *)arguments;

+ (id)get:(NSString *)appPath device:(AIDeviceOptions)device scale:(AIScaleOptions)scale;

/** 
 *	Set icon files
 *
 *	@return NSError
 */

+ (NSError *)set:(CLArguments *)arguments willSet:(AIOnSetIcon)willSet didSet:(AIOnSetIcon)didSet;

@end
