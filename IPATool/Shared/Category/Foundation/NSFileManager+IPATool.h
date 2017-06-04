//
//  NSFileManager+IPATool.h
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (IPATool)

- (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath autoCover:(BOOL)autoCover;

- (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath autoCover:(BOOL)autoCover;

@end
