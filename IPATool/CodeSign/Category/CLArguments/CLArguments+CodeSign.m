//
//  CLArguments+CodeSign.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+CodeSign.h"
#import "CodeSign.h"
#import "CSSigner.h"
#import "NSError+CodeSign.h"
#import "NSString+IPATool.h"
#import "ITZip.h"
#import "ITIPA.h"
#import "ZipArchive.h"

@implementation CLArguments (CodeSign)

- (void)initCodeSign {
	[self cs_initCommand_CodeSign];
}

- (void)cs_initCommand_CodeSign {
	NSString *command = @"code-sign";
	[self setCommand:command explain:@"Code sign a binary file or a package."];
	[self setKey:CLK_CodeSign_Certificate abbr:@"c" optional:NO example:@"iPhone Developer: xxx" explain:@"Sign with this certificate." forCommand:command];
	[self setKey:CLK_CodeSign_MobileProvision abbr:@"m" optional:NO example:@"/path/to/.mobileprovision" explain:@"Mobile provision file" forCommand:command];
	[self setKey:CLK_CodeSign_Input abbr:@"i" optional:NO example:@"/path/to/file" explain:@"Should signed file or directory, supporting:(payload|.app|.ipa)." forCommand:command];
	[self setKey:CLK_CodeSign_Entitlements abbr:@"e" optional:YES example:@"/path/to/entitlements.plist" explain:@"Entitlements file." forCommand:command];
	[self setCommand:command task:^NSError *(CLArguments *arguments) {
		IPADefineResult;
		NSString *file				= [arguments fullPathValueForKey:CLK_CodeSign_Input];
		NSString *certificate		= [arguments stringValueForKey:CLK_CodeSign_Certificate];
		NSString *mobileProvision	= [arguments fullPathValueForKey:CLK_CodeSign_MobileProvision];
		NSString *entitlements		= [arguments fullPathValueForKey:CLK_CodeSign_Entitlements];
		
		if (mobileProvision.length && !entitlements.length) {
			MUMobileProvision *mobileProvisionObj = [MUMobileProvision mobileProvisionWithContentsOfFile:mobileProvision];
			MUPath *tempPath = [[MUPath tempPath] pathByAppendingComponment:@"entitlements.plist"];
			[mobileProvisionObj.Entitlements.dictionary writeToFile:tempPath.path atomically:YES];
			entitlements = tempPath.path;
		}
		
		CSSigner *signer = [CSSigner signerWithCertificate:certificate
										   mobileProvision:mobileProvision
											  entitlements:entitlements];
		
		do {
			
			if (file.isZip) {
				ITZip *zip = [[ITZip alloc] initWithPath:file];
				ITPath *tempPath = [ITPath tempPath];
				ITIPA *ipa = [[ITIPA alloc] initWithPath:[tempPath.path stringByAppendingPathComponent:@"ipa"]];
				[ipa createDirectoryIfNeeds];
				[ZipArchive unzip:zip to:ipa];
				IPABreakIfFailed([CodeSign signApp:ipa.payload.app withSigner:signer]);
				IPAMark([ZipArchive zipIPA:ipa to:zip]);
			}
			else if (file.isApp) {
				ITApp *app = [[ITApp alloc] initWithPath:file];
				IPABreakIfFailed([CodeSign signApp:app withSigner:signer])
			}
			else {
				ITPath *path = [[ITPath alloc] initWithPath:file];
				IPABreakIfFailed([CodeSign signFile:path withSigner:signer])
			}
			
		} while (0);
		
		if (IPAIsFailed) {
			NSError *error = IPAResultError;
			[error ipa_println];
			return error;
		} else {
			printf("Sign %s succeed!\n", [arguments fullPathValueForKey:CLK_CodeSign_Input].UTF8String);
			return nil;
		}
	}];
}

@end
