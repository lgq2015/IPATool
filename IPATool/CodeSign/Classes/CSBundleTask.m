//
//  CSBundleTask.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CSBundleTask.h"
#import "CLArguments+CodeSign.h"
#import "ITApp.h"
#import "CSFileTask.h"

@interface CSBundleTask ()

@property (nonatomic, strong) MUMobileProvision *mobileProvision;

@property (nonatomic, strong) NSString *tempEntitlementsPath;

@end

@implementation CSBundleTask

- (instancetype)initWithArguments:(CLArguments *)arguments {
	self = [super initWithArguments:arguments];
	if (self) {
		_pluginEnable = [arguments hasFlags:CLK_CodeSign_Plugin];
	}
	return self;
}

- (instancetype)initWithInput:(NSString *)input certificate:(NSString *)certificateName mobileProvision:(NSString *)mobileProvisionPath entitlements:(NSString *)entitlementsPath pluginEnable:(BOOL)pluginEnable {
	self = [super initWithInput:input certificate:certificateName mobileProvision:mobileProvisionPath entitlements:entitlementsPath];
	if (self) {
		_pluginEnable = pluginEnable;
	}
	return self;
}

- (id)sign {
	id res = [super sign];
	if (res) {
		return res;
	}
	
	ITApp *app = [ITPath packagePathWithPath:self.input].app;
	if (self.pluginEnable) {
		for (ITPlugin *plugin in app.plugins) {
			id signRes = [self signMainBinary:plugin.binary];
			if ([signRes isKindOfClass:[NSError class]]) {
				return signRes;
			}
			
			signRes = [self signFile:plugin.path];
			if ([signRes isKindOfClass:[NSError class]]) {
				return signRes;
			}
		}
	}
	
	[self signMainBinary:app.binary];
	
	CSFileTask *task = [CSFileTask taskWithInput:app.path
									 certificate:self.certificate
								 mobileProvision:self.mobileProvisionPath
									entitlements:self.entitlementsPath];
	res = [task sign];
	
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	}
	
	if (self.mobileProvisionPath) {
		NSFileManager *fmgr = [NSFileManager defaultManager];
		[fmgr removeItemAtPath:app.mobileProvision.path error:nil];
		[fmgr copyItemAtPath:self.mobileProvisionPath toPath:app.mobileProvision.path error:&res];
	}
	return res;
}

- (id)signMainBinary:(ITBinary *)binary {
	return [self signBinary:binary signTarget:NO signLoaded:YES];
}

- (id)signFile:(NSString *)file {
	return [[CSFileTask taskWithInput:file
						  certificate:self.certificate
					  mobileProvision:self.mobileProvisionPath
						 entitlements:self.entitlementsPath] sign];
}

- (id)signBinary:(ITBinary *)binary signTarget:(BOOL)signTarget signLoaded:(BOOL)signLoaded {
	if (signLoaded) {
		for (ITBinary *loadedBinary in binary.loadedUserLibrary) {
			id res = [self signBinary:loadedBinary signTarget:YES signLoaded:YES];
			if ([res isKindOfClass:[NSError class]]) {
				return res;
			}
		}
	}
	
	if (signTarget) {
		return [self signFile:binary.path];
	}
	
	return nil;
}

- (NSString *)entitlementsPath {
	if ([super entitlementsPath].length > 0) {
		return [super entitlementsPath];
	}
	else {
		return self.tempEntitlementsPath;
	}
}

- (NSString *)tempEntitlementsPath {
	if (!_tempEntitlementsPath && self.mobileProvisionPath) {
		MUPath *tempPath = [MUPath tempPath];
		tempPath = [tempPath pathWithAppendingComponment:@"Entitlements.plist"];
		[self.mobileProvision.Entitlements.dictionary writeToFile:tempPath.path atomically:YES];
		_tempEntitlementsPath = tempPath.path;
	}
	return _tempEntitlementsPath;
}

- (MUMobileProvision *)mobileProvision {
	if (!_mobileProvision) {
		_mobileProvision = [MUMobileProvision mobileProvisionWithContentsOfFile:self.mobileProvisionPath];
	}
	return _mobileProvision;
}

@end
