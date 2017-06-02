//
//  CSBundleTask.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "CSTask.h"

@interface CSBundleTask : CSTask

@property (nonatomic, assign, readonly) BOOL pluginEnable;

- (instancetype)initWithInput:(NSString *)input
				  certificate:(NSString *)certificateName
			  mobileProvision:(NSString *)mobileProvisionPath
				 entitlements:(NSString *)entitlementsPath
				 pluginEnable:(BOOL)pluginEnable;

@end
