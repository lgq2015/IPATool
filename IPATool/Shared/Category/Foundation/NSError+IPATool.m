//
//  NSError+IPATool.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSError+IPATool.h"

@implementation NSError (IPATool)

- (void)ipa_print {
	printf("%s", self.localizedDescription.UTF8String);
}

- (void)ipa_println {
	printf("%s\n", self.localizedDescription.UTF8String);
}

@end
