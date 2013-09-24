//
//  SearchWithMultipleDotsViewController.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "SearchWithMultipleDotsViewController.h"
#import "MazeManager.h"

#define TAB_TITLE @"1.3"
#define MAZE_PARSING_NOTIFICATION_NAME @"MazeParsingNotification"

@interface SearchWithMultipleDotsViewController ()

@end

@implementation SearchWithMultipleDotsViewController {
	NSArray *_mazes;
}

- (id)init {
	self = [super init];
	
	if (self) {
		// observe for maze parsing notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedMazes:) name:MAZE_PARSING_NOTIFICATION_NAME object:nil];
		
		_mazes = [MazeManager sharedMazeManager].mazes;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self.view setBackgroundColor:[UIColor grayColor]];
}

#pragma mark - Updated Mazes Notification

- (void)updatedMazes:(NSNotification *)notification {
	NSNumber *updatedMazeIndex = [notification.userInfo objectForKey:@"updatedMazeIndex"];
	// all entries in the list view should start off grayed out and remain untappable until the notification is received
	_mazes = [notification.userInfo objectForKey:@"mazes"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
