//
//  CLArguments+IPATool.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+IPATool.h"

#import "CLArguments+AppIcon.h"
#import "CLArguments+InfoPlist.h"
#import "CLArguments+CodeSign.h"
#import "CLArguments+ZipArchive.h"

#import "ITIPA.h"
#import "ITZip.h"

#import "AppIcon.h"
#import "CodeSign.h"
#import "InfoPlist.h"
#import "ZipArchive.h"

#import "NSError+IPATool.h"

#define CLK_Certificate			@"certificate"
#define CLK_MobileProvision		@"mobile-provision"
#define CLK_Entitlements		@"entitlements"
#define CLK_AppIcon				@"icon"
#define CLK_BundleIdentifier	@"bundle-identifier"

@implementation CLArguments (IPATool)

+ (instancetype)sharedInstance {
	static CLArguments *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] initWithRequireCommand:NO];
		[_sharedInstance initCommand];
		[_sharedInstance initMain];
	});
	return _sharedInstance;
}

- (void)initCommand {
	[self initAppIcon];
	[self initInfoPlist];
	[self initCodeSign];
	[self initZipArchive];
}

- (void)initMain {
	[self setCommand:nil explain:@"Operating a package, [--key -k value] input [output]"];
	[self setKey:CLK_Certificate
			abbr:@"c" optional:YES example:@"iPhone Developer: xxxx"
		 explain:@"Optional, sign code if type in this key."];
	[self setKey:CLK_MobileProvision
			abbr:@"m" optional:YES example:@"/path/to/.mobileprovision"
		 explain:@"Optional, sign code and copy to .app if type in this key."];
	[self setKey:CLK_Entitlements
			abbr:@"e" optional:YES example:@"/path/to/.plist"
		 explain:@"Optional, sign code with the entitle or the entitlements in mobile provision"];
	[self setKey:CLK_AppIcon
			abbr:nil optional:YES example:@"/path/to/image"
		 explain:@"Optional, modify icon files in .app if type in this key."];
	[self setKey:CLK_BundleIdentifier abbr:nil optional:YES example:@"com.unique.xxx"
		 explain:@"Optional, modify CFBundleIdentifier in .app and all plugin if type in this key."];
	[self setCommand:nil task:^NSError *(CLArguments *arguments) {
		NSString *input = [arguments fullIOPathAtIndex:0];
		NSString *output = [arguments fullIOPathAtIndex:1];output = output.length > 0 ? output : input;
		
		ITZip *zip			= nil;
		ITIPA *ipa			= nil;
		ITPayload *payload	= nil;
		ITApp *app			= nil;
		
		IPAResult *result	= nil;
		
		if (input.isZip) {
			zip = [[ITZip alloc] initWithPath:input];
			ipa = [[ITIPA tempPath] pathByAppendingComponent:zip.lastPathComponent.stringByDeletingPathExtension];
			[ipa createDirectoryIfNeeds];
			NSError *error = [ZipArchive unzip:zip to:ipa];
			if (error) {
				[error ipa_println];
				return error;
			}
			payload = ipa.payload;
			app = payload.app;
		}
		else if (input.isIPA) {
			ipa = [[ITIPA alloc] initWithPath:input];
			payload = ipa.payload;
			app = payload.app;
		}
		else if (input.isPayload) {
			payload = [[ITPayload alloc] initWithPath:input];
			app = payload.app;
		}
		else if (input.isApp) {
			app = [[ITApp alloc] initWithPath:input];
		}
		else {
			NSString *description = [NSString stringWithFormat:@"Can not analyse the path: %@", input];
			NSError *error = [NSError ipa_errorWithCode:1 description:description];
			[error ipa_println];
			return error;
		}
		
		result = [arguments main_opreaApp:app];
		if (result.isFailed) {
			[result.error ipa_println];
			return result.error;
		}
		
		ITPath *to = [[ITPath alloc] initWithPath:output];
#define IfZip(file) if (file) {\
	NSError *error = [ZipArchive from:file to:to];\
	if (error) {\
		[error ipa_println];\
		return error;\
	}\
}
			 IfZip(ipa)
		else IfZip(payload)
		else IfZip(app)
			
#undef IfZip
		
		return nil;
	}];
}

- (IPAResult *)main_opreaApp:(ITApp *)app {
	IPAResult *res = nil;
	if ([self hasKey:CLK_AppIcon]) {
		IPAVerbose("Set AppIcon...\n");
		NSError *error = [AppIcon set:app
							   device:AIDeviceAll
								scale:AIScaleAll
							 withIcon:[self fullPathValueForKey:CLK_AppIcon]
							  willSet:^(NSString *iconName) {
								  IPAVerbose("\tSet Icon \"%s\"\n", iconName.UTF8String);
							  } didSet:^(NSString *iconName) {
								  
							  }];
		if (error) {
			IPAReturn(error);
		}
	}
	
	if ([self hasKey:CLK_BundleIdentifier]) {
		NSString *bundleIdentifier = [self stringValueForKey:CLK_BundleIdentifier];
		printf("Set bundle identifier: %s\n", bundleIdentifier.UTF8String);
		res = [InfoPlist setApp:app bundleIdentifier:bundleIdentifier pluginEnable:YES];
		if (res.failed) {
			return res;
		}
	}
	
	if ([self hasKey:CLK_Certificate] && [self hasKey:CLK_MobileProvision]) {
		printf("Code sign...\n");
		
		NSString *certificate = [self stringValueForKey:CLK_Certificate];
		NSString *mobileProvision = [self fullPathValueForKey:CLK_MobileProvision];
		NSString *entitlements = [self fullPathValueForKey:CLK_Entitlements];
		
		if (mobileProvision.length && !entitlements.length) {
			MUMobileProvision *mobileProvisionObj = [MUMobileProvision mobileProvisionWithContentsOfFile:mobileProvision];
			MUPath *tempPath = [[MUPath tempPath] pathByAppendingComponent:@"entitlements.plist"];
			[mobileProvisionObj.Entitlements.dictionary writeToFile:tempPath.path atomically:YES];
			entitlements = tempPath.path;
		}
		
		CSSigner *signer = [CSSigner signerWithCertificate:certificate
										   mobileProvision:mobileProvision
											  entitlements:entitlements];
		
		res = [CodeSign signApp:app withSigner:signer];
		if (res.failed) {
			return res;
		}
	}
	
	return IPASucceed(nil);
}

@end
