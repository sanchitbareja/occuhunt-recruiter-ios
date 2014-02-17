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
    self.navigationItem.rightBarButtonItem = saveButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [phraseField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Create a shortcut for entering phrases while writing notes. You may use \\n for line breaks.";
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
        phraseField = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 410, 36)];
        [cell.contentView addSubview:phraseField];
        phraseField.textAlignment = NSTextAlignmentRight;
        phraseField.delegate = self;
        phraseField.tag = 1;
        phraseField.returnKeyType = UIReturnKeyNext;
        phraseField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        phraseField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        if (self.phrase) {
            phraseField.text = self.phrase;
            
        }
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Shortcut";
        cell.detailTextLabel.hidden = YES;
        shortcutTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 410, 36)];
        [cell.contentView addSubview:shortcutTextField];
        shortcutTextField.textAlignment = NSTextAlignmentRight;
        shortcutTextField.delegate = self;
        shortcutTextField.tag = 2;
        shortcutTextField.returnKeyType = UIReturnKeyDefault;
        shortcutTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        shortcutTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization
        if (self.shortcut) {
            shortcutTextField.text = self.shortcut;
        }
    }
   
    return cell;
}

- (void)saveShortcut {
    if (phraseField.text.length > 0 && shortcutTextField.text.length > 0) {
        NSMutableArray *listOfShortcuts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shortcuts"] mutableCopy];
        if (self.phrase.length > 0) {
            //override
            [listOfShortcuts setObject:@{@"phrase":phraseField.text, @"shortcut":shortcutTextField.text} atIndexedSubscript:self.index];
            [[NSUserDefaults standardUserDefaults] setObject:listOfShortcuts forKey:@"shortcuts"];
        }
        else {
            [listOfShortcuts addObject:@{@"phrase":phraseField.text, @"shortcut":shortcutTextField.text}];
            [[NSUserDefaults standardUserDefaults] setObject:listOfShortcuts forKey:@"shortcuts"];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"Recruiter - Shortcut Added"];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (phraseField.text.length > 0 && shortcutTextField.text.length > 0) {
        saveButton.enabled = YES;
    }
    else {
        saveButton.enabled = NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [shortcutTextField becomeFirstResponder];
    }
    else {
        [self saveShortcut];
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
