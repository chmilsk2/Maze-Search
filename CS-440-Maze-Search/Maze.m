//
//  Maze.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "Maze.h"

@implementation Maze

- (id)initWithName:(NSString *)name cells:(NSArray *)cells width:(NSNumber *)width height:(NSNumber *)height {
	self = [super init];
	
	if (self) {
		_name = name;
		_cells = cells;
		_width = width;
		_height = height;
	}
	
	return self;
}

@end
