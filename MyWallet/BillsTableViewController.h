//
//  BillsTableViewController.h
//  MyWallet
//
//  Created by Ruslan on 26.01.15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@protocol BillProtocol <NSObject>
@required
- (IBAction)addButtonPressed:(id)sender;
@end

@interface BillsTableViewController : UITableViewController
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) id myDelegate;

@end
