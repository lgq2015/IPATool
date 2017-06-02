//
//  ITMobileProvision.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITMobileProvision.h"

@interface ITMobileProvision ()
{
	MUMobileProvision *_mobileProvision;
}

@end

@implementation ITMobileProvision

- (MUMobileProvision *)mobileProvision {
	if (!_mobileProvision) {
		_mobileProvision = [MUMobileProvision mobileProvisionWithContentsOfFile:self.path];
	}
	return _mobileProvision;
}

@end
