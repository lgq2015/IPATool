//
//  NSArray+IPATool.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSArray+IPATool.h"

@implementation NSArray (IPATool)

- (instancetype)arrayWithRemoveEqualObject {
	NSMutableSet *set = [NSMutableSet set];
	for (id obj in self) {
		[set addObject:obj];
	}
	
	return [[self.class alloc] initWithArray:set.allObjects];
}

@end
