//
//  SettingsViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "SettingsViewController.h"
#import "ShortcutsDetailViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    self.title = @"Settings";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Shortcuts"];

    
    // TEST DATA
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"SHORTCUTS";
            break;
        case 1:
            return @"GENERAL";
            break;
        case 2:
            return @"ACCOUNT";
            break;
        default:
            break;
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *listOfShortcuts = [[NSUserDefaults standardUserDefaults] objectForKey:@"shortcuts"];
    switch (section) {
        case 0:
            return listOfShortcuts.count+1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSArray *listOfShortcuts = [[NSUserDefaults standardUserDefaults] objectForKey:@"shortcuts"];

    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Shortcuts"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == listOfShortcuts.count) {
                cell.textLabel.text = @"Add new shortcut..";
                return cell;
            }
            cell.textLabel.text = [[listOfShortcuts objectAtIndex:indexPath.row] objectForKey:@"phrase"];
            cell.detailTextLabel.text = [[listOfShortcuts objectAtIndex:indexPath.row] objectForKey:@"shortcut"];
            cell.tag = 111;
            break;
        case 1:
            cell.textLabel.text =  @"Send Feedback";
            break;
        case 2:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Set PIN";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = @"Log Out";
            }
            break;
        default:
            break;
    }
    
    return cell;
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray *listOfShortcuts = [[NSUserDefaults standardUserDefaults] objectForKey:@"shortcuts"];
        ShortcutsDetailViewController *sdvc = [[ShortcutsDetailViewController alloc] init];
        if (indexPath.row != listOfShortcuts.count) {
            sdvc.phrase = [[listOfShortcuts objectAtIndex:indexPath.row] objectForKey:@"phrase"];
            sdvc.shortcut = [[listOfShortcuts objectAtIndex:indexPath.row] objectForKey:@"shortcut"];
        }
        [self.navigationController pushViewController:sdvc animated:YES];
    }
    else if (indexPath.section == 1) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Occuhunt iOS App – Feedback"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"occuhunt@gmail.com", nil];
        [controller setToRecipients:toRecipients];
        [controller setMessageBody:@"" isHTML:NO];
        [self presentViewController:controller animated:YES completion:nil];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
