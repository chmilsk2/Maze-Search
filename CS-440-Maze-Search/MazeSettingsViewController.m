//
//  MazeSettingsViewController.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MazeSettingsViewController.h"
#import "MazeManager.h"
#import "Maze.h"
#import "SupportedMazes.h"
#import "SupportedAlgorithms.h"
#import "CostFunctions.h"

#define NUMBER_OF_SECTIONS 3
#define MAZE_AND_ALGORITHM_LIST_NAV_TITLE @"Settings"
#define MAZE_SECTION_HEADER @"Maze"
#define ALGORITHM_SECTION_HEADER @"Algorithm"
#define COST_FUNCTION_SECTION_HEADER @"Cost Function: f(n)=g(n)+h(n)"
#define MazeSettingsCellIdentifier @"MazeSettingsCell"
#define INVISIBLE_FOOTER_HEIGHT .01f

@interface MazeSettingsViewController ()

@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation MazeSettingsViewController {
	NSUInteger _selectedMazeIndex;
	NSUInteger _selectedAlgorithmIndex;
	NSUInteger _selectedCostFunctionIndex;
	NSArray *_costFunctionNamesForSelectedAlgorithm;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		_selectedMazeIndex = 0;
		_selectedAlgorithmIndex = 0;
		_selectedCostFunctionIndex = 0;
		_costFunctionNamesForSelectedAlgorithm = [NSArray array];
    }
	 
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MazeSettingsCellIdentifier];
	
	[self setUpNavigation];
	[self showCostFunctionListForAlgorithmAtIndexPath:[NSIndexPath indexPathForRow:_selectedAlgorithmIndex inSection:ListSectionCostFunction]];

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
	[self.delegate didSelectMazeAtIndex:_selectedMazeIndex algorithmIndex:_selectedAlgorithmIndex costFunctionIndex:_selectedCostFunctionIndex];
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
			
		case ListSectionCostFunction:
			numberOfRowsInSection = _costFunctionNamesForSelectedAlgorithm.count;
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
			sectionHeader = MAZE_SECTION_HEADER;
			break;
			
		case ListSectionAlgorithm:
			sectionHeader = ALGORITHM_SECTION_HEADER;
			break;
			
		case ListSectionCostFunction:
			sectionHeader = COST_FUNCTION_SECTION_HEADER;
			
		default:
			break;
	}
	
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MazeSettingsCellIdentifier forIndexPath:indexPath];
    
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
			
			cellLabelText = SupportedMazeNames()[indexPath.row];
			
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
			
		case ListSectionCostFunction:
			if (indexPath.row == _selectedCostFunctionIndex) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			
			else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			cellLabelText = _costFunctionNamesForSelectedAlgorithm[indexPath.row];
			
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
			[self showCostFunctionListForAlgorithmAtIndexPath:indexPath];
			_selectedAlgorithmIndex = indexPath.row;
			
			break;
			
		case ListSectionCostFunction:
			_selectedCostFunctionIndex = indexPath.row;
			
		default:
			break;
	}
	
	[tableView reloadData];
}

#pragma mark - Cost Function List

- (void)showCostFunctionListForAlgorithmAtIndexPath:(NSIndexPath *)indexPath {
	// remove cells for previously selected algorithm
	
	NSString *algorithmName = AlgorithmNameAtIndex(indexPath.row);
	
	NSArray *newCostFunctions = [CostFunctions costFunctionNamesForAlgorithmName:algorithmName];
	
	if (_costFunctionNamesForSelectedAlgorithm.count > newCostFunctions.count) {
		// check to see if there are any rows that need to be removed
		NSMutableArray *indexPathsForCellsToRemove = [NSMutableArray array];
		
		for (NSUInteger i = 0; i < _costFunctionNamesForSelectedAlgorithm.count; i++) {
			BOOL isMatch = NO;
			
			for (NSUInteger j = 0; j < newCostFunctions.count; j++) {
				if ([_costFunctionNamesForSelectedAlgorithm[i] isEqualToString:newCostFunctions[j]]) {
					isMatch = YES;
				}
			}
			
			if (!isMatch && i >= newCostFunctions.count) {
				[indexPathsForCellsToRemove addObject:[NSIndexPath indexPathForRow:i inSection:ListSectionCostFunction]];
			}
		}
		
		_costFunctionNamesForSelectedAlgorithm = newCostFunctions;
		
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:indexPathsForCellsToRemove withRowAnimation:UITableViewRowAnimationNone];
		[self.tableView endUpdates];
	}
	
	else if (_costFunctionNamesForSelectedAlgorithm.count < newCostFunctions.count) {
		// check to see if there are any row that need to be inserted
		NSMutableArray *indexPathsForCellsToAdd = [NSMutableArray array];
		
		for (NSUInteger i = 0; i < newCostFunctions.count; i++) {
			BOOL isMatch = NO;
			
			for (NSUInteger j = 0; j < _costFunctionNamesForSelectedAlgorithm.count; j++) {
				if ([newCostFunctions[i] isEqualToString:_costFunctionNamesForSelectedAlgorithm[j]]) {
					isMatch = YES;
				}
			}
			
			if (!isMatch && i >= _costFunctionNamesForSelectedAlgorithm.count) {
				[indexPathsForCellsToAdd addObject:[NSIndexPath indexPathForRow:i inSection:ListSectionCostFunction]];
			}
		}
		
		_costFunctionNamesForSelectedAlgorithm = newCostFunctions;
				 
		[self.tableView beginUpdates];
		[self.tableView insertRowsAtIndexPaths:indexPathsForCellsToAdd withRowAnimation:UITableViewRowAnimationNone];
		[self.tableView endUpdates];
	}
	
	else if (_costFunctionNamesForSelectedAlgorithm.count == newCostFunctions.count) {
		_costFunctionNamesForSelectedAlgorithm = newCostFunctions;
		[self.tableView reloadData];
	}
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
