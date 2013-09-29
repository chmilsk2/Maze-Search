//
//  MazeSettingsDelegate.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MazeSettingsDelegate <NSObject>

- (void)didSelectMazeAtIndex:(NSUInteger)selectedMazeIndex algorithmIndex:(NSUInteger)selectedAlgorithmIndex;

@end
