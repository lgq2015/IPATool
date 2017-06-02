//
//  ITInfoPlist.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPath.h"

@class ITPlugin;

@interface ITInfoPlist : ITPath

@property (nonatomic, strong, readonly) NSDictionary *info;

/** super path */
@property (nonatomic, strong, readonly) ITPlugin *plugin;

@end
