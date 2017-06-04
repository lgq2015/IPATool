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

@property (nonatomic, strong, readonly) NSArray<NSString *> *componments;

@property (nonatomic, strong, readonly) NSString *lastPathComponment;

@property (nonatomic, strong, readonly) NSString *pathExtension;

@property (nonatomic, assign, readonly, getter=isExist) BOOL exist;

@property (nonatomic, assign, readonly, getter=isFolder) BOOL folder;

@property (nonatomic, assign, readonly, getter=isFile) BOOL file;

@property (nonatomic, strong, readonly) NSArray<MUPath *> *contentPathes;

@property (nonatomic, strong, readonly) NSArray<NSString *> *contentComponments;

+ (instancetype)tempPath;

- (BOOL)is:(NSString *)fileName;

- (BOOL)isA:(NSString *)pathExtension;

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithMUPath:(MUPath *)path;
- (instancetype)initWithComponments:(NSArray<NSString *> *)componments;

- (void)remove;
- (void)createDirectoryIfNeeds;

- (BOOL)containsSubpath:(NSString *)subpath;

- (instancetype)superPath;
- (instancetype)pathByAppendingComponment:(NSString *)componment;
- (instancetype)pathByReplacingLastPastComponment:(NSString *)componment;

@end
