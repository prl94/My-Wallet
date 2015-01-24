//
//  FirstViewController.m
//  MyWallet
//
//  Created by mac on 08.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "FirstViewController.h"
#import "CustomTableViewCell.h"
#import "Payment.h"
#import "Bills.h"
extern NSInteger billIndex;
static NSInteger identifier=0;
@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;
@property BOOL isHidden;
@property NSInteger index;
@property (strong) NSArray *bills;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBalance];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
    self.index=-1;
    self.isHidden=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UIEdgeInsets inset = UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height*2, 0, 0, 0);
   [self.tableView setContentInset:inset];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"EUR" forKey:@"Currency"];
    [defaults setObject:@(0.05) forKey:@"UAHtoUSD"];
    [defaults setObject:@(0.015) forKey:@"RUBtoUSD"];
    [defaults setObject:@(1.18) forKey:@"EURtoUSD"];

    [defaults synchronize];
    [self.labelCurrency setText: [defaults objectForKey:@"Currency"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.managedObjectContext save:nil];
    [self.managedObjectContext reset];
    [self.tableView reloadData];
    [self getBalance];
}


-(void)getBalance{
    NSArray *array = [self allObjects];
    Bills *last = [[self allObjects]lastObject];
    identifier=[last.identifier integerValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat sum=0;
    for (Bills *b in array)
        sum+=[self convert:[b.currentBalance floatValue]
                      with:b.currency to:[defaults objectForKey:@"Currency"]];
    
    if (sum>=0)
        [self.labelBalance setTextColor:[UIColor greenColor]];
    else [self.labelBalance setTextColor:[UIColor redColor]];
    self.labelBalance.text=[NSString stringWithFormat:@"%1.2f", sum];
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
- (IBAction)test:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Something text" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"Other", nil];
    [alert show];
//    UIStoryboard *storyboard = self.storyboard;
//    AddPaymentViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainC"];
//    [self presentViewController:mainViewController animated:YES completion:nil];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"popoverSegue"])
    {
        self.myPopover =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [self.myPopover setMyDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"editSegue"])
    {
        Bills *bill= [self getBill:self.index];
        self.myPopover =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [self.myPopover setMyDelegate:self];
        [self.myPopover setEditingMode:YES];
        [self.myPopover setNameBill:bill.nameBill];
        [self.myPopover setBalanceBill:bill.currentBalance];
        [self.myPopover setCurrencyIndex:3];
        [self.myPopover setIndex:self.index];
    }
    else if ([[segue identifier] isEqualToString:@"addPayment"])
    {
        self.myPopoverPayment =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [self.myPopoverPayment setMyDelegate:self];
    }


}


- (IBAction)deleteBillFromDataBase:(id)sender {
    Bills *bill = [self getBill:self.index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.managedObjectContext deleteObject:bill];
    [self.managedObjectContext save:nil];
    [self getBalance];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    self.index=-1;
    [self.tableView endUpdates];
    }

-(void)resetContext{
    [self.managedObjectContext reset];
    [self getArrayWithData];
    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
}
-(void)printAllObjectsFromDataBase{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"Payment" inManagedObjectContext:self.managedObjectContext]];
    for (id s in [self.managedObjectContext executeFetchRequest:request error:nil]) {
        if ([s isKindOfClass:[Payment class]])
        {
            Payment *temp = s;
            if ([temp.payment.nameBill isEqual:@"ttt"])
            NSLog(@"%@ - %@ - %@ - Name - %@",temp.date, temp.value, temp.kindOfPayment, temp.payment.nameBill);
            
        }
        
        
    }
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

-(NSArray *)allObjects{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *result = [ self.managedObjectContext executeFetchRequest:request error:&error];
    return result;
}
-(void)resaveBillFromIndex:(NSUInteger)index andName:(NSString*)name andBalance:(NSString*)balance andCurrency:(NSUInteger)currencyIndex{
    Bills *bill = [self getBill:index];
    NSString *currency;
    switch (currencyIndex)
    {
        case 0:
            currency=@"USD";
            break;
        case 1:
            currency=@"EUR";
            break;
        case 2:
            currency=@"UAH";
            break;
        case 3:
            currency=@"RUB";
            break;
    }
    bill.nameBill=name;
    bill.currentBalance=@([bill.currentBalance floatValue] - [bill.startBalance floatValue]+[balance floatValue]);
    bill.startBalance=@([balance floatValue]);
    bill.currency=currency;
    [self.managedObjectContext save:nil];
    [self getBalance];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.myPopover dismissViewControllerAnimated:YES completion:^{
    }];
    
}

-(Bills *)getBill:(NSInteger)index{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request
                                                              error:nil];
    
    return  [array objectAtIndex:index];
    
}

-(void)addBillToDataBase:(NSString*)name and:(NSString*)size and:(NSString *)currency{
    Bills *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bills" inManagedObjectContext:self.managedObjectContext];
    bill.currency=currency;
    bill.nameBill=name;
    bill.startBalance=@([size floatValue]);
    bill.currentBalance=@([size floatValue]);
    identifier=identifier+1;
    bill.identifier=@(identifier);
    NSLog(@"Bill identifier is - %ld", identifier);
    [self.managedObjectContext save:nil];
    [self getBalance];
    [self.myPopover dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


#pragma mark  UITableViwDatsSource
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self getArrayWithData];
   return [self.bills count];

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    Bills *temp = [self.bills objectAtIndex:indexPath.row];

    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.billName.text=temp.nameBill;
    cell.billSize.text=[NSString stringWithFormat:@"%1.2f", [temp.currentBalance floatValue]];
    [cell.billSize setTextColor:[self getLabelColor:temp.currentBalance]];
    cell.currency.text=temp.currency;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row==self.index)
    {
        cell.toolbar.hidden=NO;
    }
    else cell.toolbar.hidden=YES;
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
-(UIColor*)getLabelColor:(NSNumber*)number{
    if ([number floatValue]>=0)
        return [UIColor greenColor];
    else
        return [UIColor redColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.index){
        return 100.0f;
    }
    else return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == indexPath.row)
        self.index=-1;
    else billIndex=self.index=indexPath.row;
    [tableView beginUpdates];
    [self.tableView reloadData];
//   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationf];
    [tableView endUpdates];
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
