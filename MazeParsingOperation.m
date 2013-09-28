//
//  MazeParsingOperation.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeParsingOperation.h"
#import "Maze.h"
#import "Cell.h"

@interface MazeParsingOperation ()

@property (nonatomic, getter = isFinished) BOOL finished;

@end

@implementation MazeParsingOperation {
	NSString *_filename;
}

- (id)initWithFilename:(NSString *)filename {
	self = [super init];
	
	if (self) {
		_filename = filename;
	}
	
	return self;
}

- (void)start {
	self.finished = NO;
	
	[self parseMaze];
}

- (void)parseMaze {
	NSString *mazeFilepath = [[NSBundle mainBundle] pathForResource:_filename ofType:@"txt"];
	
	NSString *fileContents = [NSString stringWithContentsOfFile:mazeFilepath encoding:NSUTF8StringEncoding error:nil];
	NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
	
	NSNumber *width;
	NSNumber *height = [NSNumber numberWithInteger:lines.count];
	
	// since the mazes are always rectangular, find the number of columns by looking at the first line
	NSString *firstLine = lines[0];
	width = [NSNumber numberWithInteger:firstLine.length];
	
	// use row major order to store the maze in memory as a multidimensional array
	NSInteger capacity = width.integerValue * height.integerValue;
	NSMutableArray *cells = [[NSMutableArray alloc] initWithCapacity:capacity];
	
	// row major order offset
	// offset = row*NUMCOLS + column
	NSInteger numCols = width.integerValue;
	NSInteger offset;
	
	Cell *startingCell;
	Cell *goalCell;
	
	for (NSInteger row = 0; row < height.integerValue; row++) {
		for (NSInteger col = 0; col < width.integerValue; col++) {
			offset = row*numCols + col;
			
			NSString *line = lines[row];
			unichar character = [line characterAtIndex:col];
			
			NSNumber *cellState;
			
			// wall
			if (character == '%') {
				cellState = [NSNumber numberWithInteger:CellStateWall];
			}
			
			// path
			if (character == ' ') {
				cellState = [NSNumber numberWithInteger:CellStatePath];
			}
			
			// starting position
			else if (character == 'P') {
				cellState = [NSNumber numberWithInteger:CellStateStart];
			}
			
			// goal
			else if (character == '.') {
				cellState = [NSNumber numberWithInteger:CellStateGoal];
			}
			
			CGPoint coordinate = CGPointMake(col, row);
			Cell *cell = [[Cell alloc] initWithState:[cellState unsignedIntegerValue] coordinate:coordinate];
			cells[offset] = cell;
		}
	}
	
	Maze *maze = [[Maze alloc] initWithName:_filename cells:cells width:width height:height startingCell:startingCell goalCell:goalCell];
	
	[self finishedParsingMazeWithMaze:maze];
}

- (void)finishedParsingMazeWithMaze:(Maze *)maze {
	if (self.mazeParsingCompletionHandler) {
		self.mazeParsingCompletionHandler(_filename, maze);
	}
	
	self.finished = YES;
}

- (void)setFinished:(BOOL)finished {
	[self willChangeValueForKey:@"isFinished"];
	[self willChangeValueForKey:@"isExecuting"];
	_finished = finished;
	[self didChangeValueForKey:@"isFinished"];
	[self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
	return !self.finished;
}

@end
