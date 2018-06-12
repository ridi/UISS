//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSDemoFirstViewController.h"

@implementation UISSDemoFirstViewController

- (IBAction)action:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Test"
                               message:nil
                              delegate:nil
                     cancelButtonTitle:@"Close"
                     otherButtonTitles:nil] show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

@end
