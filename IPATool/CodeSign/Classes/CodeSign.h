//
//  CodeSign.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITPayload.h"

@class CSSigner;

@interface CodeSign : NSObject

+ (id)signApp:(ITApp *)app withSigner:(CSSigner *)signer;

+ (id)signFile:(ITPath *)file withSigner:(CSSigner *)signer;

@end
