//
//  NSError+AppIcon.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSError+AppIcon.h"

@implementation NSError (AppIcon)

+ (instancetype)ai_errorWithCode:(NSInteger)code description:(NSString *)description {
	return [NSError errorWithDomain:@"com.unique.ipatool.appicon" code:code userInfo:@{NSLocalizedDescriptionKey:description}];
}

@end
