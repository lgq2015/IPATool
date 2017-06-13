//
//  AIIconName.m
//  IPATool
//
//  Created by Shuang Wu on 2017/5/31.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "AIIconName.h"

static NSString *AIScaleMarkWithScale(NSUInteger scale) {
	return @[@"", @"", @"@2x", @"@3x"][scale];
}

@interface AIIconName ()

@property (nonatomic, strong) NSMutableString *mPath;

@end

@implementation AIIconName

- (instancetype)initWithName:(NSString *)string {
	self = [super init];
	if (self) {
		self.mPath = [NSMutableString stringWithString:string];
		if (self.mPath.pathExtension.length == 0) {
			[self.mPath appendString:@".png"];
		}
	}
	return self;
}

+ (instancetype)nameWithName:(NSString *)name {
	return [[self alloc] initWithName:name];
}

- (void)setScale:(NSUInteger)scale {
	if (self.scale == scale) {
		return;
	}
	BOOL isPad = self.isPad;
	self.hasPNGPathExtension = NO;
	self.isPad = NO;
	if (self.scale == 1) {
		[self.mPath appendString:AIScaleMarkWithScale(scale)];
	} else {
		[self.mPath replaceCharactersInRange:self.rangeOfScaleMark
								  withString:AIScaleMarkWithScale(scale)];
	}
	
	self.isPad = isPad;
	self.hasPNGPathExtension = YES;
}

- (NSUInteger)scale {
	NSRange range = [self.mPath rangeOfString:@"@"];
	if (range.length == 0) {
		return 1;
	} else {
		NSString *sub = [self.mPath substringWithRange:NSMakeRange(range.location + 1, 1)];
		return [sub integerValue];
	}
}

- (void)setIsPad:(BOOL)isPad {
	if (isPad == self.isPad) {
		return;
	}
	
	if (!isPad) {
		[self.mPath deleteCharactersInRange:[self.mPath rangeOfString:@"~ipad"]];
	} else {
		if (self.pngPathExtension.length) {
			self.hasPNGPathExtension = NO;
			[self.mPath appendString:@"~ipad"];
			self.hasPNGPathExtension = YES;
		} else {
			[self.mPath appendString:@"~ipad"];
		}
	}
}

- (BOOL)isPad {
	return [self.mPath containsString:@"~ipad"];
}

- (void)setHasPNGPathExtension:(BOOL)hasPNGPathExtension {
	if (self.hasPNGPathExtension == hasPNGPathExtension) {
		return;
	}
	if (hasPNGPathExtension) {
		[self.mPath appendString:@".png"];
	} else {
		NSString *string = [self.mPath stringByDeletingPathExtension];
		[self replaceWithString:string];
	}
}

- (BOOL)hasPNGPathExtension {
	return [self.mPath hasSuffix:@".png"];
}

- (NSRange)rangeOfScaleMark {
	NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"@[0-9]x" options:NSRegularExpressionCaseInsensitive error:nil];
	return [regular firstMatchInString:self.mPath options:1 range:NSMakeRange(0, self.mPath.length)].range;
}

- (BOOL)existInPath:(NSString *)path {
	return [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:self.name]];
}

- (void)replaceWithString:(NSString *)string {
	self.mPath = [NSMutableString stringWithString:string];
}

- (NSString *)name {
	return self.mPath.copy;
}

- (NSString *)pngPathExtension {
	if ([self hasPNGPathExtension]) {
		return @"png";
	} else {
		return nil;
	}
}

- (NSMutableString *)mPath {
	if (!_mPath) {
		_mPath = [[NSMutableString alloc] init];
	}
	return _mPath;
}

@end
