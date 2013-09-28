//
//  MazeView.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeView.h"
#import "CellState.h"

@implementation MazeView {
	// start colors
	UIColor *_startColorUnvisited;
	UIColor *_startColorVisited;
	
	// goal colors
	UIColor *_goalColorUnvisited;
	UIColor *_goalColorVisited;
	
	// wall color
	UIColor *_wallColor;
	
	// path colors
	UIColor *_pathColorUnvisited;
	UIColor *_pathColorVisited;
}

- (void)reloadData {
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor whiteColor];
		
		// start colors
		_startColorUnvisited = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
		_startColorVisited = [UIColor colorWithRed:64.0/255.0 green:153.0/255.0 blue:1.0 alpha:1.0];
		
		// goal colors
		_goalColorUnvisited = [UIColor colorWithRed:0 green:255.0/255.0 blue:0 alpha:1.0];
		_goalColorVisited = [UIColor colorWithRed:64.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0];
		
		// wall color
		_wallColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
		
		// path colors
		_pathColorUnvisited = self.backgroundColor;
		_pathColorVisited = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    NSUInteger numberOfRows = [self.dataSource numberOfRows];
	NSUInteger numberOfCols = [self.dataSource numberOfCols];
	
	CGFloat height = [self.dataSource height];
	CGFloat width = [self.dataSource width];
	
	CGFloat boardHeight;
	CGFloat boardWidth;
	
	CGFloat cellSize;
	
	if (numberOfCols >= numberOfRows) {
		cellSize = floor(width / numberOfCols);
	}
	
	else {
		cellSize = floor(height / numberOfRows);
	}

	
	if ((NSInteger)cellSize % 2) {
		cellSize -= 1;
	}
	
	boardWidth = cellSize * numberOfCols;
	boardHeight = cellSize * numberOfRows;
	
	NSUInteger horizontalMargin = [self.dataSource horizontalMarginForBoardWidth:boardWidth];
	NSUInteger verticalMargin = [self.dataSource verticalMarginForBoardHeight:boardHeight];
	
	for (NSInteger row = 0; row < numberOfRows; row++) {
		for (NSInteger col = 0; col < numberOfCols; col++) {
			
			NSUInteger cellState = [self.dataSource stateForRow:row col:col];
			
			BOOL visited = [self.dataSource isVisitedForRow:row col:col];
			
			if (cellState == CellStateWall) {
				CGContextSetFillColorWithColor(context, _wallColor.CGColor);
			}
			
			else if (cellState == CellStatePath) {
				if (visited) {
					CGContextSetFillColorWithColor(context, _pathColorVisited.CGColor);
				}
				
				else {
					CGContextSetFillColorWithColor(context, _pathColorUnvisited.CGColor);
				}
			}
			
			else if (cellState == CellStateStart) {
				if (visited) {
					CGContextSetFillColorWithColor(context, _startColorVisited.CGColor);
				}
				
				else {
					CGContextSetFillColorWithColor(context, _startColorUnvisited.CGColor);
				}
			}
			
			else if (cellState == CellStateGoal) {
				if (visited) {
					CGContextSetFillColorWithColor(context, _goalColorVisited.CGColor);
				}
				
				else {
					CGContextSetFillColorWithColor(context, _goalColorUnvisited.CGColor);
				}
			}
			
			CGRect rectangle = CGRectMake(horizontalMargin + col*cellSize, verticalMargin + row*cellSize, cellSize, cellSize);
			CGContextFillRect(context, rectangle);
		}
	}
}

@end
