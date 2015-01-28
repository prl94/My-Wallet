//
//  OperationsTableViewController.m
//  MyWallet
//
//  Created by Ruslan on 25.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "OperationsTableViewController.h"
#import "Bills.h"
#import "Payment.h"
#import "PaymentTableViewController.h"
#import "CustomTableViewCell.h"
@interface OperationsTableViewController ()
extern NSInteger billIndex;

@property (strong)AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;
@property (strong) NSArray *operations;
@end

@implementation OperationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.appDelegate = [[UIApplication sharedApplication]delegate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getArrayWithData];
    NSMutableArray *temp=[NSMutableArray array];
    if ([self.navigationItem.title isEqualToString:@"Операции"] & (self.operations.count!=0))
    {
    Bills *currentBill = [ self getBill:billIndex];
    for (Payment *p in self.operations )    
      if ([p.payment.identifier isEqualToNumber:currentBill.identifier] || [p.toBill isEqualToNumber:currentBill.identifier])
        {
            [temp addObject:p];
        }
    self.operations=(NSArray*)temp;
    }
    
    if (self.operations.count!=0)
    {
    NSArray *reverseOrderUsingComparator = [self.operations sortedArrayUsingComparator:
                                            ^(Payment *obj1, Payment *obj2) {
                                                return [obj2.date compare:obj1.date];
                                            }];
    self.operations=reverseOrderUsingComparator;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMMM YYY"];
    
    NSMutableArray *result=[NSMutableArray array];
    [result addObject:[NSMutableArray array]];
    [[result lastObject]addObject:[self.operations firstObject]];
    for (int i=1; i<self.operations.count; i++)
    {
        NSString *current = [dateFormat stringFromDate:((Payment*)self.operations[i]).date];
        NSString *prev = [dateFormat stringFromDate:((Payment*)self.operations[i-1]).date];
        if (![current isEqual:prev])
        {
            [result addObject:[NSMutableArray array]];
            Payment *temp = [self.operations objectAtIndex:i];

            [[result lastObject]addObject:temp];
        }
        else
        {

            Payment *temp = [self.operations objectAtIndex:i];
            [[result lastObject]addObject:temp];
        }
        
             
    }
    self.operations=result;
    }
    
    if (self.operations.count==0) {
        [self.backgroundView setHidden:NO];
        [self.backgroundLabel setHidden:NO];
        [self.tableView setScrollEnabled:NO];
    }

}
- (IBAction)addButtonPressed:(id)sender {
    self.tabBarController.selectedIndex = 2;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Payment *temp = [[self.operations objectAtIndex:path.section] objectAtIndex:path.row];
            PaymentTableViewController *controller = (PaymentTableViewController*)segue.destinationViewController;
        [controller setKindOfPayment:temp.kindOfPayment];
        [controller setDate:temp.date];
        [controller setBill:temp.payment.nameBill];
        [controller setBalance:temp.value];
        [controller setCurrency:temp.payment.currency];
        [controller setIdentifierOfOperation:temp.identifier];
    if (![temp.kindOfPayment isEqual:@"Перевод"]) {
        [controller setDescriptionOfPayment:temp.descriptionOfPayment];
    }
    else {
        [controller setDescriptionOfPayment:temp.comment];
        
    }
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Something text" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"Other", nil];
    [alert show];
}

-(void)getArrayWithData{
    self.operations=[NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Payment" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    NSError *error = nil;
    self.operations=[NSArray array];
    self.operations = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
}

-(Bills *)getBill:(NSInteger)index{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    NSArray *array = [self.appDelegate.managedObjectContext executeFetchRequest:request
                                                              error:nil];
    
    return  [array objectAtIndex:index];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.operations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.operations objectAtIndex:section]count];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 65.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    Payment *temp = [[self.operations objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }

    cell.billName.text=temp.kindOfPayment;
    cell.billSize.text=[NSString stringWithFormat:@"%1.2f", [temp.value floatValue]];
    [cell.billSize setTextColor:[self getLabelColor:temp.value]];
    cell.currency.text=temp.payment.currency;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.toolbar.hidden=YES;
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
-(UIColor*)getLabelColor:(NSNumber*)number{
    if ([number floatValue]>=0)
        return [UIColor greenColor];
    else
        return [UIColor redColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMMM YYY"];
    return [dateFormat stringFromDate:((Payment*)[[self.operations objectAtIndex:section] firstObject]).date];

}


@end