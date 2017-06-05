//
//  CSSigner.m
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CSSigner.h"

#import "ITPath.h"
#import "CommandLine.h"
#import "CLArguments+IPATool.h"
#import "NSError+CodeSign.h"

@interface CSSigner ()
{
	NSString *_certificateName;
	NSString *_mobileProvisionPath;
	NSString *_entitlementsPath;
}
@end

@implementation CSSigner

- (instancetype)initWithCertificate:(NSString *)certificateName {
	self = [self initWithCertificate:certificateName mobileProvision:nil entitlements:nil];
	return self;
}

+ (instancetype)signerWithCertificate:(NSString *)certificateName {
	return [[self alloc] initWithCertificate:certificateName];
}

- (instancetype)initWithCertificate:(NSString *)certificateName
					mobileProvision:(NSString *)mobileProvisionPath
					   entitlements:(NSString *)entitlementsPath {
	self = [super init];
	if (self) {
		_certificateName = [certificateName copy];
		_mobileProvisionPath = [mobileProvisionPath copy];
		_entitlementsPath = [entitlementsPath copy];
	}
	return self;
}

+ (instancetype)signerWithCertificate:(NSString *)certificateName
					  mobileProvision:(NSString *)mobileProvisionPath
						 entitlements:(NSString *)entitlementsPath {
	return [[self alloc] initWithCertificate:certificateName mobileProvision:mobileProvisionPath entitlements:entitlementsPath];
}

- (NSError *)canSign {
	if (self.certificateName.length == 0) {
		return [NSError cs_errorWithCode:CS_Error_CanNotSign description:@"The certificate name is (null)."];
	}
	
	if (![SharedFileManager fileExistsAtPath:self.mobileProvisionPath]) {
		return [NSError cs_errorWithCode:CS_Error_CanNotSign description:@"The mobile provision is not exist."];
	}
	
	if (![SharedFileManager fileExistsAtPath:self.entitlementsPath]) {
		return [NSError cs_errorWithCode:CS_Error_CanNotSign description:@"The entitlements is not exist."];
	}
	
	return nil;
}

- (NSError *)sign:(ITPath *)file {
	
	if (![SharedFileManager fileExistsAtPath:file.path]) {
		return [NSError cs_errorWithCode:CS_Error_CanNotSign description:@"The file is not exist."];
	}
	
	NSError *error = [self canSign];
	if (!error) {
		if (self.mobileProvisionPath) {
			error = [self signWithMobileProvisionAndEntitlements:file];
		} else {
			error = [self signWithoutMobileProvisionAndEntitlements:file];
		}
	}
	return error;
}

- (NSError *)signWithMobileProvisionAndEntitlements:(ITPath *)file {
	CLVerbose([CLArguments sharedInstance], "Code sign %s with entitlements ...\n", file.lastPathComponment.UTF8String);
	id res = CLLaunchWithArguments(@[@"/usr/bin/codesign",
									  @"-vvv", @"-fs",
									  self.certificateName,
									  @"--entitlements",
									  self.entitlementsPath,
									  @"--no-strict",
									  file.path]);
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	} else {
		return nil;
	}
}

- (NSError *)signWithoutMobileProvisionAndEntitlements:(ITPath *)file {
	CLVerbose([CLArguments sharedInstance], "Code sign %s ...\n", file.lastPathComponment.UTF8String);
	id res =  CLLaunchWithArguments(@[@"/usr/bin/codesign", @"-fs", self.certificateName, @"--no-strict", file.path]);
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	} else {
		return nil;
	}
}

@end
