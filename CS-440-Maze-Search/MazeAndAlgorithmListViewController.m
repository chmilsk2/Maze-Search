//
//  MazeAndAlgorithmListViewController.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeAndAlgorithmListViewController.h"
#import "MazeManager.h"
#import "Maze.h"
#import "SupportedMazes.h"
#import "SupportedAlgorithms.h"

#define MAZE_AND_ALGORITHM_LIST_NAV_TITLE @"Maze and Algorithm"
#define MAZE_LIST_SECTION_HEADER @"Maze"
#define ALGORITHM_LIST_SECTION_HEADER @"Algorithm"
#define NUMBER_OF_SECTIONS 2
#define MazeAndAlgorithmListCellIdentifier @"MazeAndAlgorithmListCell"

@interface MazeAndAlgorithmListViewController ()

@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation MazeAndAlgorithmListViewController {
	NSUInteger _selectedMazeIndex;
	NSUInteger _selectedAlgorithmIndex;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		_selectedMazeIndex = 0;
		_selectedAlgorithmIndex = 0;
    }
	 
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MazeAndAlgorithmListCellIdentifier];
	
	[self setUpNavigation];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Navigation

- (void)setUpNavigation {
	[self.navigationItem setTitle:MAZE_AND_ALGORITHM_LIST_NAV_TITLE];
	
	self.navigationItem.leftBarButtonItem = self.cancelButton;
	self.navigationItem.rightBarButtonItem = self.doneButton;
}

#pragma mark - Cancel Button

- (UIBarButtonItem *)cancelButton {
	if (!_cancelButton) {
		_cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																	  target:self
																	  action:@selector(cancel)];
	}
	
	return _cancelButton;
}

#pragma mark - Done Button 

- (UIBarButtonItem *)doneButton {
	if (!_doneButton) {
		_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																	  target:self
																	  action:@selector(done)];
	}
	
	return _doneButton;
}


#pragma mark - Cancel

- (void)cancel {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Done

- (void)done {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	
	// notify delegate
	[self.delegate didSelectMazeAtIndex:_selectedMazeIndex algorithmIndex:_selectedAlgorithmIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSUInteger numberOfRowsInSection = 0;
	
	switch (section) {
		case ListSectionMaze:
			numberOfRowsInSection = SupportedMazes().count;
			break;
			
		case ListSectionAlgorithm:
			numberOfRowsInSection = SupportedAlgorithms().count;
			break;
			
		default:
			break;
	}
	
    return numberOfRowsInSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionHeader = 0;
	
	switch (section) {
		case ListSectionMaze:
			sectionHeader = MAZE_LIST_SECTION_HEADER;
			break;
			
		case ListSectionAlgorithm:
			sectionHeader = ALGORITHM_LIST_SECTION_HEADER;
			break;
			
		default:
			break;
	}
	
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MazeAndAlgorithmListCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	
	NSString *cellLabelText;

	switch (indexPath.section) {
		case ListSectionMaze:
			if (indexPath.row == _selectedMazeIndex) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			
			else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			cellLabelText = SupportedMazes()[indexPath.row];
			break;
			
		case ListSectionAlgorithm:
			if (indexPath.row == _selectedAlgorithmIndex) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			
			else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			cellLabelText = SupportedAlgorithms()[indexPath.row];
			break;
			
		default:
			break;
	}
	
	[cell.textLabel setText:cellLabelText];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case ListSectionMaze:
			_selectedMazeIndex = indexPath.row;
			break;
			
		case ListSectionAlgorithm:
			_selectedAlgorithmIndex = indexPath.row;
			break;
			
		default:
			break;
	}
	
	[tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
