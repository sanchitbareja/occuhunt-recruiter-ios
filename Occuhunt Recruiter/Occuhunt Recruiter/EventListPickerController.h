//
//  ColorPickerViewController.h
//  MathMonsters
//
//  Created by Transferred on 1/12/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventListPickerDelegate <NSObject>
@required
- (void)selectedEvent:(id)selectedEvent andLPC:(UIViewController *)lpc;
@end

@interface EventListPickerController : UITableViewController
- (id)initWithStyle:(UITableViewStyle)style andEvents:(NSArray *)listOfEvents andTag:(int) tag;
@property (nonatomic, strong) NSArray *eventNames;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<EventListPickerDelegate> delegate;
@end
