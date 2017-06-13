//
//  CLArguments+IPATool.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments.h"
#import "NSError+IPATool.h"

#define IPAVerbose(...) CLVerbose([CLArguments sharedInstance], __VA_ARGS__);

@interface CLArguments (IPATool)

+ (instancetype)sharedInstance;

@end
