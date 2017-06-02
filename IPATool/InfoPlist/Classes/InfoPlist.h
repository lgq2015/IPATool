//
//  InfoPlist.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments;

@interface InfoPlist : NSObject

+ (id)get:(CLArguments *)arguments;

+ (id)set:(CLArguments *)arguments;

+ (id)getWithPath:(NSString *)path key:(NSString *)key;

+ (id)setWithPath:(NSString *)path key:(NSString *)key value:(NSString *)value type:(NSString *)type pluginEnable:(BOOL)pluginEnable;

@end
