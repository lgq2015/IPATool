//
//  AppIconConst.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#ifndef AppIconConst_h
#define AppIconConst_h

typedef NS_ENUM(NSUInteger, AIScaleOptions) {
	AIScaleNone = 0,
	AIScale1	= 1 << 0,
	AIScale2	= 1 << 1,
	AIScale3	= 1 << 2,
	AIScaleAll	= AIScale1 | AIScale2 | AIScale3,
};

typedef NS_ENUM(NSUInteger, AIDeviceOptions) {
	AIDeviceNone	= 0,
	AIDevicePhone	= 1 << 0,
	AIDevicePad		= 1 << 1,
	AIDeviceAll		= AIDevicePhone | AIDevicePad,
};

#endif /* AppIconConst_h */
