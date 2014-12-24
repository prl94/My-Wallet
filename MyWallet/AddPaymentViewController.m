//
//  AddPaymentViewController.m
//  MyWallet
//
//  Created by Ruslan on 19.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "AddPaymentViewController.h"

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
        [self.textFieldSu becomeFirstResponder];


    }
    if (self.segmentPayment.selectedSegmentIndex==2){
        [self.tableViewOut setHidden:NO];
        [self.tableViewIn setHidden:NO];
        [self.labelDate setHidden:YES];
        [self.labelSum setHidden:YES];
        [self.textboxToday setHidden:YES];
        [self.textFieldSu setHidden:YES];
        [self.textboxInfo setHidden:YES];
        [self.textboxToday setHidden:YES];
        [self.textFieldSu resignFirstResponder];
        [self.textboxInfo resignFirstResponder];

    }

}
- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)addButtonPressed:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerChanged:(id)sender {
    self.textboxToday.text=[NSString stringWithFormat:@"%@", self.datePicker.date];
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
    else return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.textboxInfo])
        [self.textFieldSu becomeFirstResponder];
    [textField resignFirstResponder];
    return YES;
}
// called when 'return' key pressed. return NO to ignore.



#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=@"DFSFSDF";
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
