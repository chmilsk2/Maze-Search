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

- (void)main {
	// no-op
}

- (void)didFinish {
	if (self.algorithmCompletionHandler) {
		self.algorithmCompletionHandler();
	}
}

@end
