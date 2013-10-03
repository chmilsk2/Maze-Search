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

@interface Maze ()

@property Cell *startingCell;
@property Cell *goalCell;

@end

@implementation Maze

- (id)initWithName:(NSString *)name cells:(NSArray *)cells width:(NSNumber *)width height:(NSNumber *)height startingCell:(Cell *)startingCell goalCell:(Cell *)goalCell goalCells:(NSMutableArray *)goalCells {
	self = [super init];
	
	if (self) {
		_name = name;
		_cells = cells;
		_width = width;
		_height = height;
		_startingCell = startingCell;
		_goalCell = goalCell;
		_goalCells = goalCells;
	}
	
	return self;
}

- (id)initWithMaze:(Maze *)maze {
	NSString *mazeName = [maze.name copy];
	NSNumber *width = [maze.width copy];
	NSNumber *height = [maze.height copy];
	Cell *startingCell = [maze.startingCell copy];
	Cell *goalCell = [maze.goalCell copy];
	
	NSMutableArray *goalCells = [NSMutableArray array];
	NSMutableArray *cells = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < maze.goalCells.count; i++) {
		[goalCells addObject:[maze.goalCells[i] copy]];
	}
	
	for (Cell *cell in maze.cells) {
		[cells addObject:[cell copy]];
	}
	
	self = [self initWithName:mazeName cells:cells width:width height:height startingCell:startingCell goalCell:goalCell goalCells:goalCells];
	
	return self;
}

- (NSArray *)childrenForParent:(Cell *)cell {
	NSMutableArray *children = [NSMutableArray array];
	
	// add children in the following order: right, down, left, up
	
	CGPoint parentCoordinate = cell.coordinate;
	CGPoint leftChildCoordinate = CGPointMake(parentCoordinate.x - 1, parentCoordinate.y);
	CGPoint upChildCoordinate = CGPointMake(parentCoordinate.x, parentCoordinate.y - 1);
	CGPoint rightChildCoordinate = CGPointMake(parentCoordinate.x + 1, parentCoordinate.y);
	CGPoint downChildCoordinate = CGPointMake(parentCoordinate.x, parentCoordinate.y + 1);
	
	NSValue *leftChildCoordinateValue = [NSValue valueWithCGPoint:leftChildCoordinate];
	NSValue *upChildCoordinateValue = [NSValue valueWithCGPoint:upChildCoordinate];
	NSValue *rightChildCoordinateValue = [NSValue valueWithCGPoint:rightChildCoordinate];
	NSValue *downChildCoordinateValue = [NSValue valueWithCGPoint:downChildCoordinate];
	
	NSArray *potentialChildCoordinates = @[rightChildCoordinateValue, downChildCoordinateValue, leftChildCoordinateValue, upChildCoordinateValue];
	
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

- (BOOL)isGoalCell:(Cell *)cell {
	__block BOOL isGoalCell = NO;
	
	[_goalCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Cell *goalCell = obj;
		
		if (goalCell.coordinate.x == cell.coordinate.x && goalCell.coordinate.y == cell.coordinate.y) {
			isGoalCell = YES;
		}
	}];
	
	return isGoalCell;
}

- (void)removeAllTheGoals {
	for (Cell *cell in _cells) {
		if (cell.state == CellStateGoal) {
			[cell setState:CellStatePath];
		}
	}
}

- (void)removeStartingCell {
	for (Cell *cell in _cells) {
		if (cell.state == CellStateStart) {
			cell.state = CellStatePath;
		}
	}
}

- (void)removeAllSolutions {
	for (Cell *cell in _cells) {
		cell.isOnSolutionPath = NO;
	}
}

- (void)addStartingCell:(Cell *)startingCell {
	NSUInteger row = startingCell.coordinate.y;
	NSUInteger col = startingCell.coordinate.x;
	NSUInteger numCols = _width.integerValue;
	
	NSUInteger offset = row*numCols + col;
	Cell *cell = _cells[offset];
	[cell setState:CellStateStart];
	[self setStartingCell:cell];
}

- (void)addGoal:(Cell *)goal {
	NSUInteger row = goal.coordinate.y;
	NSUInteger col = goal.coordinate.x;
	NSUInteger numCols = _width.integerValue;
	
	NSUInteger offset = row*numCols + col;
	Cell *cell = _cells[offset];
	[cell setState:CellStateGoal];
	[self setGoalCell:cell];
}

- (void)setIsOnSolutionPathForMultiGoaledPath:(NSMutableArray *)multiGoaledPath {
	for (Cell *cell in multiGoaledPath) {
		NSUInteger row = cell.coordinate.y;
		NSUInteger col = cell.coordinate.x;
		NSUInteger numCols = _width.integerValue;
		
		NSUInteger offset = row*numCols + col;
		Cell *cell = _cells[offset];
		[cell setIsOnSolutionPath:YES];
	}
}

- (void)setVisitedForCell:(Cell *)cell {
	NSUInteger row = cell.coordinate.y;
	NSUInteger col = cell.coordinate.x;
	NSUInteger numCols = _width.integerValue;
	
	NSUInteger offset = row*numCols + col;
	Cell *originalCell = _cells[offset];
	[originalCell setVisited:YES];
}

@end
