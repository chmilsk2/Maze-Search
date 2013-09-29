//
//  MazeSearchViewController.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MazeSettingsDelegate.h"
#import "MazeViewDataSource.h"
#import "SolverDelegate.h"

@interface MazeSearchViewController : UIViewController <MazeSettingsDelegate, MazeViewDataSource, SolverDelegate>

@end
