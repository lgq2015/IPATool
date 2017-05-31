//
//  AIMatcher.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppIconConst.h"

@class CLArguments;

@interface AIMatcher : NSObject

@property (nonatomic, strong, readonly) NSString *appPath;

@property (nonatomic, assign, readonly) AIScaleOptions scaleOptions;
- (BOOL)isMatchScale:(NSUInteger)scale;

@property (nonatomic, assign, readonly) AIDeviceOptions deviceOptions;
@property (nonatomic, assign, readonly, getter=isMatchPhone) BOOL matchPhone;
@property (nonatomic, assign, readonly, getter=isMatchPad) BOOL matchPad;
@property (nonatomic, assign, readonly, getter=isMatchAllDevice) BOOL matchAllDevice;

- (instancetype)initWithArguments:(CLArguments *)arguments;
+ (instancetype)matcherWithArguments:(CLArguments *)arguments;

//- (instancetype)initWithAppPath:(NSString *)appPath scale:(AIScaleOptions)scale device:(AIDeviceOptions)device;
//+ (instancetype)matcherWithAppPath:(NSString *)appPath scale:(AIScaleOptions)scale device:(AIDeviceOptions)device;

/** 
 *	Match all icon file
 *
 *	@return	NSArray/NSError
 */
- (id)match;


@end
