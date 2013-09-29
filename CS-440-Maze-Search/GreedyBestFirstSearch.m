//
//  GreedyBestFirstSearch.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GreedyBestFirstSearch.h"
#import "Frontier.h"

@implementation GreedyBestFirstSearch

- (void)main {
	[self greedyBestFirstSearch];
	
	[self didFinish];
}

- (void)greedyBestFirstSearch {
	// use a priority queue
	
	Cell *startingCell = self.maze.startingCell;
	Cell *goalCell = self.maze.goalCell;
	
	if ([startingCell isEqual:goalCell]) {
		// goal reached
		[startingCell setVisited:YES];
		[self.delegate tookStep];
		return;
	}
	
	Frontier *frontier = [[Frontier alloc] init];
	NSMutableSet *explored = [NSMutableSet set];
	
	// add the starting cell to the frontier
	[frontier enqueueObject:startingCell];
	
	while (frontier.count) {
		// bfs uses a queue
		// choose the shallowest cell in the frontier
		Cell *cell = [frontier dequeueObjectWithLowestCostForBlock:self.costFunctionBlock goalPoint:goalCell.coordinate];
		
		BOOL goalReached = [cell isEqual:goalCell];
		
		// add cell to explored
		[explored addObject:cell];
		[cell setVisited:YES];
		
		[self.delegate tookStep];
		
		if (goalReached) {
			return;
		}
		
		// look at the child cells
		NSArray *children = [self.maze childrenForParent:cell];
		
		for (Cell *child in children) {
			// if not in explored or frontier
			if (![explored containsObject:child] && ![frontier containsObject:child]) {
				[frontier enqueueObject:child];
			}
		}
	}
	
	// frontier is empty, no goal found, return failure
	return;
}

@end
