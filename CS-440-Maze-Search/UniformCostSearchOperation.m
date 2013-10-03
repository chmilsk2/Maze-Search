//
//  UniformCostSearchOperation.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "UniformCostSearchOperation.h"
#import "Frontier.h"
#import "SupportedMazes.h"

@interface UniformCostSearchOperation ()

@property NSMutableArray *multiGoaledPath;
@property (copy) CostFunctionBlock costFunctionBlock;

@end

@implementation UniformCostSearchOperation {
	NSMutableArray *_mutliGoals;
}

- (id)initWithCostFunctionBlock:(CostFunctionBlock)costFunctionBlock {
	self = [super init];
	
	if (self) {
		_multiGoaledPath = [NSMutableArray array];
		_costFunctionBlock = costFunctionBlock;
	}
	
	return self;
}

- (void)main {
	
	// perform suboptimal search using A* and manhattan distance for 1.4
	if ([self.maze.name isEqualToString:SUPPORTED_MAZE_MEDIUM_SEARCH_FILENAME] || [self.maze.name isEqualToString:SUPPORTED_MAZE_BIG_SEARCH_FILENAME] ) {
		Cell *startingCell = self.maze.startingCell;
		
		// while there are still goal cells in the maze
		while (self.maze.goalCells.count) {
			// need to have the updated starting cell here
			
			Cell *goal = [self findClosestGoalToStart:startingCell];
			[self.maze.goalCells removeObject:goal];
			
			Maze *copyMaze = [[Maze alloc] initWithMaze:self.maze];
			
			[copyMaze removeStartingCell];
			[copyMaze removeAllTheGoals];
			[copyMaze addStartingCell:startingCell];
			[copyMaze addGoal:goal];
			
			[self uniformCostSearchForMaze:copyMaze];
			
			startingCell = goal;
		}
		
		[self.maze setIsOnSolutionPathForMultiGoaledPath:_multiGoaledPath];
		[self.delegate tookStep];
	}
	
	else {
		[self uniformCostSearchForMaze:self.maze];
	}
	
	[self didFinish];
}

- (Cell *)findClosestGoalToStart:(Cell *)start {
	CGFloat lowestCost = CGFLOAT_MAX;
	Cell *goal = nil;
	
	for (Cell *cell in self.maze.goalCells) {
		CGFloat cost = self.costFunctionBlock(start.coordinate, cell.coordinate, 0);
		
		if (cost < lowestCost) {
			goal = cell;
			lowestCost = cost;
		}
	}
	
	return goal;
}

- (void)uniformCostSearchForMaze:(Maze *)maze {
	// use a priority queue	
	Cell *startingCell = maze.startingCell;
	Cell *goalCell = maze.goalCell;
	
	if ([startingCell isEqual:goalCell]) {
		// goal reached
		[self.maze setVisitedForCell:startingCell];
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
		
		[self.maze setVisitedForCell:cell];
		
		BOOL goalReached = [cell isEqual:goalCell];
		
		if (goalReached) {
			self.pathCost += cell.costIncurred;
			
			// show the path solution by following the cell's parent chain back to the root
			NSMutableArray *path = [self pathSolutionUsingGoalCell:goalCell];
			
			[_multiGoaledPath addObjectsFromArray:path];
			
			[self.delegate tookStep];
			
			return;
		}
		
		// add cell to explored
		[explored addObject:cell];
		
		// update the number of nodes expandned
		self.numberOfNodesExpanded++;
		
		[self.delegate tookStep];
		
		// look at the child cells
		NSArray *children = [maze childrenForParent:cell];
		
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
