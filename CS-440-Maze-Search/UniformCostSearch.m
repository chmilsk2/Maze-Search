//
//  UniformCostSearch.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "UniformCostSearch.h"
#import "Frontier.h"

@implementation UniformCostSearch

- (void)main {
	[self UniformCostSearch];
	
	[self didFinish];
}

- (void)UniformCostSearch {
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
		[cell setVisited:YES];
		
		BOOL goalReached = [cell isEqual:goalCell];
		
		if (goalReached) {
			self.pathCost = cell.costIncurred;
			
			// show the path solution by following the cell's parent chain back to the root
			[self pathSolutionUsingGoalCell:goalCell];
			
			[self.delegate tookStep];
			
			return;
		}
		
		// add cell to explored
		[explored addObject:cell];
		
		// update the number of nodes expandned
		self.numberOfNodesExpanded++;
		
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
				
				// set the cost incurred
				[child setCostIncurred:cell.costIncurred + 1];
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
