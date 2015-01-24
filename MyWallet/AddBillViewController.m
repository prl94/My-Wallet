//
//  AddBillViewController.m
//  MyWallet
//
//  Created by Ruslan on 16.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "AddBillViewController.h"
#import "FirstViewController.h"
@interface AddBillViewController ()<UITextFieldDelegate>
@end

@implementation AddBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.billTextField.delegate=self;
    self.balanceTextField.delegate=self;
    [self.billTextField becomeFirstResponder];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // set text color
    if (self.editingMode==YES)
        self.navigationItem.title=@"Изменене счета";
}

- (IBAction)addButtonPressed:(id)sender {
    if (self.editingMode==YES)
    {
        if (self.billTextField.text.length!=0)
        [self.myDelegate resaveBillFromIndex:self.index andName:self.billTextField.text andBalance:self.balanceTextField.text andCurrency:self.segmentCurrency.selectedSegmentIndex];
    }
    else
    {
        if (self.billTextField.text.length!=0)
        {
            NSString *currency;
            switch (self.segmentCurrency.selectedSegmentIndex)
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
                default:
                    break;
            }
            [self.myDelegate addBillToDataBase:self.billTextField.text and:self.balanceTextField.text and:currency];
        }

    }
}
- (IBAction)cancelButtonPressed:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.editingMode==YES){
        self.billTextField.text=self.nameBill;
        self.balanceTextField.text=[NSString stringWithFormat:@"%@", self.balanceBill];
        self.segmentCurrency.selectedSegmentIndex=self.currencyIndex;
    }
    
}

@end
