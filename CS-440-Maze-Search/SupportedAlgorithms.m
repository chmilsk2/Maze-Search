//
//  SupportedAlgorithms.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "SupportedAlgorithms.h"

#define DEPTH_FIRST_SEARCH @"Depth-First Search"
#define BREADTH_FIRST_SEARCH @"Breadth-First Search"
#define GREEDY_BEST_FIRST_SEARCH @"Greedy Best-First Search"
#define A_STAR_SEARCH @"A* Search"

NSArray * SupportedAlgorithms() {
	return @[DEPTH_FIRST_SEARCH, BREADTH_FIRST_SEARCH, GREEDY_BEST_FIRST_SEARCH, A_STAR_SEARCH];
}

NSString * AlgorithmNameAtIndex(NSInteger index) {
	NSArray *supportedAlgorithms = SupportedAlgorithms();
	
	return supportedAlgorithms[index];
}


