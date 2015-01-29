//
//  AddPaymentViewController.h
//  MyWallet
//
//  Created by Ruslan on 19.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddTransferViewController.h"
#import "BillsTableViewController.h"
@protocol PaymentProtocol <NSObject>
@required
// -(void)resetContext;
@end

@interface AddPaymentViewController : UIViewController<UITabBarDelegate, UITableViewDataSource, TransferProtocol, BillProtocol>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (strong, nonatomic) id myDelegate;
@property (strong)AppDelegate *appDelegate;
@property (weak, nonatomic) AddTransferViewController *myPopover;
@property (weak, nonatomic) BillsTableViewController *billsPopover;
@property (strong) NSArray *bills;
@property (strong) NSMutableArray *billsWithoutSelectedIndex;
@property (strong) NSManagedObjectContext *managedObjectContext;
@end
