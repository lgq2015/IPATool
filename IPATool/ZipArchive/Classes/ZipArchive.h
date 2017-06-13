//
//  ZipArchive.h
//  IPATool
//
//  Created by 吴双 on 2017/6/4.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITIPA.h"
#import "ITZip.h"

@interface ZipArchive : NSObject

+ (NSError *)zipIPA:(ITIPA *)ipa to:(ITZip *)to;

+ (NSError *)zipPayload:(ITPayload *)payload to:(ITZip *)to;

+ (NSError *)zipApp:(ITApp *)app to:(ITZip *)to;

+ (NSError *)zip:(ITPath *)file to:(ITZip *)to;



+ (NSError *)unzip:(ITZip *)file to:(ITIPA *)to;


+ (NSError *)from:(ITPath *)from to:(ITPath *)to;

@end
