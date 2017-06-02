//
//  ITIPA.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPath.h"
#import "ITPayload.h"

@interface ITIPA : ITPath

@property (nonatomic, strong, readonly) ITPayload *payload;

@end
