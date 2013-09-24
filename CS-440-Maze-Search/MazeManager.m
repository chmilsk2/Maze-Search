//
//  MazeManager.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeManager.h"
#import "MazeParsingOperation.h"
#import "Maze.h"
#import "QueuePool.h"
#import "SupportedMazes.h"

#define MAZE_PARSING_NOTIFICATION_NAME @"MazeParsingNotification"

@implementation MazeManager {
	NSInteger _parsedMazeCount;
	NSOperationQueue *_mazeParsingQueue;
}

@synthesize mazes = _mazes;

+ (MazeManager *)sharedMazeManager {
	static MazeManager *sharedMazeManager;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedMazeManager = [[MazeManager alloc] init];
	});
	
	return sharedMazeManager;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_parsedMazeCount = 0;
		
		_mazeParsingQueue = [QueuePool sharedQueuePool].mazeParsingOperationQueue;
		[_mazeParsingQueue setMaxConcurrentOperationCount:4];
	}
	
	return self;
}

- (NSArray *)mazes {
	@synchronized(self) {
		if (!_mazes) {
			NSArray *supportedMazes = SupportedMazes();
			NSMutableArray *mazesToAdd = [NSMutableArray array];
		
			for (NSString *supportedMaze in supportedMazes) {
				// create an empty maze with the corresponding maze name
				Maze *maze = [[Maze alloc] initWithName:supportedMaze cells:nil width:nil height:nil];
				[mazesToAdd addObject:maze];
			}
			
			_mazes = [NSArray arrayWithArray:mazesToAdd];
			
			for (Maze *maze in _mazes) {
				// asynchronously parse mazes
				[self parseMazeWithFileName:maze.name];
			}
		}
		
		return _mazes;
	}
}

- (void)setMazes:(NSArray *)mazes {
	@synchronized(self) {
		_mazes = mazes;
	}
}

- (void)parseMazeWithFileName:(NSString *)mazeName {
	MazeParsingOperation *mazeParsingOperation = [[MazeParsingOperation alloc] initWithFilename:mazeName];
	
	mazeParsingOperation.mazeParsingCompletionHandler = ^(NSString *name, Maze *newMaze) {
		_parsedMazeCount++;
		NSLog(@"finished parsing maze #%ld: %@", (long)_parsedMazeCount, name);
		
		NSNumber *updatedMazeIndex;
		NSMutableArray *updatedMazes = [NSMutableArray arrayWithArray:_mazes];
		
		for (NSInteger i = 0; i < updatedMazes.count; i++) {
			Maze *maze = updatedMazes[i];
			
			if ([maze.name isEqualToString:newMaze.name]) {
				updatedMazeIndex = [NSNumber numberWithInteger:i];
				updatedMazes[i] = newMaze;
			}
		}
		
		_mazes = [NSArray arrayWithArray:updatedMazes];
		
		// post notification to inform observers when a maze has been parsed and the mazes updated
		NSDictionary *userInfo = @{@"updatedMazeIndex":updatedMazeIndex,
								   @"mazes": _mazes};
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MazeParsingNotification" object:nil userInfo:userInfo];
	};
	
	[_mazeParsingQueue addOperation:mazeParsingOperation];
}

@end
