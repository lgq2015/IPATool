//
//  CLArguments+CodeSign.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CLArguments+IPATool.h"

#define CLK_CodeSign_Certificate		@"certificate"
#define CLK_CodeSign_MobileProvision	@"mobile-provision"
#define CLK_CodeSign_Entitlements		@"entitlements"
#define CLK_CodeSign_Plugin				@"plugin"
#define CLK_CodeSign_Input				@"input"

@interface CLArguments (CodeSign)

- (void)initCodeSign;

@end
