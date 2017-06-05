//
//  InfoPlist.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "InfoPlist.h"
#import "CLArguments+InfoPlist.h"
#import "InfoPlistReader.h"
#import "InfoPlistEditor.h"

#import "ITInfoPlist.h"
#import "ITApp.h"

#define IPK_iPhoneOS_BID		@"CFBundleIdentifier"
#define IPK_WatchKit_BID		@"NSExtension/NSExtensionAttributes/WKAppBundleIdentifier"

@implementation InfoPlist

+ (IPAResult *)getInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key {
	InfoPlistReader *reader = [InfoPlistReader readerWithInfoPlist:infoPlist key:key];
	return IPAReturn([reader read]);
}

+ (IPAResult *)setInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key value:(NSString *)value type:(NSString *)type {
	InfoPlistEditor *editor = [InfoPlistEditor editorWithInfoPlist:infoPlist key:key value:value type:type];
	return IPAReturn([editor edit]);
}

+ (IPAResult *)setApp:(ITApp *)app bundleIdentifier:(NSString *)bundleIdentifier pluginEnable:(BOOL)pluginEnable {
	IPADefineResult;
	NSString *mainOrig = nil;
	if (pluginEnable) {
		IPAReturnIfFailed([self getInfoPlist:app.infoPlist key:IPK_iPhoneOS_BID]);
		mainOrig = IPAResultOutput;
	}
	
	IPAReturnIfFailed([self setInfoPlist:app.infoPlist key:IPK_iPhoneOS_BID value:bundleIdentifier type:@"string"]);
	
	if (pluginEnable) {
		for (ITPlugin *plugin in app.plugins) {
			NSString *pluginOri = nil;
			NSString *pluginNew = nil;
			
			IPAReturnIfFailed([self getInfoPlist:plugin.infoPlist key:IPK_iPhoneOS_BID]);
			
			pluginOri = IPAResultOutput;
			pluginNew = [pluginOri stringByReplacingOccurrencesOfString:mainOrig withString:bundleIdentifier];
			IPAReturnIfFailed([self setInfoPlist:plugin.infoPlist key:IPK_iPhoneOS_BID value:pluginNew type:@"string"]);
			
			IPAMark([self getInfoPlist:plugin.infoPlist key:IPK_WatchKit_BID]);
			if ([IPAResultError.localizedDescription hasSuffix:@"Does Not Exist"]) {
				IPAMark(nil);
				continue;
			}
			pluginOri = IPAResultOutput;
			pluginNew = [pluginOri stringByReplacingOccurrencesOfString:mainOrig withString:bundleIdentifier];
			
			IPAReturnIfFailed([self setInfoPlist:plugin.infoPlist key:IPK_WatchKit_BID value:pluginNew type:@"string"]);
		}
	}
	
	IPAReturnSuccess;
}

+ (IPAResult *)setApp:(ITApp *)app bundleDisplayName:(NSString *)bundleDisplayName {
	return [self setInfoPlist:app.infoPlist key:@"CFBundleDisplayName" value:bundleDisplayName type:@"string"];
}

@end
