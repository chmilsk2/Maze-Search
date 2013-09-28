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
	}
	
	return self;
}

@end
