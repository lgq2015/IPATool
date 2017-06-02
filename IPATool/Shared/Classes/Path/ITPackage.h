//
//  ITPackage.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPath.h"
#import "ITBinary.h"
#import "ITInfoPlist.h"

@interface ITPackage : ITPath

@property (nonatomic, strong, readonly) ITInfoPlist *infoPlist;

@property (nonatomic, strong, readonly) ITBinary *binary;

@end
