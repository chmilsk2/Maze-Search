//
//  SearchAlgorithmOperation.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "SearchAlgorithmOperation_Protected.h"
#import "Maze.h"

@implementation SearchAlgorithmOperation

- (id)initWithCostFunctionBlock:(CostFunctionBlock)costFunctionBlock {
	self = [super init];
	
	if (self) {
		_costFunctionBlock = costFunctionBlock;
		
		_pathCost = 0;
		_numberOfNodesExpanded = 0;
		_maximumTreeDepthSearched = 0;
		_maximumFrontierSize = 0;
	}
	
	return self;
}

- (void)main {
	// no-op
}

- (NSUInteger)pathCostForGoalCell:(Cell *)goalCell {
	// follow the parent path all the way back to the starting cell whose parent is nil
	NSUInteger pathCost = 0;
	
	Cell *cell = goalCell;
	
	while (cell.parent) {
		cell = cell.parent;
		cell.isOnSolutionPath = YES;
		pathCost++;
	}
	
	return pathCost;
}

- (void)didFinish {
	if (self.algorithmCompletionHandler) {
		self.algorithmCompletionHandler(_pathCost, _numberOfNodesExpanded, _maximumTreeDepthSearched, _maximumFrontierSize);
	}
}

@end
