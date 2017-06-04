//
//  NSError+InfoPlist.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IPErrorCodeShouldInpufPlist		-1
#define IPErrorCodeNotFoundInfoPlist	-2

@interface NSError (InfoPlist)

+ (instancetype)ip_errorWithCode:(NSInteger)code description:(NSString *)description;

@end
