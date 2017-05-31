//
//  NSError+InfoPlist.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSError+InfoPlist.h"

@implementation NSError (InfoPlist)

+ (instancetype)ip_errorWithCode:(NSInteger)code description:(NSString *)description {
	return [NSError errorWithDomain:@"com.unique.ipatool.infoplist" code:code userInfo:@{NSLocalizedDescriptionKey:description}];
}

@end
