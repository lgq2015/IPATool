//
//  NSError+CodeSign.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CS_Error_CanNotSign		-1

@interface NSError (CodeSign)

+ (instancetype)cs_errorWithCode:(NSInteger)code description:(NSString *)description;

@end
