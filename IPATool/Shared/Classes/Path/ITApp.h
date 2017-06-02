//
//  ITApp.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPackage.h"
#import "ITMobileProvision.h"
#import "ITPlugin.h"

@interface ITApp : ITPackage

@property (nonatomic, strong, readonly) ITMobileProvision *mobileProvision;

@property (nonatomic, strong, readonly) NSArray<ITPlugin *> *plugins;

@end
