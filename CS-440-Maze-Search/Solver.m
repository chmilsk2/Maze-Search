//
//  Solver.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "Solver.h"
#import "QueuePool.h"
#import "SearchAlgorithmOperation.h"

#define ALGORITHM_WAITING_INTERVAL .2

@implementation Solver {
	NSOperationQueue *_algorithmOperationQueue;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_algorithmOperationQueue = [QueuePool sharedQueuePool].algorithmOperationQueue;
	}
	
	return self;
}

- (void)solveWithMaze:(Maze *)maze algorithmOperation:(SearchAlgorithmOperation *)searchAlgorithmOperation {
	[searchAlgorithmOperation setDelegate:self];
	[searchAlgorithmOperation setMaze:maze];
	
	searchAlgorithmOperation.algorithmCompletionHandler = ^(NSUInteger pathCost, NSUInteger numberOfNodesExpanded, NSUInteger maximumTreeDepthSearched, NSUInteger maximumFrontierSize) {
		NSLog(@"finished search algorithm operation");
		
		if (self.solverCompletionHandler) {
			self.solverCompletionHandler(pathCost, numberOfNodesExpanded, maximumTreeDepthSearched, maximumFrontierSize);
		}
	};
	
	[_algorithmOperationQueue addOperation:searchAlgorithmOperation];
}

- (void)tookStep {
	[self.delegate tookStep];
	
	[NSThread sleepForTimeInterval:ALGORITHM_WAITING_INTERVAL];
}

@end
