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
#import "GreedyBestFirstSearch.h"
#import "AStarSearchOperation.h"
#import "CostFunctions.h"
#import "CostFunctionBlock.h"
#import "SupportedAlgorithmNames.h"

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

- (SearchAlgorithmOperation *)searchAlgorithmOperationForName:(NSString *)name costFunctionName:(NSString *)costFunctionName {
	SearchAlgorithmOperation *algorithmOperation = [_algorithmOperationsDict objectForKey:[NSNumber numberWithInteger:[name hash]]];
	
	if (!algorithmOperation) {
		CostFunctionBlock costFunctionBlock = [CostFunctions costFunctionForName:costFunctionName];
		
		if ([name isEqualToString:DEPTH_FIRST_SEARCH]) {
			algorithmOperation = [[DepthFirstSearchOperation alloc] initWithCostFunctionBlock:costFunctionBlock];
		}
		
		else if ([name isEqualToString:BREADTH_FIRST_SEARCH]) {
			algorithmOperation = [[BreadthFirstSearchOperation alloc] initWithCostFunctionBlock:costFunctionBlock];
		}
		
		else if ([name isEqualToString:GREEDY_BEST_FIRST_SEARCH]) {
			algorithmOperation = [[GreedyBestFirstSearch alloc] initWithCostFunctionBlock:costFunctionBlock];
		}
		
		else if ([name isEqualToString:A_STAR_SEARCH]) {
			algorithmOperation = [[AStarSearchOperation alloc] initWithCostFunctionBlock:costFunctionBlock];
		}
	}
		
	return algorithmOperation;
}

@end
