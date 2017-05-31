//
//  InfoPlist.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments;

@interface InfoPlist : NSObject

+ (id)get:(CLArguments *)arguments;

+ (id)set:(CLArguments *)arguments;

@end
