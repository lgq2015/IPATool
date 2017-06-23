//
//  Certificate.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/15.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "Certificate.h"
#import "CommandLine.h"

@implementation Certificate

+ (IPAResult *)allCertificateNames {
	id res = CLLaunchWithArguments(@[@"/usr/bin/security", @"find-identity", @"-v", @"-p", @"codesigning"]);
	if ([res isKindOfClass:[NSError class]]) {
		return IPAReturn(res);
	} else {
		NSString *output = res;
		NSArray *outputLines = [output componentsSeparatedByString:@"\n"];
		NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"\".*\"" options:NSRegularExpressionCaseInsensitive error:nil];
		
		NSMutableSet *list = [NSMutableSet set];
		for (NSString *line in outputLines) {
			NSRange range = [line rangeOfString:@") "];
			if (range.length == 0) {
				continue;
			}
			range = [regular firstMatchInString:line options:1 range:NSMakeRange(0, line.length)].range;
			NSString *name = [line substringWithRange:range];
			name = [[name substringToIndex:name.length - 1] substringFromIndex:1];
			[list addObject:name];
		}
		NSArray *sortedList = [list.allObjects sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
			return [obj1 compare:obj2];
		}];
		return IPASucceed([sortedList componentsJoinedByString:@"\n"]);
	}
}

@end
