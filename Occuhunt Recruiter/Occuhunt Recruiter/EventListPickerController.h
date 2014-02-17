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
- (void)selectedEvent:(NSString *)eventID;
@end

@interface EventListPickerController : UITableViewController
- (id)initWithStyle:(UITableViewStyle)style andEvents:(NSArray *)listOfEvents;
@property (nonatomic, strong) NSArray *eventNames;
@property (nonatomic, weak) id<EventListPickerDelegate> delegate;
@end
