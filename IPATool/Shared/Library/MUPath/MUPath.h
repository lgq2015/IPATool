//
//  MUPath.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUPath : NSObject

@property (nonatomic, strong, readonly) NSString *path;

@property (nonatomic, strong, readonly) MUPath *superPath;

@property (nonatomic, strong, readonly) NSArray<NSString *> *componments;

@property (nonatomic, strong, readonly) NSString *lastPathComponment;

+ (instancetype)tempPath;

- (void)remove;
- (void)createDirectoryIfNeeds;

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithComponments:(NSArray<NSString *> *)componments;

@end
