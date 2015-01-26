//
//  AddPaymentViewController.m
//  MyWallet
//
//  Created by Ruslan on 19.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "AddPaymentViewController.h"
#import "FirstViewController.h"
#import "Bills.h"
#import "Payment.h"
#import <CoreData/CoreData.h>
extern NSInteger billIndex;
static NSInteger identifier=0;

@interface AddPaymentViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentPayment;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOut;
@property (weak, nonatomic) IBOutlet UITableView *tableViewIn;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSum;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSu;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UITextField *textboxInfo;
@property (weak, nonatomic) IBOutlet UITextField *textboxToday;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;
@property NSInteger index;

@end

@implementation AddPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationItem.title=@"Добавить";
    self.textboxInfo.delegate=self;
    self.textboxToday.delegate=self;
    self.textFieldSu.delegate=self;
    [self.textFieldSu becomeFirstResponder];
    self.index=-1;
    [self.rightButton setEnabled:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textboxInfo setText:@""];
    [self.textboxToday setText:@"Сегодня"];
    [self.textFieldSu setText:@""];
}
- (IBAction)segmentPressed:(id)sender {
    if (self.segmentPayment.selectedSegmentIndex==1 || self.segmentPayment.selectedSegmentIndex==0){
        [self.tableViewOut setHidden:YES];
        [self.tableViewIn setHidden:YES];
        [self.labelDate setHidden:NO];
        [self.labelInfo setHidden:NO];
        [self.labelSum setHidden:NO];
        [self.textboxToday setHidden:NO];
        [self.textFieldSu setHidden:NO];
        [self.textboxInfo setHidden:NO];
        [self.textboxToday setHidden:NO];
        [self.buttonAdd setHidden:NO];
        [self.rightButton setEnabled:NO];
        self.navigationItem.title=@"Добавить";
        [self.textFieldSu becomeFirstResponder];
        [self.backgroundLabel setHidden:YES];



    }
    if (self.segmentPayment.selectedSegmentIndex==2){
        [self.tableViewOut setHidden:NO];
        [self.tableViewIn setHidden:NO];
        [self.labelDate setHidden:YES];
        [self.labelSum setHidden:YES];
        [self.labelInfo setHidden:YES];
        [self.textboxToday setHidden:YES];
        [self.textFieldSu setHidden:YES];
        [self.textboxInfo setHidden:YES];
        [self.textboxToday setHidden:YES];
        [self.datePicker setHidden:YES];
        [self.buttonAdd setHidden:YES];
        [self.textFieldSu resignFirstResponder];
        [self.textboxInfo resignFirstResponder];
        self.navigationItem.title=@"Шаг 1";
        [self.rightButton setEnabled:YES];
        [self getArrayWithData];
        if (self.bills.count<2) {
            [self.tableViewIn setHidden:YES];
            [self.tableViewOut setHidden:YES];
            [self.backgroundLabel setHidden:NO];
        }

    }

}
- (IBAction)cancelButtonPressed:(id)sender {
    if ([self.restorationIdentifier isEqualToString:@"1"]){
        self.tabBarController.selectedIndex = 0;
    }
    else [self dismissViewControllerAnimated:YES completion:^{
        
    }];
   }
- (IBAction)addButtonPressed:(id)sender {
    switch (self.segmentPayment.selectedSegmentIndex) {
        case 0:
            [self addConsumption];
            break;
        case 1:
            [self addIncome];
            break;
    }
    [self cancelButtonPressed:self];

}

#pragma mark Add Operation

-(void)addConsumption{
    
    if (self.textFieldSu.text.length!=0)
    {
        Bills *currentBill = [self getBill:billIndex];
        Payment *temp = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.managedObjectContext];
        if ([self.labelDate.text isEqual:@"Сегодня"])
        temp.date=[NSDate date];
        else temp.date=self.datePicker.date;
        temp.value=@([self.textFieldSu.text floatValue]);
        temp.kindOfPayment = @"Расход";
        temp.descriptionOfPayment=self.textboxInfo.text;
        temp.identifier=@(identifier);
        identifier=identifier+1;
        currentBill.currentBalance= @([currentBill.currentBalance floatValue] - [temp.value floatValue]);
        [currentBill addPaymentObject:temp];
        [temp.managedObjectContext save:nil];
        [currentBill.managedObjectContext save:nil];
    }
}

