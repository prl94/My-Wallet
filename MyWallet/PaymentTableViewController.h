//
//  PaymentTableViewController.h
//  MyWallet
//
//  Created by Ruslan on 29.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewController : UITableViewController

@property (strong) NSString *kindOfPayment;
@property (strong) NSDate *date;
@property (strong) NSString *bill;
@property (strong) NSNumber *balance;
@property (strong) NSString *currency;
@property (strong) NSString *descriptionOfPayment;
@property (strong) NSNumber *identifierOfOperation;
@end
