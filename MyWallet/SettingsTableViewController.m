//
//  SettingsTableViewController.m
//  MyWallet
//
//  Created by Ruslan on 26.01.15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.labelCurrency setText: [defaults objectForKey:@"Currency"]];

}
- (IBAction)InfoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Something text" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"Other", nil];
    [alert show];
}


@end
