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

- (id)init {
	self = [super init];
	
	if (self) {
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

- (void)pathSolutionUsingGoalCell:(Cell *)goalCell {
	// follow the parent path all the way back to the starting cell whose parent is nil	
	Cell *cell = goalCell;
	
	while (cell.parent) {
		cell = cell.parent;
		cell.isOnSolutionPath = YES;
	}
}


- (void)didFinish {
	if (self.algorithmCompletionHandler) {
		self.algorithmCompletionHandler(_pathCost, _numberOfNodesExpanded, _maximumTreeDepthSearched, _maximumFrontierSize);
	}
}

@end
