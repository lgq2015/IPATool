//
//  ITPlugin.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPackage.h"
#import "ITBinary.h"

@interface ITPlugin : ITPackage

@property (nonatomic, strong, readonly) ITPlugin *plugins;

@end
