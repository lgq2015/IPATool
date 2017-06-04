//
//  InfoPlistReader.h
//  IPATool
//
//  Created by 吴双 on 2017/6/1.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments, ITInfoPlist;

@interface InfoPlistReader : NSObject

@property (nonatomic, strong, readonly) ITInfoPlist *infoPlist;

@property (nonatomic, strong, readonly) NSString *key;

- (instancetype)initWithInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key;
+ (instancetype)readerWithInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key;

- (id)read;

@end
