//
//  ColorPickerViewController.m
//  MathMonsters
//
//  Created by Transferred on 1/12/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import "EventListPickerController.h"

@implementation EventListPickerController

#pragma mark - Init
- (id)initWithStyle:(UITableViewStyle)style andEvents:(NSArray *)listOfEvents andTag:(int) tag
{
    if ([super initWithStyle:style] != nil) {
        
        //Initialize the array
        self.eventNames = [listOfEvents copy];
        self.tag = tag;
        //Make row selections persist.
        
        //Calculate how tall the view should be by multiplying the individual row height
        //by the total number of rows.
        NSInteger rowsCount = [self.eventNames count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        NSLog(@"my integer is %i", self.tag);
        if (self.tag == 0) {
            for (NSDictionary *eachEvent in self.eventNames) {
                //Checks size of text using the default font for UITableViewCell's textLabel.
                NSString *colorName = [eachEvent objectForKey:@"name"];
                CGSize labelSize = [colorName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
                if (labelSize.width > largestLabelWidth) {
                    largestLabelWidth = labelSize.width;
                }
            }
        }
        else if (self.tag == 1){
            for (NSString *eachString in self.eventNames) {
                CGSize labelSize = [eachString sizeWithFont:[UIFont boldSystemFontOfSize:22.0f]];
                if (labelSize.width > largestLabelWidth) {
                    largestLabelWidth = labelSize.width;
                }
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth + 0;
        
        //Set the property to tell the popover container how big this view will be.
        self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return [self.eventNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if (self.tag == 0) {
        cell.textLabel.text = [[self.eventNames objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    else if (self.tag == 1){
        cell.textLabel.text = [self.eventNames objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate != nil) {
        if (self.tag == 0) {
            [_delegate selectedEvent:[self.eventNames objectAtIndex:indexPath.row] andLPC:self];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"Recruiter - Selected Fair"];
        }
        else if (self.tag == 1) {
            [_delegate selectedEvent:[NSNumber numberWithInt:indexPath.row] andLPC:self];
        }
    }
}

@end
