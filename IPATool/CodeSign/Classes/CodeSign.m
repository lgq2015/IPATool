//
//  CodeSign.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CodeSign.h"
#import "CSSigner.h"
#import "MUMobileProvision.h"
#import "NSError+CodeSign.h"

@implementation CodeSign

+ (id)signFile:(ITPath *)file withSigner:(CSSigner *)signer {
	return [signer sign:file];
}

+ (id)signApp:(ITApp *)app withSigner:(CSSigner *)signer {
	
	id res = nil;
	
	for (ITPlugin *plugin in app.plugins) {
		id signRes = [signer sign:plugin];
		if ([signRes isKindOfClass:[NSError class]]) {
			return signRes;
		}
	}
	
	
	res = [signer sign:app.binary];
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	}
	
	
	res = [self _signBinary:app.binary withSigner:signer signLoadedLibrary:YES];
	if ([res isKindOfClass:[NSError class]]) {
		return res;
	}
	
	//	Copy mobile provision to app
	NSFileManager *fmgr = [NSFileManager defaultManager];
	[fmgr removeItemAtPath:app.mobileProvision.path error:nil];
	[fmgr copyItemAtPath:signer.mobileProvisionPath toPath:app.mobileProvision.path error:&res];
	
	return res;
}

+ (id)_signPlugin:(ITPlugin *)plugin withSigner:(CSSigner *)signer {
	return [self signFile:plugin withSigner:signer];
}

+ (id)_signBinary:(ITBinary *)binary withSigner:(CSSigner *)signer signLoadedLibrary:(BOOL)signLoadedLibrary {
	id res = nil;
	if (signLoadedLibrary) {
		for (ITBinary *library in binary.loadedUserLibrary) {
			res = [self _signBinary:library
						 withSigner:signer
				  signLoadedLibrary:signLoadedLibrary];
			if ([res isKindOfClass:[NSError class]]) {
				break;
			}
		}
	}
	return [self signFile:binary withSigner:signer];
}

@end
