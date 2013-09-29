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
	
	self.maximumFrontierSize = frontier.count;
	
	while (frontier.count) {
		// choose the cell with the lowest path cost
		Cell *cell = [frontier dequeueObjectWithLowestCostForBlock:self.costFunctionBlock goalPoint:goalCell.coordinate];
		
		BOOL goalReached = [cell isEqual:goalCell];
		
		// add cell to explored
		[explored addObject:cell];
		[cell setVisited:YES];
		
		// update the number of nodes expandned
		self.numberOfNodesExpanded++;
		
		if (goalReached) {
			self.pathCost = [self pathCostForGoalCell:goalCell];
			[self.delegate tookStep];
			
			return;
		}
		
		[self.delegate tookStep];
		
		// look at the child cells
		NSArray *children = [self.maze childrenForParent:cell];
		
		for (Cell *child in children) {
			// if not in explored or frontier
			if (![explored containsObject:child] && ![frontier containsObject:child]) {
				[frontier enqueueObject:child];
				// update the maximum frontier size
				if (frontier.count > self.maximumFrontierSize) {
					self.maximumFrontierSize = frontier.count;
				}
				
				// set the child's parent
				[child setParent:cell];
			}
			
			// update the depth
			[child setDepth:cell.depth + 1];
			
			if (child.depth > self.maximumTreeDepthSearched) {
				self.maximumTreeDepthSearched = child.depth;
			}
		}
	}
	
	// frontier is empty, no goal found, return failure
	return;
}

@end
