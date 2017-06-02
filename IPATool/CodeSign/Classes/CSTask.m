//
//  CSTask.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CSTask.h"
#import "CLArguments+CodeSign.h"
#import "NSError+CodeSign.h"

#import "CSFileTask.h"
#import "CSBundleTask.h"

@implementation CSTask

- (instancetype)initWithArguments:(CLArguments *)arguments {
	self = [super init];
	if (self) {
		_input = [arguments fullPathValueForKey:CLK_CodeSign_Input];
		_certificate = [arguments stringValueForKey:CLK_CodeSign_Certificate];
		_mobileProvisionPath = [arguments fullPathValueForKey:CLK_CodeSign_MobileProvision];
		_entitlementsPath = [arguments fullPathValueForKey:CLK_CodeSign_Entitlements];
	}
	return self;
}

+ (instancetype)taskWithArguments:(CLArguments *)arguments {
	NSString *input = [arguments fullPathValueForKey:CLK_CodeSign_Input];
	Class c = [CSFileTask class];
	BOOL isBundle = NO;
	isBundle = isBundle || [input.pathExtension isEqualToString:@"app"];
	isBundle = isBundle || [input.pathExtension isEqualToString:@"ipa"];
	isBundle = isBundle || [input.lastPathComponent isEqualToString:@"Payload"];
	
	if (isBundle) {
		c = [CSBundleTask class];
	}
	return [[c alloc] initWithArguments:arguments];
}

- (instancetype)initWithInput:(NSString *)input certificate:(NSString *)certificateName mobileProvision:(NSString *)mobileProvisionPath entitlements:(NSString *)entitlementsPath {
	self = [super init];
	if (self) {
		_input = [input copy];
		_certificate = [certificateName copy];
		_mobileProvisionPath = [mobileProvisionPath copy];
		_entitlementsPath = [entitlementsPath copy];
	}
	return self;
}

+ (instancetype)taskWithInput:(NSString *)input certificate:(NSString *)certificateName mobileProvision:(NSString *)mobileProvisionPath entitlements:(NSString *)entitlementsPath {
	return [[self alloc] initWithInput:input certificate:certificateName mobileProvision:mobileProvisionPath entitlements:entitlementsPath];
}

- (id)sign {
	if (self.error) {
		return self.error;
	}
	return nil;
}

- (NSError *)error {
	if (self.certificate.length == 0) {
		return [NSError cs_errorWithCode:CS_Error_CanNotSign description:@"Can not sign with cerificate named: (null)."];
	}
	return nil;
}

@end
