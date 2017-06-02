//
//  CSTask.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments;

@interface CSTask : NSObject

@property (nonatomic, strong, readonly) NSString *input;
@property (nonatomic, strong, readonly) NSString *certificate;
@property (nonatomic, strong, readonly) NSString *mobileProvisionPath;
@property (nonatomic, strong, readonly) NSString *entitlementsPath;

@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithArguments:(CLArguments *)arguments;
+ (instancetype)taskWithArguments:(CLArguments *)arguments;

- (instancetype)initWithInput:(NSString *)input
				  certificate:(NSString *)certificateName
			  mobileProvision:(NSString *)mobileProvisionPath
				 entitlements:(NSString *)entitlementsPath;

+ (instancetype)taskWithInput:(NSString *)input
				  certificate:(NSString *)certificateName
			  mobileProvision:(NSString *)mobileProvisionPath
				 entitlements:(NSString *)entitlementsPath;

- (id)sign;

@end
