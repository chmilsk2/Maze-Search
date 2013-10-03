//
//  MazeView.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeView.h"
#import "CellState.h"

#define LABEL_FONT_NAME @"HelveticaNeue-UltraLight"
#define LABEL_FONT_SIZE 20.0f
#define LABEL_VERTICAL_MARGIN 8.0f
#define LABEL_HORIZONTAL_MARGIN 14.0f
#define LABEL_HEIGHT 20.0f
#define MAX_CELL_SIZE 30

#define PATH_COST_LABEL_TEXT @"Path Cost:"
#define NUMBER_OF_NODES_EXPANDED_TEXT @"Number of Nodes Expanded:"
#define MAXIMUM_TREE_DEPTH_SEARCHED_TEXT @"Maximum Tree Depth:"
#define MAXIMUM_FRONTIER_SIZE_TEXT @"Maximum Frontier Size:"

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
	UIColor *_pathColorSolution;
	
	UIFont *_labelFont;
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
		
		_labelFont = [UIFont fontWithName:LABEL_FONT_NAME size:LABEL_FONT_SIZE];
		
		_pathCostLabel = self.pathCostLabel;
		_numberOfNodesExpandedLabel = self.numberOfNodesExpandedLabel;
		_maximumTreeDepthSearchedLabel = self.maximumTreeDepthSearchedLabel;
		_maximumFrontierSizeLabel = self.maximumFrontierSizeLabel;
		
		[self addSubview:_pathCostLabel];
		[self addSubview:_numberOfNodesExpandedLabel];
		[self addSubview:_maximumTreeDepthSearchedLabel];
		[self addSubview:_maximumFrontierSizeLabel];
		
		// start colors
		_startColorUnvisited = [UIColor colorWithRed:51.0/255.0 green:105.0/255.0 blue:232.0/255.0 alpha:1.0];
		_startColorVisited = [UIColor colorWithRed:64.0/255.0 green:153.0/255.0 blue:1.0 alpha:0.6];
		
		// goal colors
		_goalColorUnvisited = [UIColor colorWithRed:0 green:255.0/255.0 blue:0 alpha:1.0];
		_goalColorVisited = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
		
		// wall color
		_wallColor = [UIColor blackColor];
		
		// path colors
		_pathColorUnvisited = self.backgroundColor;
		_pathColorVisited = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
		_pathColorSolution = [UIColor colorWithRed:64.0/255.0 green:153.0/255.0 blue:1.0 alpha:1.0];
    }
	
    return self;
}

- (UILabel *)pathCostLabel {
	if (!_pathCostLabel) {
		_pathCostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_pathCostLabel setFont:_labelFont];
		[_pathCostLabel setText:PATH_COST_LABEL_TEXT];
		[_pathCostLabel setTextAlignment:NSTextAlignmentJustified];
	}
	
	return _pathCostLabel;
}

- (UILabel *)numberOfNodesExpandedLabel {
	if (!_numberOfNodesExpandedLabel) {
		_numberOfNodesExpandedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_numberOfNodesExpandedLabel setFont:_labelFont];
		[_numberOfNodesExpandedLabel setText:NUMBER_OF_NODES_EXPANDED_TEXT];
		[_numberOfNodesExpandedLabel setTextAlignment:NSTextAlignmentJustified];
	}
	
	return _numberOfNodesExpandedLabel;
}

- (UILabel *)maximumTreeDepthSearchedLabel {
	if (!_maximumTreeDepthSearchedLabel) {
		_maximumTreeDepthSearchedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_maximumTreeDepthSearchedLabel setFont:_labelFont];
		[_maximumTreeDepthSearchedLabel setText:MAXIMUM_TREE_DEPTH_SEARCHED_TEXT];
		[_maximumTreeDepthSearchedLabel setTextAlignment:NSTextAlignmentJustified];
	}
	
	return _maximumTreeDepthSearchedLabel;
}

- (UILabel *)maximumFrontierSizeLabel {
	if (!_maximumFrontierSizeLabel) {
		_maximumFrontierSizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_maximumFrontierSizeLabel setFont:_labelFont];
		[_maximumFrontierSizeLabel setText:MAXIMUM_FRONTIER_SIZE_TEXT];
		[_maximumFrontierSizeLabel setTextAlignment:NSTextAlignmentJustified];
	}
	
	return _maximumFrontierSizeLabel;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat width = self.bounds.size.width;
	CGFloat y = LABEL_VERTICAL_MARGIN + [self.dataSource verticalMarginForTopMostLabel];
	
	NSArray *statisticsLabels = @[_pathCostLabel, _numberOfNodesExpandedLabel, _maximumTreeDepthSearchedLabel, _maximumFrontierSizeLabel];
	
	for (UILabel *statisticsLabel in statisticsLabels) {
		[statisticsLabel setFrame:CGRectMake(LABEL_HORIZONTAL_MARGIN, y, width - 2*LABEL_HORIZONTAL_MARGIN, LABEL_HEIGHT)];
		y += LABEL_VERTICAL_MARGIN + LABEL_HEIGHT;
	}
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
	
	if (cellSize > MAX_CELL_SIZE) {
		cellSize = cellSize/2;
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
				BOOL isOnSolutionPath = [self.dataSource isOnSolutionPathForRow:row col:col];
				
				if (visited) {
					if (isOnSolutionPath) {
						CGContextSetFillColorWithColor(context, _pathColorSolution.CGColor);
					}
					
					else {
						CGContextSetFillColorWithColor(context, _pathColorVisited.CGColor);
					}
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
