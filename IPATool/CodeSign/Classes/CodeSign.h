//
//  CodeSign.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLArguments;

@interface CodeSign : NSObject

+ (id)signWithArguments:(CLArguments *)arguments;

+ (id)signFile:(NSString *)file withCertificate:(NSString *)certificateName mobileProvision:(NSString *)mobileProvisionPath;

+ (id)signFile:(NSString *)file withCertificate:(NSString *)certificateName mobileProvision:(NSString *)mobileProvisionPath entitlements:(NSString *)entitlementsPath;

@end
