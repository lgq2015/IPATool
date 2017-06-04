//
//  CSSigner.h
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITPath;

@interface CSSigner : NSObject

@property (nonatomic, strong, readonly) NSString *certificateName;

@property (nonatomic, strong, readonly) NSString *mobileProvisionPath;

@property (nonatomic, strong, readonly) NSString *entitlementsPath;

- (instancetype)initWithCertificate:(NSString *)certificateName;
+ (instancetype)signerWithCertificate:(NSString *)certificateName;

- (instancetype)initWithCertificate:(NSString *)certificateName
					mobileProvision:(NSString *)mobileProvisionPath
					   entitlements:(NSString *)entitlementsPath;
+ (instancetype)signerWithCertificate:(NSString *)certificateName
					  mobileProvision:(NSString *)mobileProvisionPath
						 entitlements:(NSString *)entitlementsPath;

- (NSError *)sign:(ITPath *)file;

@end
