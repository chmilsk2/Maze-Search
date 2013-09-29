//
//  Frontier.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "Frontier.h"
#import "Cell.h"

@implementation Frontier {
	NSMutableOrderedSet *_frontier;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_frontier = [NSMutableOrderedSet orderedSet];
		_count = _frontier.count;
	}
	
	return self;
}

#pragma mark - Queue/Stack Enqueue

- (void)enqueueObject:(id)obj {
	[_frontier addObject:obj];
	_count = _frontier.count;
}

#pragma mark - Queue Dequeue

- (id)dequeueFirstObject {
	id obj;
	
	if (_frontier.count > 0) {
		NSUInteger index = 0;
		
		obj = [_frontier objectAtIndex:index];
		[_frontier removeObjectAtIndex:index];
		_count = _frontier.count;
	}
	
	return obj;
}

#pragma mark - Stack Dequeue

- (id)dequeueLastObject {
	id obj;
	
	if (_frontier.count > 0) {
		NSUInteger index = _frontier.count - 1;
		
		obj = [_frontier objectAtIndex:index];
		[_frontier removeObjectAtIndex:index];
		_count = _frontier.count;
	}
	
	return obj;
}

#pragma mark - Priority Queue Dequeue

- (id)dequeueObjectWithLowestCostForBlock:(CostFunctionBlock)costFunction goalPoint:(CGPoint)goalPoint {
	__block CGFloat lowestCost = CGFLOAT_MAX;
	__block id lowestCostObj;

	[_frontier enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		CGFloat cost = costFunction(((Cell *)obj).coordinate, goalPoint);
		
		if (cost < lowestCost) {
			lowestCost = cost;
			lowestCostObj = obj;
		}
	}];
	
	[_frontier removeObject:lowestCostObj];
	
	return lowestCostObj;
}

- (void)clear {
	[_frontier removeAllObjects];
	_count = _frontier.count;
}

#pragma mark - Contains Object

- (BOOL)containsObject:(id)obj {
	BOOL containsObject = NO;
	
	if ([_frontier containsObject:obj]) {
		containsObject = YES;
	}
	
	return containsObject;
}

@end
