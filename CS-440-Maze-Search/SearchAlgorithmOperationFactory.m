//
//  SearchAlgorithmOperationFactory.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "SearchAlgorithmOperationFactory.h"
#import "SearchAlgorithmOperation.h"
#import "DepthFirstSearchOperation.h"
#import "BreadthFirstSearchOperation.h"

#define DEPTH_FIRST_SEARCH @"Depth-First Search"
#define BREADTH_FIRST_SEARCH @"Breadth-First Search"
#define GREEDY_BEST_FIRST_SEARCH @"Greedy Best-First Search"
#define A_STAR_SEARCH @"A* Search"

@implementation SearchAlgorithmOperationFactory {
	NSMutableDictionary *_algorithmOperationsDict;
}

+ (SearchAlgorithmOperationFactory *)searchAlgorithmOperationFactory {
	static SearchAlgorithmOperationFactory *searchAlgorithmOperationFactory;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		searchAlgorithmOperationFactory = [[SearchAlgorithmOperationFactory alloc] init];
	});
	
	return searchAlgorithmOperationFactory;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_algorithmOperationsDict = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (SearchAlgorithmOperation *)searchAlgorithmOperationForName:(NSString *)name {
	SearchAlgorithmOperation *algorithmOperation = [_algorithmOperationsDict objectForKey:[NSNumber numberWithInteger:[name hash]]];
	
	if (!algorithmOperation) {
		if ([name isEqualToString:DEPTH_FIRST_SEARCH]) {
			algorithmOperation = [[DepthFirstSearchOperation alloc] init];
		}
		
		else if ([name isEqualToString:BREADTH_FIRST_SEARCH]) {
			algorithmOperation = [[BreadthFirstSearchOperation alloc] init];
		}
		
		else if ([name isEqualToString:GREEDY_BEST_FIRST_SEARCH]) {

		}
		
		else if ([name isEqualToString:A_STAR_SEARCH]) {
			
		}
	}
		
	return algorithmOperation;
}

@end
