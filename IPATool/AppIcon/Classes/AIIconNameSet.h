//
//  AIIconNameSet.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIIconNameSet : NSObject

@property (nonatomic, readonly) NSArray *allObjects;

+ (instancetype)set;

- (void)addIconName:(NSString *)object;

- (void)addIconNames:(NSArray *)objects;

@end
