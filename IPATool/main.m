//
//  main.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLArguments+IPATool.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
		CLArguments *arguments = [CLArguments sharedInstance];
		[arguments analyseArgumentCount:argc values:argv];
		[arguments printExplainAndExist:0];
		[arguments executeCommand];
    }
    return 0;
}
