//
//  ITPath.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "MUPath.h"

@class ITApp;

@interface ITPath : MUPath

@property (nonatomic, assign, readonly) BOOL isIPA;

@property (nonatomic, assign, readonly) BOOL isPayload;

@property (nonatomic, assign, readonly) BOOL isApp;

@property (nonatomic, assign, readonly) BOOL isMobileProvision;

@property (nonatomic, assign, readonly) BOOL isInfoPlist;

@property (nonatomic, assign, readonly) BOOL isZip;

@end
