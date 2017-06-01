//
//  InfoPlistEditor.h
//  IPATool
//
//  Created by 吴双 on 2017/6/1.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments;

@interface InfoPlistEditor : NSObject

@property (nonatomic, strong, readonly) NSString *path;

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, strong, readonly) NSString *value;

@property (nonatomic, strong, readonly) NSString *type;

@property (nonatomic, assign, readonly) BOOL pluginEnable;

- (instancetype)initWithArguments:(CLArguments *)arguments;
+ (instancetype)editorWithArguments:(CLArguments *)arguments;

- (NSError *)edit;

@end
