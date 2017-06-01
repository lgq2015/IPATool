//
//  InfoPlistBuddy.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments;

@interface InfoPlistBuddy : NSObject

@property (nonatomic, strong, readonly) NSString *command;

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong, readonly) NSString *format;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, strong, readonly) NSString *path;

@property (nonatomic, strong, readonly) NSArray *taskArguments;
@property (nonatomic, strong, readonly) id taskResult;

@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithArguments:(CLArguments *)arguments;
+ (instancetype)buddyWithArguments:(CLArguments *)arguments;

+ (instancetype)getBuddyWithPath:(NSString *)path key:(NSString *)key;
+ (instancetype)setBuddyWithPath:(NSString *)path key:(NSString *)key value:(NSString *)value type:(NSString *)type;

@end
