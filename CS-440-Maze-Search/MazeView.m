//
//  MazeView.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeView.h"

@implementation MazeView {
	NSMutableArray *_cellLayers;
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
	
	CGFloat boardWidth;
	CGFloat boardHeight;
	
	CGFloat cellWidth;
	CGFloat cellHeight;
	
	CGFloat widthMultiplier;
	CGFloat heightMultiplier;
	
	cellWidth = floor(width / numberOfCols);
	cellHeight = floor(height / numberOfRows);
	
	widthMultiplier = numberOfCols;
	heightMultiplier = numberOfRows;

	
	if ((NSInteger)cellWidth % 2) {
		cellWidth -= 1;
	}
	
	if ((NSInteger)cellHeight % 2) {
		cellHeight -= 1;
	}
	
	boardWidth = cellWidth * widthMultiplier;
	boardHeight = cellHeight * heightMultiplier;
	
	NSUInteger horizontalMargin = [self.dataSource horizontalMarginForBoardWidth:boardWidth];
	NSUInteger verticalMargin = [self.dataSource verticalMarginForBoardHeight:boardHeight];
	
	for (NSInteger row = 0; row < numberOfRows; row++) {
		for (NSInteger col = 0; col < numberOfCols; col++) {
			
			NSUInteger cellState = [self.dataSource stateForRow:row col:col];
			
			if (cellState == MazeViewCellStateWall) {
				CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
			}
			
			else if (cellState == MazeViewCellStatePath) {
				CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0);
			}
			
			else if (cellState == MazeViewCellStateStart) {
				CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
			}
			
			else if (cellState == MazeViewCellStateGoal) {
				CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
			}
			
			CGRect rectangle = CGRectMake(horizontalMargin + col * cellWidth, verticalMargin + row * cellHeight, cellWidth, cellHeight);
			CGContextFillRect(context, rectangle);
		}
	}
}

@end
