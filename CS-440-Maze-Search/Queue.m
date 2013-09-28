//
//  Queue.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "Queue.h"

@implementation Queue {
	NSMutableArray *_queue;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_queue = [NSMutableArray array];
		_count = 0;
	}
	
	return self;
}

- (void)enqueue:(id)obj {
	[_queue addObject:obj];
	_count = _queue.count;
}

- (id)dequeue {
	id obj;
	
	if (_queue.count > 0) {
		obj = [_queue objectAtIndex:0];
		[_queue removeObjectAtIndex:0];
		_count = _queue.count;
	}
	
	return obj;
}

- (void)clear {
	[_queue removeAllObjects];
	_count = 0;
}

@end
