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

@implementation InfoPlist

+ (id)getInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key {
	InfoPlistReader *reader = [InfoPlistReader readerWithInfoPlist:infoPlist key:key];
	return [reader read];

}

+ (id)setInfoPlist:(ITInfoPlist *)infoPlist key:(NSString *)key value:(NSString *)value type:(NSString *)type {
	InfoPlistEditor *editor = [InfoPlistEditor editorWithInfoPlist:infoPlist key:key value:value type:type];
	return [editor edit];
}

@end
