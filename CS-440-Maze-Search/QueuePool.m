//
//  QueuePool.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "QueuePool.h"

#define MAZE_PARSING_OPERATION_QUEUE_NAME @"Maze Parsing Operation Queue"
#define ALGORITHM_OPERATION_QUEUE_NAME @"Algorithm Operation Queue"

@interface QueuePool ()

@property (strong) NSOperationQueue *mazeParsingOperationQueue;
@property (strong) NSOperationQueue *algorithmOperationQueue;

@end

@implementation QueuePool

+ (QueuePool *)sharedQueuePool {
	static QueuePool *sharedQueuePool;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedQueuePool = [[QueuePool alloc] init];
	});
	
	return sharedQueuePool;
}

- (id)init {
	self = [super init];
	
	if (self) {
		self.mazeParsingOperationQueue = [[NSOperationQueue alloc] init];
		[self.mazeParsingOperationQueue setName:MAZE_PARSING_OPERATION_QUEUE_NAME];
		[self.mazeParsingOperationQueue setMaxConcurrentOperationCount:1];
		
		self.algorithmOperationQueue = [[NSOperationQueue alloc] init];
		[self.algorithmOperationQueue setName:ALGORITHM_OPERATION_QUEUE_NAME];
		[self.algorithmOperationQueue setMaxConcurrentOperationCount:1];
		
		[self.mazeParsingOperationQueue addObserver:self forKeyPath:@"operationCount" options:0 context:NULL];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"operationCount"]) {
		NSOperationQueue *operationQueue = (NSOperationQueue *)object;
		
		if ([operationQueue.name isEqualToString:MAZE_PARSING_OPERATION_QUEUE_NAME]) {
			NSLog(@"operations in %@: %lu", MAZE_PARSING_OPERATION_QUEUE_NAME, (unsigned long)[self.mazeParsingOperationQueue operationCount]);
		}
		
		else if ([operationQueue.name isEqualToString:ALGORITHM_OPERATION_QUEUE_NAME]) {
			NSLog(@"operations in %@: %lu", ALGORITHM_OPERATION_QUEUE_NAME, (unsigned long)[self.algorithmOperationQueue operationCount]);
		}
	}
}

@end
