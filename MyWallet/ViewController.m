//
//  ViewController.m
//  MyWallet
//
//  Created by Ruslan on 09.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(leftButtonPressed:)];
//    self.navigationItem.rightBarButtonItem=button; // add right button
//    UIBarButtonItem *buttonInfo = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftButtonPressed:)];
//    self.navigationItem.leftBarButtonItem=buttonInfo;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]]; // set buttons color
//     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
    // Do any additional setup after loading the view.
  
}
-(void)leftButtonPressed:(UIBarButtonItem*)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
