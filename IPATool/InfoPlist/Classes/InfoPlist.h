//
//  InfoPlist.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments, ITInfoPlist, ITApp;

@interface InfoPlist : NSObject

+ (IPAResult *)getInfoPlist:(ITInfoPlist *)path key:(NSString *)key;

+ (IPAResult *)setInfoPlist:(ITInfoPlist *)path key:(NSString *)key value:(NSString *)value type:(NSString *)type;

+ (IPAResult *)setApp:(ITApp *)app bundleIdentifier:(NSString *)bundleIdentifier pluginEnable:(BOOL)pluginEnable;

+ (IPAResult *)setApp:(ITApp *)app bundleDisplayName:(NSString *)bundleDisplayName;

@end
