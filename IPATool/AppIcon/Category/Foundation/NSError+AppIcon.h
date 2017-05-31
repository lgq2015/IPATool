//
//  NSError+AppIcon.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AIErrorCodeNotFoundPackage		-1
#define AIErrorCodeAppIsNotPackage		-2
#define AIErrorCodeNoInfoPlistfile		-3

#define AIErrorCodeNotInputPNGFile		-4

@interface NSError (AppIcon)

+ (instancetype)ai_errorWithCode:(NSInteger)code description:(NSString *)description;

@end
