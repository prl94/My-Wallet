//
//  BillsTableViewController.m
//  MyWallet
//
//  Created by Ruslan on 26.01.15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import "BillsTableViewController.h"
#import "Bills.h"
@interface BillsTableViewController ()
@property (strong) NSArray *bills;
extern NSInteger billIndex;
@end

@implementation BillsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getArrayWithData];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
    [self.navigationItem setTitle:@"Выберите счет"];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.bills count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    [cell.textLabel setText:((Bills*)[self.bills objectAtIndex:indexPath.row]).nameBill];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    billIndex=indexPath.row;
    [self.myDelegate addButtonPressed:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark BillsData

-(void)getArrayWithData{
    self.bills=[NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    NSError *error = nil;
    self.bills = [ self.managedObjectContext executeFetchRequest:request error:&error];
}

@end
