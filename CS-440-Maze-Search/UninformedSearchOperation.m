//
//  UninformedSearchOperation.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/29/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "UninformedSearchOperation.h"
#import "Frontier.h"

@implementation UninformedSearchOperation {
	BOOL _isQueue;
}

- (id)initWithFrontierTypeIsQueue:(BOOL)isQueue {
	self = [super init];
	
	if (self) {
		_isQueue = isQueue;
	}
	
	return self;
}

- (void)main {
	[self depthFirstSearch];
	
	[self didFinish];
}

- (void)depthFirstSearch {
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
		Cell *cell;
		
		if (_isQueue) {
			// bfs uses a queue
			// dequeue shallowest unexpanded node
			cell = [frontier dequeueFirstObject];
		}
		
		else {
			// dfs uses a stack
			// dequeue the deepest unexpanded noded
			cell = [frontier dequeueLastObject];
		}
		
		[explored addObject:cell];
		[cell setVisited:YES];
		
		BOOL goalReached = [cell isEqual:goalCell];
		
		if (goalReached) {
			self.pathCost = cell.costIncurred;
			
			// show the path solution by following the cell's parent chain back to the root
			[self pathSolutionUsingGoalCell:goalCell];
			[self.delegate tookStep];
			
			return;
		}
		
		[self.delegate tookStep];
		// add cell to explored
		
		// update the number of nodes expandned
		self.numberOfNodesExpanded++;
		
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

//- (void)uninformedSearchOperationMultiGoaled {
//	// maintain an array of the possible leaves for solution path
//	// this can be done by keeping track of the leaf multiCells that will retrieve a possible path when climbing the parent chain back to the root
//	// this array will be traversed once all of the nodes have been fully expanded
//	NSMutableArray *possibleLeavesForSolutionPath = [NSMutableArray array];
//	
//	// check if start state is the goal
//	Cell *startingCell = self.maze.startingCell;
//	
//	// create a new multiCell for the starting cell
//	// it should be initialized with the maze's list of overall goalcells
//	// note that the maze's overall goal cells should not be modified
//	MultiCell *multiCell = [[MultiCell alloc] initWithState:startingCell.state coordinate:startingCell.coordinate goalCells:self.maze.goalCells];
//	
//	Frontier *frontier = [[Frontier alloc] init];
//	NSMutableArray *explored = [NSMutableArray array];
//	
//	[frontier enqueueObject:multiCell];
//	
//	while (frontier.count) {
//		MultiCell *multiCell;
//		
//		if (_isQueue) {
//			// bfs uses a queue
//			multiCell = [frontier dequeueFirstObject];
//		}
//		
//		else {
//			// dfs uses a stack
//			multiCell = [frontier dequeueLastObject];
//		}
//		
//		NSMutableArray *goalCells = [NSMutableArray arrayWithArray:multiCell.goalCells];
//		
//		if ([self.maze isGoalCell:multiCell]) {
//			Cell *goalCellToRemove = [[Cell alloc] initWithState:multiCell.state coordinate:multiCell.coordinate];
//			
//			goalCellToRemove = [self cellToRemove:goalCellToRemove fromGoalCells:goalCells];
//			[goalCells removeObject:goalCellToRemove];
//			
//			if (!goalCells.count) {
//				// a potential solution leaf node has been found
//				// add the node to the possible leaves for solution path array
//				// all of these possible leaves need to be examinded after the search to find the shortest path and then draw it
//				[possibleLeavesForSolutionPath addObject:multiCell];
//			}
//		}
//		
//		[explored addObject:multiCell];
//		
//		NSArray *children = [self.maze childrenForParent:[[Cell alloc] initWithState:multiCell.state coordinate:multiCell.coordinate]];
//		
//		for (Cell *child in children) {
//			// create a new multiCell to represent each child
//			// child should be intialized with the parent's goal cells, if a goal has been hit the child is initialized with a copy of the parent's goal cells minus the goal cell hit
//			MultiCell *multiChild = [[MultiCell alloc] initWithState:child.state coordinate:child.coordinate goalCells:goalCells];
//			
//			// if not in explored or frontier
//			if(![self doesMultiCell:multiChild haveMatchInExplored:explored] && ![frontier doesMultiCellHaveMatchInFrontier:multiChild]) {
//				[frontier enqueueObject:multiChild];
//				[multiChild setParent:multiCell];
//			}
//		}
//	}
//	
//	NSMutableArray *shortestPath = [self shortestPathForPossibleLeavesForSolutionPath:possibleLeavesForSolutionPath];
//}
//
//- (NSMutableArray *)shortestPathForPossibleLeavesForSolutionPath:(NSMutableArray *)possibleLeavesForSolutionPath {
//	NSMutableArray *shortestPath = [NSMutableArray array];
//	MultiCell *shortestLeaf;
//	NSUInteger shortestPathLength = NSUIntegerMax;
//	
//	for (MultiCell *possibleLeaf in possibleLeavesForSolutionPath) {
//		MultiCell *multiCell = possibleLeaf;
//		NSUInteger pathLength = 0;
//		while (multiCell) {
//			multiCell = multiCell.parent;
//			pathLength++;
//		}
//		
//		if (pathLength < shortestPathLength) {
//			shortestLeaf = possibleLeaf;
//			shortestPathLength = pathLength;
//		}
//	}
//	
//	MultiCell *multiCell = shortestLeaf;
//	
//	while (multiCell) {
//		multiCell = multiCell.parent;
//		[shortestPath addObject:multiCell];
//	}
//	
//	return shortestPath;
//}

@end
