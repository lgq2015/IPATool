//
//  InfoPlistReader.h
//  IPATool
//
//  Created by 吴双 on 2017/6/1.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments;

@interface InfoPlistReader : NSObject

@property (nonatomic, strong, readonly) NSString *path;

@property (nonatomic, strong, readonly) NSString *key;

- (instancetype)initWithArguments:(CLArguments *)arguments;
+ (instancetype)readerWithArguments:(CLArguments *)arguments;

- (instancetype)initWithPath:(NSString *)path key:(NSString *)key;
+ (instancetype)readerWithPath:(NSString *)path key:(NSString *)key;

- (id)read;

@end
