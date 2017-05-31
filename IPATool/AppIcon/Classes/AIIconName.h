//
//  AIIconName.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUPath.h"

@interface AIIconName : NSObject

@property (nonatomic, assign) NSUInteger scale;

@property (nonatomic, assign) BOOL isPad;

@property (nonatomic, assign) BOOL hasPNGPathExtension;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *pngPathExtension;

- (instancetype)initWithName:(NSString *)name;
+ (instancetype)nameWithName:(NSString *)name;

- (BOOL)existInPath:(NSString *)path;

@end
