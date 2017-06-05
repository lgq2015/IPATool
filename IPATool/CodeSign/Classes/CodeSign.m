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

+ (IPAResult *)signFile:(ITPath *)file withSigner:(CSSigner *)signer {
	return IPAFailed([signer sign:file]);
}

+ (IPAResult *)signApp:(ITApp *)app withSigner:(CSSigner *)signer {
	IPADefineResult;
	
	for (ITPlugin *plugin in app.plugins) {
		NSError *error = [signer sign:plugin];
		if (error) {
			IPAMarkError(error);
			IPAReturnResult;
		}
	}
	
	IPAReturnIfFailed([self _signBinary:app.binary withSigner:signer signLoadedLibrary:YES]);
	
	//	Copy mobile provision to app
	NSFileManager *fmgr = [NSFileManager defaultManager];
	NSError *error = nil;
	[fmgr removeItemAtPath:app.mobileProvision.path error:nil];
	[fmgr copyItemAtPath:signer.mobileProvisionPath toPath:app.mobileProvision.path error:&error];
	return IPAReturn(error);
}

+ (IPAResult *)_signPlugin:(ITPlugin *)plugin withSigner:(CSSigner *)signer {
	return [self signFile:plugin withSigner:signer];
}

+ (IPAResult *)_signBinary:(ITBinary *)binary withSigner:(CSSigner *)signer signLoadedLibrary:(BOOL)signLoadedLibrary {
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
