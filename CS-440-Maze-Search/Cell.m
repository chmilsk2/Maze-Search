//
//  Cell.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (id)initWithState:(NSUInteger)state coordinate:(CGPoint)coordinate {
	self = [super init];
	
	if (self) {
		_state = state;
		_coordinate = coordinate;
		_visited = NO;
		_isOnSolutionPath = NO;
		_parent = nil;
		_depth = 0;
		_costIncurred = 0;
	}
	
	return self;
}

- (BOOL)isEqual:(id)object {
	if (object == self) {
		return YES;
	}
	
	if (!object || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	
	return [self isEqualToCell:object];
}

- (BOOL)isEqualToCell:(Cell *)cell {
	if (self.coordinate.x != cell.coordinate.x || self.coordinate.y != cell.coordinate.y) {
		return NO;
	}
	
	return YES;
}

- (NSUInteger)hash {
	// simple hash function
	
	// start with
	NSUInteger prime = 31;
	NSUInteger result = 1;
	
	// For objects you use 0 for nil and otherwise their hashcode.
	// template: result = prime * result + [var hash];
	NSValue *coordinateValue = [NSValue valueWithCGPoint:self.coordinate];
	result = prime * result + [coordinateValue hash];
	
	return result;
}

@end
