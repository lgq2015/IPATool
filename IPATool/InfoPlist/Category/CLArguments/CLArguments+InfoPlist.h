//
//  CLArguments+InfoPlist.h
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+IPATool.h"

#define CLK_InfoPlist_Input		@"input"
#define CLK_InfoPlist_Key		@"key"
#define CLK_InfoPlist_Object	@"obj"
#define CLK_InfoPlist_Type		@"type"
#define CLK_InfoPlist_Plugin	@"plugin"

@interface CLArguments (InfoPlist)

- (void)initInfoPlist;

@end
