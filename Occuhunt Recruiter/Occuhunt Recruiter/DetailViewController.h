//
//  DetailViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/12/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KLNoteViewController/KLNoteViewController.h>

@interface DetailViewController : KLNoteViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
