//
//  ShortcutsDetailViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(help)];
    self.navigationItem.leftBarButtonItem = helpButton;
    
    loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    self.navigationItem.rightBarButtonItem = loginButton;

    loginButton.enabled = NO;
    self.title = @"Log In";
    
    thisServer = [[ServerIO alloc] init];
    thisServer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [usernameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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
        cell.textLabel.text = @"Username";
        cell.detailTextLabel.hidden = YES;
        usernameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 410, 36)];
        [cell.contentView addSubview:usernameField];
        usernameField.textAlignment = NSTextAlignmentRight;
        usernameField.delegate = self;
        usernameField.returnKeyType = UIReturnKeyNext;
        usernameField.tag = 1;
        if (self.phrase) {
            usernameField.text = self.phrase;
            
        }
        usernameField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Password";
        cell.detailTextLabel.hidden = YES;
        passwordField = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 410, 36)];
        [cell.contentView addSubview:passwordField];
        passwordField.textAlignment = NSTextAlignmentRight;
        passwordField.delegate = self;
        passwordField.secureTextEntry = YES;
        passwordField.tag = 2;
        passwordField.returnKeyType = UIReturnKeyGo;
        if (self.shortcut) {
            passwordField.text = self.shortcut;
        }
        passwordField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        
    }
   
    return cell;
}

- (void)help {
    UIAlertView *callAlert = [[UIAlertView alloc] initWithTitle:@"Need help?" message:@"Call us at +1  (510) 612-7328 or +1 (510) 931-3820 for support." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [callAlert show];
}
- (void)login {
    if (usernameField.text.length > 0 && passwordField.text.length > 0) {
        [thisServer loginWithUsername:usernameField.text andPassword:passwordField.text];
    }
}

- (void)returnData:(AFHTTPRequestOperation *)operation response:(NSDictionary *)response {
    if ([response objectForKey:@"company_id"]) {
        if (self.delegate) {
            [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"company_id"] forKey:@"company_id"];
            [self.delegate dismissViewControllerAnimated:YES completion:nil];
            KLViewController *delegate = (KLViewController *)self.delegate;
            if ([delegate respondsToSelector:@selector(chooseEvents:)]) {
//                [delegate chooseEvents:nil];
            }
        }
    }
    else {
        // Failed to login.
        
        UIAlertView *callAlert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"We could not log you in. Call us at +1  (510) 612-7328 or +1 (510) 931-3820 for support." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [callAlert show];
        
    }
}

- (void)returnFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [passwordField becomeFirstResponder];
    }
    else {
        [self login];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (usernameField.text.length > 0 && passwordField.text.length > 0) {
        loginButton.enabled = YES;
    }
    else {
        loginButton.enabled = NO;
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
