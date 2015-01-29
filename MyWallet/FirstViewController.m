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
@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;
@property (strong) AppDelegate *appDelegate;
@property (strong) NSManagedObjectContext *managedObjectContext;

@property BOOL isHidden;
@property NSInteger index;
@property (strong) NSArray *bills;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate=[[UIApplication sharedApplication]delegate];
    self.managedObjectContext=self.appDelegate.managedObjectContext;

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
    
    self.index=-1;
    self.isHidden=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    
    UIEdgeInsets inset = UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height*2, 0, 0, 0);
   [self.tableView setContentInset:inset];
        
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    [self getCurrentBalance];
}


-(void)getCurrentBalance{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat result=0;
    for (Bills *b in self.bills)
    {
        result+=[self.appDelegate
              convert:[b.currentBalance floatValue]
              with:b.currency
              to:[defaults objectForKey:@"Currency"]];
    }
    [self.labelBalance setTextColor:[self.appDelegate getLabelColor:@(result)]];
     self.labelBalance.text=[NSString stringWithFormat:@"%1.2f", result];
    [self.labelCurrency setText: [defaults objectForKey:@"Currency"]];
    [defaults synchronize];

}

- (IBAction)buttonInfoPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Something text" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
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
        Bills *bill= [self getBillFrom:self.index];
        self.myPopover =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [self.myPopover setMyDelegate:self];
        [self.myPopover setEditingMode:YES];
        [self.myPopover setNameBill:bill.nameBill];
        [self.myPopover setBalanceBill:bill.startBalance];
        NSNumber *currencyIndex=@(0);
        if ([bill.currency isEqualToString:@"EUR"])
            currencyIndex=@(1);
        else if ([bill.currency isEqualToString:@"UAH"])
            currencyIndex=@(2);
        else if ([bill.currency isEqualToString:@"RUB"])
            currencyIndex=@(3);
        [self.myPopover setCurrencyIndex:[currencyIndex integerValue]];
        [self.myPopover setIndex:self.index];
        [self.myPopoverPayment setAppDelegate:self.appDelegate];

    }
    else if ([[segue identifier] isEqualToString:@"addPayment"])
    {
        self.myPopoverPayment =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [self.myPopoverPayment setMyDelegate:self];
        [self.myPopoverPayment setAppDelegate:self.appDelegate];
    }


}


- (IBAction)buttonDeletePressed:(id)sender
{
    Bills *bill = [self getBillFrom:self.index];
    NSString *description = [NSString stringWithFormat:@"Все операции по счету будут удалены."
                            "\nУдалить счет '%@'?", bill.nameBill];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:description
                                                            delegate:self cancelButtonTitle:@"Отмена"destructiveButtonTitle:@"Удалить" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

-(void)deleteBillFromDataBase{
    Bills *bill = [self getBillFrom:self.index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.managedObjectContext deleteObject:bill];
    [self.managedObjectContext save:nil];
    [self getCurrentBalance];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    self.index=-1;
    [self.tableView endUpdates];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self deleteBillFromDataBase];
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


-(void)resaveBillFromIndex:(NSUInteger)index andName:(NSString*)name andBalance:(NSString*)balance andCurrency:(NSUInteger)currencyIndex{
    Bills *bill = [self getBillFrom:index];
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
    [self getCurrentBalance];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.myPopover dismissViewControllerAnimated:YES completion:^{
    }];
    
}

-(Bills *)getBillFrom:(NSInteger)index{
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
    bill.identifier=@([[self.appDelegate.defaults objectForKey:@"IdentifierBills"]integerValue]+1);
    [self.appDelegate.defaults setObject:bill.identifier forKey:@"IdentifierBills"];
    [self.managedObjectContext save:nil];
    [self getCurrentBalance];
    [self.appDelegate.defaults synchronize];

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
    [cell.billSize setTextColor:[self.appDelegate getLabelColor:temp.currentBalance]];
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



@end
