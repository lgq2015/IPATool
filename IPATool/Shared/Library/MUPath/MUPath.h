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

@property (nonatomic, strong, readonly) NSArray<NSString *> *components;

@property (nonatomic, strong, readonly) NSString *lastPathComponent;

@property (nonatomic, strong, readonly) NSString *pathExtension;

@property (nonatomic, assign, readonly, getter=isExist) BOOL exist;

@property (nonatomic, assign, readonly, getter=isFolder) BOOL folder;

@property (nonatomic, assign, readonly, getter=isFile) BOOL file;

@property (nonatomic, strong, readonly) NSArray *contentPathes;

@property (nonatomic, strong, readonly) NSArray<NSString *> *contentComponents;

+ (instancetype)tempPath;

- (BOOL)is:(NSString *)fileName;

- (BOOL)isA:(NSString *)pathExtension;

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithMUPath:(MUPath *)path;
- (instancetype)initWithComponents:(NSArray<NSString *> *)components;

- (void)remove;
- (void)createDirectoryIfNeeds;

- (BOOL)containsSubpath:(NSString *)subpath;

- (instancetype)superPath;
- (instancetype)pathByAppendingComponent:(NSString *)component;
- (instancetype)pathByReplacingLastPastComponent:(NSString *)component;

@end
