//
//  KLViewController.m
//  KLNoteViewController
//
//  Created by Kieran Lafferty on 2012-12-29.
//  Copyright (c) 2012 Kieran Lafferty. All rights reserved.
//

#import "KLViewController.h"
#import "KLCustomViewController.h"
#import "FairListViewController.h"

@interface KLViewController ()

@end

@implementation KLViewController

- (void)loadView {
    [super loadView];
    self.occuhuntRecruiterLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:34];
    self.occuhuntRecruiterLabel.textColor = UIColorFromRGB(0x939393);

}

- (void)viewDidLoad
{

	// Do any additional setup after loading the view, typically from a nib.
    
    //Initialize the controller data
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"NavigationControllerData"
                                                          ofType: @"plist"];
    // Build the array from the plist
    self.viewControllerData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    [super viewDidLoad];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView {
    return  [self.viewControllerData count];
}
- (UIViewController *)noteView:(KLNoteViewController*)noteView viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        FairListViewController *flvc = [[FairListViewController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:flvc];
        return navC;
    }
    //Get the relevant data for the navigation controller
    NSDictionary* navDict = [self.viewControllerData objectAtIndex: index];
    
    //Initialize a blank uiviewcontroller for display purposes
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    KLCustomViewController* viewController = [st instantiateViewControllerWithIdentifier:@"RootViewController"];
    [viewController setInfo: navDict];

    //Return the custom view controller wrapped in a UINavigationController
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState {    
    NSInteger index = [noteViewController indexForControllerCard: controllerCard];
    NSDictionary* navDict = [self.viewControllerData objectAtIndex: index];
    
    NSLog(@"%@ changed state %ld", [navDict objectForKey:@"title"], toState);
}
- (IBAction)reloadCardData:(id)sender {
    [self reloadDataAnimated:YES];
    
}
@end
