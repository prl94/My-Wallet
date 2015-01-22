//
//  AddPaymentViewController.h
//  MyWallet
//
//  Created by Ruslan on 19.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTransferViewController.h"
@protocol PaymentProtocol <NSObject>
@required
-(void)resetContext;
@end

@interface AddPaymentViewController : UIViewController<UITabBarDelegate, UITableViewDataSource, TransferProtocol>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (strong, nonatomic) id myDelegate;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak, nonatomic) AddTransferViewController *myPopover;
@property (strong) NSArray *bills;
@property (strong) NSMutableArray *billsWithoutSelectedIndex;
@end
