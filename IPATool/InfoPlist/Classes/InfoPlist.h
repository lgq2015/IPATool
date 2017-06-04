//
//  InfoPlist.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments, ITInfoPlist, ITApp;

@interface InfoPlist : NSObject

+ (id)getInfoPlist:(ITInfoPlist *)path key:(NSString *)key;

+ (id)setInfoPlist:(ITInfoPlist *)path key:(NSString *)key value:(NSString *)value type:(NSString *)type;

@end
