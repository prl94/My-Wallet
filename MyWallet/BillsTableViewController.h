//
//  BillsTableViewController.h
//  MyWallet
//
//  Created by Ruslan on 26.01.15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@protocol BillProtocol <NSObject>
@required
- (IBAction)addButtonPressed:(id)sender;
@end

@interface BillsTableViewController : UITableViewController
@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id myDelegate;

@end
