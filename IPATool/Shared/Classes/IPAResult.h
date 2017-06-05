//
//  IPAResult.h
//  IPATool
//
//  Created by Shuang Wu on 2017/6/5.
//  Copyright © 2017年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+IPATool.h"

#define IPADefineResult				IPAResult *_ipa_result_ = nil;

#define IPAResultOutput				_ipa_result_.output
#define IPAResultError				_ipa_result_.error

#define IPAIsFailed					_ipa_result_.isFailed
#define IPAIsSucceed				_ipa_result_.isSucceed

#define IPAReturnResult				return _ipa_result_

#define IPAMark(result)				{_ipa_result_ = IPAReturn(result);}
#define IPAMarkSucceed(output)		{_ipa_result_ = IPASucceed(output);}
#define IPAMarkError(error)			{_ipa_result_ = IPAFailed(error);}
#define IPAReturnIfFailed(value)	{_ipa_result_ = value; if(_ipa_result_.isFailed) return _ipa_result_;}
#define IPABreakIfFailed(value)	    {_ipa_result_ = value; if(_ipa_result_.isFailed) break;}

#define IPAReturnSuccess			return IPASucceed(@"");

@interface IPAResult : NSObject

@property (nonatomic, strong, readonly) NSString *output;

@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, assign, readonly, getter=isSucceed) BOOL success;

@property (nonatomic, assign, readonly, getter=isFailed) BOOL failed;

- (void)println;

+ (instancetype)succeed:(NSString *)output;

+ (instancetype)failed:(NSError *)error;

@end

IPAResult *IPAFailed(NSError *error);

IPAResult *IPASucceed(NSString *output);

IPAResult *IPAReturn(id result);