-(void)addIncome{
    if (self.textFieldSu.text.length!=0)
    {
        Bills *currentBill = [self getBill:billIndex];
        Payment *temp = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.managedObjectContext];
        if ([self.labelDate.text isEqual:@"Сегодня"])
            temp.date=[NSDate date];
        else temp.date=self.datePicker.date;
        temp.value=@([self.textFieldSu.text floatValue]);
        temp.kindOfPayment = @"Прибыль";
        temp.descriptionOfPayment=self.textboxInfo.text;
        temp.identifier=@(identifier);
        identifier=identifier+1;
        currentBill.currentBalance= @([currentBill.currentBalance floatValue] + [temp.value floatValue]);
        [currentBill addPaymentObject:temp];
        [self.managedObjectContext save:nil];
    }

}

-(void)addTransfer:(NSDate *)date andSum:(NSString *)sum andComment:(NSString*)comment{


    Bills *firstBill = [self.bills objectAtIndex:[self.tableViewOut indexPathForSelectedRow].row];
    Bills *secondBill=[self.billsWithoutSelectedIndex objectAtIndex:[self.tableViewIn indexPathForSelectedRow].row];
    firstBill.currentBalance= @([firstBill.currentBalance floatValue] - [sum floatValue]);
    secondBill.currentBalance= @([secondBill.currentBalance floatValue] + [self convert:[sum floatValue] with:firstBill.currency to:secondBill.currency]);
    Payment *firstTransfer = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.managedObjectContext];
    

    firstTransfer.value=@([sum floatValue]);
    firstTransfer.kindOfPayment=@"Перевод";
    firstTransfer.comment=comment;
    firstTransfer.identifier=@(identifier);
    firstTransfer.descriptionOfPayment=[NSString stringWithFormat:@"%@", secondBill.identifier];
    firstTransfer.date=date;
    firstTransfer.toBill=secondBill.identifier;
    [firstBill addPaymentObject:firstTransfer];
    
    
    
    
    [self.managedObjectContext save:nil];
    [self.myDelegate resetContext];
    [self dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:NO completion:^{
        }];

    }];
    
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

-(Bills *)getBill:(NSInteger)index{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request
                                                              error:nil];
    
    return  [array objectAtIndex:index];
    
}


- (IBAction)datePickerChanged:(id)sender {
    self.textboxToday.text=[NSString stringWithFormat:@"%@", self.datePicker.date];
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d.MM.YY"];
    NSString *prettyVersion = [dateFormat stringFromDate:date];
    NSLog(@"%@", prettyVersion );
    if ([([dateFormat stringFromDate:[NSDate date]])isEqual:prettyVersion])
        self.textboxToday.text=@"Сегодня";
    else self.textboxToday.text=prettyVersion;
    
}
#pragma mark Get Bills
-(void)getArrayWithData{
    self.bills=[NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    NSError *error = nil;
    self.bills = [ self.managedObjectContext executeFetchRequest:request error:&error];
}


#pragma mark TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.textboxToday])
    {
        [self.textFieldSu resignFirstResponder];
        [self.textboxInfo resignFirstResponder];
        [self.datePicker setHidden:NO];
        return NO;
        
    }
    else [self.datePicker setHidden:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.textboxInfo])
        [self.textFieldSu becomeFirstResponder];
    [textField resignFirstResponder];
    return YES;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"addTransfer"])
//    {
    self.myPopover =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [self.myPopover setMyDelegate:self];
//    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqual:@"addPayment"] & (self.textFieldSu.text.length!=0))
        return YES;

    if ([identifier isEqual:@"addTransfer"]){
        if (([self.tableViewOut indexPathForSelectedRow]!=nil) & ([self.tableViewIn indexPathForSelectedRow]!=nil))
            return YES;
    }
    return NO;

}

#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self getArrayWithData];
    if ([tableView isEqual:self.tableViewOut])
    return [self.bills count];
    else
    {
        if (self.index==-1)
        {
            self.billsWithoutSelectedIndex=[NSMutableArray arrayWithArray:self.bills];
            return [self.bills count];

        }
        else
        {
            self.billsWithoutSelectedIndex=[NSMutableArray arrayWithArray:self.bills];
            [self.billsWithoutSelectedIndex removeObjectAtIndex:self.index];
            return [self.bills count]-1;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    if ([tableView isEqual:self.tableViewOut])
    {
    Bills *temp = [self.bills objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=temp.nameBill;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
    }
    
    else {
        {
            Bills *temp = [self.billsWithoutSelectedIndex objectAtIndex:indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text=temp.nameBill;
            cell.backgroundColor=[UIColor whiteColor];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewOut])
    {
    self.index=indexPath.row;
    [tableView beginUpdates];
    [self.tableViewIn reloadData];
    [tableView endUpdates];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableViewOut])
    return @"Со счета";
    else return @"На счет";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    [myLabel setTextAlignment:NSTextAlignmentCenter];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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
