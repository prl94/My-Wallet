//
//  PaymentTableViewController.m
//  MyWallet
//
//  Created by Ruslan on 29.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "Payment.h"
#import "Bills.h"
#import <CoreData/CoreData.h>
@interface PaymentTableViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelKindOfPayment;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelBill;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDescription;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

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
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

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
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Payment" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *result = [ self.managedObjectContext executeFetchRequest:request error:&error];
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
                secondBill.currentBalance=@([secondBill.currentBalance floatValue]-[self convert:[p.value floatValue] with:firstBill.currency to:secondBill.currency]);
                
            }
            [self.managedObjectContext deleteObject:p];
        }
    [self.managedObjectContext save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(CGFloat)convert:(CGFloat) value with:(NSString*)currency to:(NSString*)outputCurrency{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([currency isEqualToString:@"UAH"])
        value*=[[defaults objectForKey:@"UAHtoUSD"]floatValue];
    else if ([currency isEqualToString:@"RUB"])
        value*=[[defaults objectForKey:@"RUBtoUSD"]floatValue];
    else if ([currency isEqualToString:@"EUR"])
        value*=[[defaults objectForKey:@"EURtoUSD"]floatValue];
    value=[self convert:value to:outputCurrency];
    return value;
}
-(CGFloat) convert:(CGFloat)value to:(NSString*)currency{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([currency isEqualToString:@"UAH"])
        value/=[[defaults objectForKey:@"UAHtoUSD"]floatValue];
    else if ([currency isEqualToString:@"RUB"])
        value/=[[defaults objectForKey:@"RUBtoUSD"]floatValue];
    else if ([currency isEqualToString:@"EUR"])
        value/=[[defaults objectForKey:@"EURtoUSD"]floatValue];
    return value;
}

-(Bills *)getBillFromIdentifier:(NSNumber*)identifier{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request
                                                              error:nil];
    
    for (Bills *bill in array)
        if ([bill.identifier isEqualToNumber:identifier]) {
            return bill;
        }
    
    return 0;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return  NO;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "none.CoreDataProject" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}



@end
