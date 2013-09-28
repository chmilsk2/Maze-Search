//
//  BreadthFirstSearchOperation.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "BreadthFirstSearchOperation.h"
#import "Queue.h"

@implementation BreadthFirstSearchOperation

- (void)main {
	NSLog(@"perform breadth first search here");
	
	[self breadthFirstSearch];
	
	[self didFinish];
}

- (void)breadthFirstSearch {
	Cell *startingCell = self.maze.startingCell;
	Cell *goalCell = self.maze.goalCell;
	
	NSUInteger startingCol = startingCell.coordinate.x;
	NSUInteger startingRow = startingCell.coordinate.y;
	
	NSUInteger goalCol = goalCell.coordinate.x;
	NSUInteger goalRow = goalCell.coordinate.y;
	
	if (startingCell == goalCell) {
		// goal has been reached
	}
	
	Queue *frontier = [[Queue alloc] init];
	NSMutableDictionary *explored = [NSMutableDictionary dictionary];
	
	// add the starting cell to the frontier
	[frontier enqueue:startingCell];
	
	// if empty, return failure
	if (!frontier.count) {
		// failure
	}
	
	// choose the shallowest cell in the frontier
	Cell *cell = [frontier dequeue];
	
	// add cell to explored
	[explored setObject:cell forKey:[NSNumber numberWithInteger:cell.hash]];
	
}

@end
