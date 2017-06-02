//
//  ITBinary.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITPath.h"

@interface ITBinary : ITPath

@property (nonatomic, strong, readonly) ITBinary *executableBinary;

@property (nonatomic, strong, readonly) ITBinary *loadingBinary;

@property (nonatomic, strong) NSArray<ITBinary *> *loadedUserLibrary;

@property (nonatomic, strong) NSArray<ITBinary *> *loadedSystemLibrary;

@end
