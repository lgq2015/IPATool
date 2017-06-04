//
//  AppIcon.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "IPAMain.h"
#import "AppIconConst.h"

@class CLArguments, ITApp;

typedef void(^AIOnSetIcon)(NSString *iconName);

@interface AppIcon : IPAMain

/**
 *	Get icon file name
 *
 *	@param app		ITApp
 *	@param device	Device options
 *	@param scale	Scale options
 *	@return			NSError or NSArray
 */
+ (id)get:(ITApp *)app device:(AIDeviceOptions)device scale:(AIScaleOptions)scale;

/**
 *	Set Icon
 *
 *	@param app		ITApp
 *	@param device	Device options
 *	@param scale	Scale options
 *	@param icon		Icon file path
 *	@param willSet	Block, call when will set the icon file
 *	@param didSet	Block, call when did setted the icon file
 *	@return			NSError or nil
 */
+ (NSError *)set:(ITApp *)app
		  device:(AIDeviceOptions)device
		   scale:(AIScaleOptions)scale
		withIcon:(NSString *)icon
		 willSet:(AIOnSetIcon)willSet
		  didSet:(AIOnSetIcon)didSet;

@end
