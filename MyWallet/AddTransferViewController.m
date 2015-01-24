//
//  AddTransferViewController.m
//  MyWallet
//
//  Created by Ruslan on 28.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "AddTransferViewController.h"

@interface AddTransferViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSum;
@property (weak, nonatomic) IBOutlet UITextField *textFieldComment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AddTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldComment.delegate=self;
    self.textFieldDate.delegate=self;
    self.textFieldSum.delegate=self;
    [self.textFieldSum becomeFirstResponder];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)datePickerChanged:(id)sender {
    self.textFieldDate.text=[NSString stringWithFormat:@"%@", self.datePicker.date];
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d.MM.YY"];
    NSString *prettyVersion = [dateFormat stringFromDate:date];
    if ([([dateFormat stringFromDate:[NSDate date]])isEqual:prettyVersion])
        self.textFieldDate.text=@"Сегодня";
    else self.textFieldDate.text=prettyVersion;
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)addButtonPressed:(id)sender {
    if (self.textFieldSum.text.length!=0){
        if ([self.textFieldDate.text isEqual:@"Сегодня"])
            [self.myDelegate addTransfer:[NSDate date] andSum:self.textFieldSum.text andComment:self.textFieldComment.text];
        else [self.myDelegate addTransfer:[self.datePicker date] andSum:self.textFieldSum.text andComment:self.textFieldComment.text];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}


#pragma mark TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.textFieldDate])
    {
        [self.textFieldComment resignFirstResponder];
        [self.textFieldSum resignFirstResponder];
        [self.datePicker setHidden:NO];
        return NO;
        
    }
    else return YES;
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if ([textField isEqual:self.textboxInfo])
//        [self.textFieldSu becomeFirstResponder];
//    [textField resignFirstResponder];
//    return YES;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
