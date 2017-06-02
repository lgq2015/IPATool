//
//  ITPath.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUPath.h"

@class ITApp;

@interface ITPath : MUPath

@property (nonatomic, strong, readonly) ITApp *app;

+ (instancetype)packagePathWithPath:(NSString *)path;

@end
