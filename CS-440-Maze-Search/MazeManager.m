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

#define PARSED_MAZE_NOTIFICATON @"Parsed Maze Notification"

@implementation MazeManager {
	NSMutableArray *_parsedMazeNames;
	NSMutableArray *_processingMazeNames;
	NSMutableArray *_mazes;
	NSInteger _parsedMazeCount;
	NSOperationQueue *_mazeParsingQueue;
}

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
		
		_mazes = [NSMutableArray arrayWithCapacity:SupportedMazes().count];
		
		for (NSUInteger i = 0; i < SupportedMazes().count; i++) {
			[_mazes addObject:[NSNull null]];
		}

		_processingMazeNames = [NSMutableArray array];
		_parsedMazeNames = [NSMutableArray array];
		
		_mazeParsingQueue = [QueuePool sharedQueuePool].mazeParsingOperationQueue;
	}
	
	return self;
}

- (Maze *)mazeAtIndex:(NSInteger)index {
	Maze *maze;
	
	NSString *mazeName = [self fileNameForMazeAtIndex:index];
	
	BOOL isParsed = NO;
	
	for (NSString *parsedMazeName in _parsedMazeNames) {
		if ([parsedMazeName isEqualToString:mazeName]) {
			isParsed = YES;
		}
	}
	
	if (!isParsed) {
		BOOL isProcessing = [self isProcessingMazeWithFileName:mazeName];
		
		if (!isProcessing) {
			[self parseMazeWithFileName:mazeName];
		}
	}
	
	// maze exists
	else {
		maze = _mazes[index];
	}
	
	return maze;
}

- (BOOL)isProcessingMazeWithFileName:mazeName {
	BOOL isProcessing = NO;
	
	for (NSString *fileName in _processingMazeNames) {
		if ([fileName isEqualToString:mazeName]) {
			isProcessing = YES;
		}
	}
	
	return isProcessing;
}

- (void)addProcessingMazeName:(NSString *)mazeName {
	[_processingMazeNames addObject:mazeName];
}

- (void)removeProcessingMazeName:(NSString *)mazeName {
	[_processingMazeNames removeObject:mazeName];
}

- (void)addParsedMazeName:(NSString *)mazeName {
	[_parsedMazeNames addObject:mazeName];
}

- (void)didBeginParsing {
	NSLog(@"did begin parsing");
}

- (NSString *)fileNameForMazeAtIndex:(NSUInteger)index {
	NSArray *supportedMazes = SupportedMazes();
	
	NSString *fileName = supportedMazes[index];
	
	return fileName;
}

- (void)didFinishParsingMazeAtIndex:(NSUInteger)index {
	// notify observers that maze has been parsed
	NSDictionary *userInfo = @{@"selectedMazeIndex": [NSNumber numberWithInteger:index]};
	[[NSNotificationCenter defaultCenter] postNotificationName:PARSED_MAZE_NOTIFICATON object:nil userInfo:userInfo];
	
	NSLog(@"did finish parsing");
}

- (void)parseMazeWithFileName:(NSString *)mazeName {
	MazeParsingOperation *mazeParsingOperation = [[MazeParsingOperation alloc] initWithFilename:mazeName];
	
	mazeParsingOperation.mazeParsingCompletionHandler = ^(NSString *name, Maze *newMaze) {
		_parsedMazeCount++;
		
		NSArray *supportedMazes = SupportedMazes();
		
		NSUInteger index = 0;
		
		for (NSUInteger i = 0; i < supportedMazes.count; i++) {
			if ([name isEqualToString:supportedMazes[i]]) {
				index = i;
				break;
			}
		}
		
		[_mazes replaceObjectAtIndex:index withObject:newMaze];
	
		NSLog(@"finished parsing maze #%ld: %@", (long)_parsedMazeCount, name);
		[self removeProcessingMazeName:mazeName];
		[self addParsedMazeName:mazeName];
		[self didFinishParsingMazeAtIndex:index];
	};
	
	[_mazeParsingQueue addOperation:mazeParsingOperation];
	[self didBeginParsing];
	[self addProcessingMazeName:mazeName];
}

@end
