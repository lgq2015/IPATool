//
//  CSFileTask.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CSFileTask.h"
#import "CommandLine.h"
#import "MUMobileProvision.h"
#import "MUPath.h"
#import "CLArguments+IPATool.h"

@implementation CSFileTask

- (id)sign {
	id res = [super sign];
	if (res) {
		return res;
	} else {
		if (self.mobileProvisionPath && self.entitlementsPath) {
			CLVerbose([CLArguments sharedInstance], "Code sign %s with entitlements ...\n", self.input.lastPathComponent.UTF8String);
			return CLLaunchWithArguments(@[@"/usr/bin/codesign", @"-vvv", @"-fs", self.certificate, @"--entitlements", self.entitlementsPath, @"--no-strict", self.input]);
		}
		else {
			CLVerbose([CLArguments sharedInstance], "Code sign %s ...\n", self.input.lastPathComponent.UTF8String);
			return CLLaunchWithArguments(@[@"/usr/bin/codesign", @"-fs", self.certificate, @"--no-strict", self.input]);
		}
	}
}

@end
