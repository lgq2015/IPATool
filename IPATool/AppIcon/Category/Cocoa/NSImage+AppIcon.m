//
//  NSImage+AppIcon.m
//  IPATool
//
//  Created by Shuang Wu on 2017/4/27.
//  Copyright © 2017年 unique. All rights reserved.
//

#import "NSImage+AppIcon.h"

@implementation NSImage (Size)

- (instancetype)imageWithSize:(NSSize)size {
	if (!self.isValid) return nil;
	
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
							 initWithBitmapDataPlanes:NULL
							 pixelsWide:size.width
							 pixelsHigh:size.height
							 bitsPerSample:8
							 samplesPerPixel:4
							 hasAlpha:YES
							 isPlanar:NO
							 colorSpaceName:NSCalibratedRGBColorSpace
							 bytesPerRow:0
							 bitsPerPixel:0];
	rep.size = size;
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
	[self drawInRect:NSMakeRect(0, 0, size.width, size.height) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
	[NSGraphicsContext restoreGraphicsState];
	
	NSImage *newImage = [[NSImage alloc] initWithSize:size];
	[newImage addRepresentation:rep];
	return newImage;
}

@end
