//
//  ITPath.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPath.h"

#import "ITIPA.h"
#import "ITPayload.h"
#import "ITApp.h"
#import "ITPlugin.h"

@implementation ITPath

- (BOOL)isIPA {
	ITPath *payload = [self pathByAppendingComponment:@"Payload"];
	return payload.exist;
}

- (BOOL)isPayload {
	return [self is:@"Payload"];
}

- (BOOL)isApp {
	return [self isA:@"app"];
}

- (BOOL)isMobileProvision {
	return [self isA:@"mobileprovision"];
}

- (BOOL)isInfoPlist {
	return [self is:@"Info.plist"];
}

- (BOOL)isZip {
	return [self isA:@"ipa"] || [self isA:@"zip"];
}

@end
