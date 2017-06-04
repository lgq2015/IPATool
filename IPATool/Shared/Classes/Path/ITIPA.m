//
//  ITIPA.m
//  IPATool
//
//  Created by Shuang Wu on 2017/6/2.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "ITIPA.h"

@interface ITIPA ()
{
	ITPayload *_payload;
}

@end

@implementation ITIPA

- (ITPayload *)payload {
	if (!_payload) {
		_payload = [[ITPayload alloc] initWithPath:[self.path stringByAppendingPathComponent:@"Payload"]];
	}
	return _payload;
}

@end
