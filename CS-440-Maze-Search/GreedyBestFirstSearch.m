//
//  GreedyBestFirstSearch.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GreedyBestFirstSearch.h"
#import "Frontier.h"

@implementation GreedyBestFirstSearch

- (void)main {
	[self greedyBestFirstSearch];
	
	[self didFinish];
}

- (void)greedyBestFirstSearch {
	CGPoint point1 = CGPointMake(1, 1);
	CGPoint point2 = CGPointMake(5, 5);
	CGFloat result1FromBlock = self.costFunctionBlock(point1, point2);
	CGFloat result2FromBlock = self.costFunctionBlock(point1);
}

@end
