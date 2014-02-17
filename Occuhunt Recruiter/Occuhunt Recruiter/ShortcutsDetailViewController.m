//
//  ShortcutsDetailViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "ShortcutsDetailViewController.h"

@interface ShortcutsDetailViewController ()

@end

@implementation ShortcutsDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView setAllowsSelection:NO];
    
    saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveShortcut)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Create a shortcut for entering phrases while writing notes.";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Phrase";
        cell.detailTextLabel.hidden = YES;
        phraseTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 4, 410, 36)];
        [cell.contentView addSubview:phraseTextField];
        phraseTextField.textAlignment = NSTextAlignmentRight;
        phraseTextField.delegate = self;
        if (self.phrase) {
            phraseTextField.text = self.phrase;
            
        }
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Shortcut";
        cell.detailTextLabel.hidden = YES;
        shortcutTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 4, 410, 36)];
        [cell.contentView addSubview:shortcutTextField];
        shortcutTextField.textAlignment = NSTextAlignmentRight;
        shortcutTextField.delegate = self;
        if (self.shortcut) {
            shortcutTextField.text = self.shortcut;
        }
    }
   
    return cell;
}

- (void)saveShortcut {
    if (phraseTextField.text.length > 0 && shortcutTextField.text.length > 0) {
        NSMutableArray *listOfShortcuts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shortcuts"] mutableCopy];
        [listOfShortcuts addObject:@{@"phrase":phraseTextField.text, @"shortcut":shortcutTextField.text}];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (phraseTextField.text.length > 0 && shortcutTextField.text.length > 0) {
        saveButton.enabled = YES;
    }
    else {
        saveButton.enabled = NO;
    }
    return YES;
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
