//
//  CodeSign.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CodeSign.h"
#import "CSTask.h"

@implementation CodeSign

+ (id)signWithArguments:(CLArguments *)arguments {
	CSTask *task = [CSTask taskWithArguments:arguments];
	return [task sign];
}

+ (id)signFile:(NSString *)file withCertificate:(NSString *)certificateName mobileProvision:(NSString *)mobileProvisionPath {
	return [self signFile:file withCertificate:certificateName mobileProvision:mobileProvisionPath entitlements:nil];
}

+ (id)signFile:(NSString *)file withCertificate:(NSString *)certificateName mobileProvision:(NSString *)mobileProvisionPath entitlements:(NSString *)entitlementsPath {
	CSTask *task = [CSTask taskWithInput:file certificate:certificateName mobileProvision:mobileProvisionPath entitlements:entitlementsPath];
	return [task sign];
}

@end
