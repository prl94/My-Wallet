//
//  PaymentTableViewController.m
//  MyWallet
//
//  Created by Ruslan on 29.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "AppDelegate.h"
#import "Payment.h"
#import "Bills.h"
@interface PaymentTableViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelKindOfPayment;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelBill;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDescription;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong)AppDelegate *appDelegate;

@end

@implementation PaymentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textFieldDescription.delegate=self;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
    self.navigationItem.title=@"Операция";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.appDelegate = [[UIApplication sharedApplication]delegate];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.labelKindOfPayment.text = self.kindOfPayment;
    self.labelBalance.text = [NSString stringWithFormat:@"%1.2f",[self.balance floatValue] ];
    self.labelBill.text=self.bill;
    self.labelCurrency.text=self.currency;
    self.textFieldDescription.text=self.descriptionOfPayment;
    if ([self.kindOfPayment isEqual:@"Расход"])
        [self.labelBalance setTextColor:[UIColor redColor]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d.MM.YY"];
    self.labelDate.text=[dateFormat stringFromDate:self.date];
    
}

- (IBAction)deleteButtonPressed:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Payment" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *result = [ self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    for (Payment *p in result)
        if ([p.identifier isEqualToNumber:self.identifierOfOperation]) {
            if ([p.kindOfPayment isEqualToString:@"Прибыль"]) {
                Bills *bill = [self getBillFromIdentifier:p.payment.identifier];
                bill.currentBalance=@([bill.currentBalance floatValue]-[p.value floatValue]);
            }
            else if ([p.kindOfPayment isEqualToString:@"Расход"]) {
                Bills *bill = [self getBillFromIdentifier:p.payment.identifier];
                bill.currentBalance=@([bill.currentBalance floatValue]+[p.value floatValue]);
            }
            else {
                Bills *firstBill = [self getBillFromIdentifier:p.payment.identifier];
                Bills *secondBill = [self getBillFromIdentifier:p.toBill];
                firstBill.currentBalance=@([firstBill.currentBalance floatValue]+[p.value floatValue]);
                secondBill.currentBalance=@([secondBill.currentBalance floatValue]-[self.appDelegate convert:[p.value floatValue] with:firstBill.currency to:secondBill.currency]);
                
            }
            [self.appDelegate.managedObjectContext deleteObject:p];
        }
    [self.appDelegate.managedObjectContext save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}


-(Bills *)getBillFromIdentifier:(NSNumber*)identifier{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    NSArray *array = [self.appDelegate.managedObjectContext executeFetchRequest:request
                                                              error:nil];
    for (Bills *bill in array)
        if ([bill.identifier isEqualToNumber:identifier])
        {
            return bill;
        }
    
    return 0;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return  NO;
}

@end
