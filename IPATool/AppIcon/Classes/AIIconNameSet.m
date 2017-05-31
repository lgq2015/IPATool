//
//  AIIconNameSet.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "AIIconNameSet.h"

@interface AIIconNameSet ()

@property (nonatomic, strong) NSMutableSet *set;

@end

@implementation AIIconNameSet

+ (instancetype)set {
	return [self new];
}

- (NSArray *)allObjects {
	return self.set.allObjects;
}

- (void)addIconName:(NSString *)object {
	for (NSString *obj in self.set) {
		NSString *str1 = obj.lowercaseString;
		NSString *str2 = object.lowercaseString;
		if ([str1 isEqualToString:str2]) {
			if ([object compare:obj] < 0) {
				//	use uppercase instead lowercase
				[self.set removeObject:obj];
				[self.set addObject:object];
			}
			return;
		}
	}
	[self.set addObject:object];
}

- (void)addIconNames:(NSArray *)objects {
	for (NSString *object in objects) {
		[self addIconName:object];
	}
}

- (NSMutableSet *)set {
	if (!_set) {
		_set = [[NSMutableSet alloc] init];
	}
	return _set;
}

@end
