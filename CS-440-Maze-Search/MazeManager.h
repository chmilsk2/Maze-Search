//
//  MazeManager.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MazeManager : NSObject

@property NSArray *mazes;

+ (MazeManager *)sharedMazeManager;

@end
