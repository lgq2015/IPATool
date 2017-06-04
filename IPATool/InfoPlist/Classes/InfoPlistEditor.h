//
//  InfoPlistEditor.h
//  IPATool
//
//  Created by 吴双 on 2017/6/1.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments, ITInfoPlist, InfoPlistReader;

@interface InfoPlistEditor : NSObject

@property (nonatomic, strong, readonly) ITInfoPlist *infoPlist;

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, strong, readonly) NSString *value;

@property (nonatomic, strong, readonly) NSString *type;

- (instancetype)initWithInfoPlist:(ITInfoPlist *)infoPlist
							  key:(NSString *)key
							value:(NSString *)value
							 type:(NSString *)type;

+ (instancetype)editorWithInfoPlist:(ITInfoPlist *)infoPlist
								key:(NSString *)key
							  value:(NSString *)value
							   type:(NSString *)type;

- (NSError *)edit;

@end
