//
//  NSString+IPATool.h
//  IPATool
//
//  Created by 吴双 on 2017/6/3.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IPATool)

@property (nonatomic, assign, readonly) BOOL isIPA;

@property (nonatomic, assign, readonly) BOOL isPayload;

@property (nonatomic, assign, readonly) BOOL isApp;

@property (nonatomic, assign, readonly) BOOL isMobileProvision;

@property (nonatomic, assign, readonly) BOOL isInfoPlist;

@property (nonatomic, assign, readonly) BOOL isZip;

@end
