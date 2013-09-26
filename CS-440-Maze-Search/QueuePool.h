//
//  QueuePool.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueuePool : NSOperationQueue

@property (strong, readonly) NSOperationQueue *mazeParsingOperationQueue;
@property (strong, readonly) NSOperationQueue *algorithmOperationQueue;

+ (QueuePool *)sharedQueuePool;

@end
