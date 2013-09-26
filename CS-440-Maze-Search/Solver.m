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
	
	searchAlgorithmOperation.algorithmCompletionHandler = ^() {
		NSLog(@"finished search algorithm operation");
	};
	
	[_algorithmOperationQueue addOperation:searchAlgorithmOperation];
}

- (void)tookStep {
	[self.delegate tookStep];
}

@end
