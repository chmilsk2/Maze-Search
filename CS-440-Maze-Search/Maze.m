//
//  Maze.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "Maze.h"
#import "Cell.h"
#import "CellState.h"

@implementation Maze

- (id)initWithName:(NSString *)name cells:(NSArray *)cells width:(NSNumber *)width height:(NSNumber *)height startingCell:(Cell *)startingCell goalCell:(Cell *)goalCell{
	self = [super init];
	
	if (self) {
		_name = name;
		_cells = cells;
		_width = width;
		_height = height;
		_startingCell = startingCell;
		_goalCell = goalCell;
	}
	
	return self;
}

- (NSArray *)childrenForParent:(Cell *)cell {
	NSMutableArray *children = [NSMutableArray array];
	
	// add children in the following order: left, up, right, down
	
	CGPoint parentCoordinate = cell.coordinate;
	CGPoint leftChildCoordinate = CGPointMake(parentCoordinate.x - 1, parentCoordinate.y);
	CGPoint upChildCoordinate = CGPointMake(parentCoordinate.x, parentCoordinate.y - 1);
	CGPoint rightChildCoordinate = CGPointMake(parentCoordinate.x + 1, parentCoordinate.y);
	CGPoint downChildCoordinate = CGPointMake(parentCoordinate.x, parentCoordinate.y + 1);
	
	NSValue *leftChildCoordinateValue = [NSValue valueWithCGPoint:leftChildCoordinate];
	NSValue *upChildCoordinateValue = [NSValue valueWithCGPoint:upChildCoordinate];
	NSValue *rightChildCoordinateValue = [NSValue valueWithCGPoint:rightChildCoordinate];
	NSValue *downChildCoordinateValue = [NSValue valueWithCGPoint:downChildCoordinate];
	
	NSArray *potentialChildCoordinates = @[leftChildCoordinateValue, upChildCoordinateValue, rightChildCoordinateValue, downChildCoordinateValue];
	
	for (NSValue *coordinateValue in potentialChildCoordinates) {
		Cell *child = [self cellForCoordinate:coordinateValue.CGPointValue];
		
		if (child && (child.state == CellStatePath || child.state == CellStateStart || child.state == CellStateGoal)) {
			[children addObject:child];
		}
	}
	
	return [NSArray arrayWithArray:children];
}

- (Cell *)cellForCoordinate:(CGPoint)coordinate {
	Cell *cell;

	// if cell coordinate is within the border of the maze and is a path state, then return it, otherwise return nil
	
	if (coordinate.x >= 0 && coordinate.y >= 0) {
		NSUInteger row = coordinate.y;
		NSUInteger col = coordinate.x;
		NSUInteger numCols = _width.integerValue;
		
		NSUInteger offset = row*numCols + col;
		cell = _cells[offset];
	}
	
	return cell;
}

@end
