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
extern NSInteger billIndex;

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
    [self.tableViewIn setHidden:YES];
    [self.tableViewOut setHidden:YES];
    self.appDelegate=[[UIApplication sharedApplication]delegate];
    self.managedObjectContext=self.appDelegate.managedObjectContext;
    }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textboxInfo setText:@""];
    [self.textboxToday setText:@"Сегодня"];
    [self.textFieldSu setText:@""];
    [self.segmentPayment setSelectedSegmentIndex:0];
    [self setControlsVisibilityForPayment:@"Прибыль"];


}
- (IBAction)segmentPressed:(id)sender {
    if (self.segmentPayment.selectedSegmentIndex==1 || self.segmentPayment.selectedSegmentIndex==0){
        [self setControlsVisibilityForPayment:@"Прибыль"];

    }
    if (self.segmentPayment.selectedSegmentIndex==2)
        [self setControlsVisibilityForPayment:@"Перевод"];
        
}

-(void)setControlsVisibilityForPayment:(NSString*)kindOfPayment{
    BOOL visibility=NO;
    if ([kindOfPayment isEqualToString:@"Перевод"])
    {
        visibility=YES;
        [self.textFieldSu resignFirstResponder];
        [self.textboxInfo resignFirstResponder];
        self.navigationItem.title=@"Шаг 1";
        [self getArrayWithData];
        if (self.bills.count<2)
        {
            [self.tableViewIn setHidden:YES];
            [self.tableViewOut setHidden:YES];
            [self.backgroundLabel setHidden:NO];
        }
    }
    else
    {
        self.navigationItem.title=@"Добавить";
        [self.textFieldSu becomeFirstResponder];
        [self.backgroundLabel setHidden:YES];
        [self.tableViewOut setHidden:YES];
        [self.tableViewIn setHidden:YES];

    }
    [self.labelDate setHidden:visibility];
    [self.labelInfo setHidden:visibility];
    [self.labelSum setHidden:visibility];
    [self.textboxToday setHidden:visibility];
    [self.textFieldSu setHidden:visibility];
    [self.textboxInfo setHidden:visibility];
    [self.buttonAdd setHidden:visibility];
    [self.rightButton setEnabled:visibility];
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
        Payment *temp = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.appDelegate.managedObjectContext];
        if ([self.labelDate.text isEqual:@"Сегодня"])
        temp.date=[NSDate date];
        else temp.date=self.datePicker.date;
        temp.value=@([self.textFieldSu.text floatValue]);
        temp.kindOfPayment = @"Расход";
        temp.descriptionOfPayment=self.textboxInfo.text;
        temp.identifier=@([[self.appDelegate.defaults objectForKey:@"IdentifierPayments"]integerValue]+1);
        [self.appDelegate.defaults setObject:temp.identifier forKey:@"IdentifierPayments"];

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
        Payment *temp = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.appDelegate.managedObjectContext];
        if ([self.labelDate.text isEqual:@"Сегодня"])
            temp.date=[NSDate date];
        else temp.date=self.datePicker.date;
        temp.value=@([self.textFieldSu.text floatValue]);
        temp.kindOfPayment = @"Прибыль";
        temp.descriptionOfPayment=self.textboxInfo.text;
        temp.identifier=@([[self.appDelegate.defaults objectForKey:@"IdentifierPayments"]integerValue]+1);
        [self.appDelegate.defaults setObject:temp.identifier forKey:@"IdentifierPayments"];
        currentBill.currentBalance= @([currentBill.currentBalance floatValue] + [temp.value floatValue]);
        [currentBill addPaymentObject:temp];
        [self.appDelegate.managedObjectContext save:nil];
    }

}

-(void)addTransfer:(NSDate *)date andSum:(NSString *)sum andComment:(NSString*)comment{


    Bills *firstBill = [self.bills objectAtIndex:[self.tableViewOut indexPathForSelectedRow].row];
    Bills *secondBill=[self.billsWithoutSelectedIndex objectAtIndex:[self.tableViewIn indexPathForSelectedRow].row];
    firstBill.currentBalance= @([firstBill.currentBalance floatValue] - [sum floatValue]);
    secondBill.currentBalance= @([secondBill.currentBalance floatValue] + [self.appDelegate convert:[sum floatValue] with:firstBill.currency to:secondBill.currency]);
    Payment *firstTransfer = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    firstTransfer.value=@([sum floatValue]);
    firstTransfer.kindOfPayment=@"Перевод";
    firstTransfer.comment=comment;
    firstTransfer.identifier=@([[self.appDelegate.defaults objectForKey:@"IdentifierPayments"]integerValue]+1);
    [self.appDelegate.defaults setObject:firstTransfer.identifier forKey:@"IdentifierPayments"];
    firstTransfer.descriptionOfPayment=[NSString stringWithFormat:@"%@", secondBill.identifier];
    firstTransfer.date=date;
    firstTransfer.toBill=secondBill.identifier;
    [firstBill addPaymentObject:firstTransfer];
    
    [self.appDelegate.managedObjectContext save:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:NO completion:^{
        }];

    }];
    

}


-(Bills *)getBill:(NSInteger)index{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    NSArray *array = [self.appDelegate.managedObjectContext executeFetchRequest:request
                                                              error:nil];
    
    return  [array objectAtIndex:index];
    
}


- (IBAction)datePickerChanged:(id)sender {
    self.textboxToday.text=[NSString stringWithFormat:@"%@", self.datePicker.date];
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d.MM.YY"];
    NSString *prettyVersion = [dateFormat stringFromDate:date];
    if ([([dateFormat stringFromDate:[NSDate date]])isEqual:prettyVersion])
        self.textboxToday.text=@"Сегодня";
    else self.textboxToday.text=prettyVersion;
    
}
#pragma mark Get Bills
-(void)getArrayWithData{
    self.bills=[NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    NSError *error = nil;
    self.bills = [ self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
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
    if ([segue.identifier isEqual:@"addTransfer"]){

        self.myPopover =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [self.myPopover setMyDelegate:self];
    }
    else   if ([segue.identifier isEqual:@"addPayment"]){
        self.billsPopover=[segue destinationViewController];
        [self.billsPopover setMyDelegate:self];
        [self.billsPopover setManagedObjectContext:self.managedObjectContext];
    }

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


@end
