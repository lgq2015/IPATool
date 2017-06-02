//
//  NSError+CodeSign.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSError+CodeSign.h"

@implementation NSError (CodeSign)

+ (instancetype)cs_errorWithCode:(NSInteger)code description:(NSString *)description {
	return [self errorWithDomain:@"com.unique.ipatool.codesign" code:code userInfo:@{NSLocalizedDescriptionKey:description}];
}

@end
