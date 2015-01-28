//
//  AddTransferViewController.h
//  MyWallet
//
//  Created by Ruslan on 28.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TransferProtocol <NSObject>
@required
-(void)addTransfer:(NSDate *)date andSum:(NSString *)sum andComment:(NSString*)comment;
@end

@interface AddTransferViewController : UIViewController
@property (strong, nonatomic) id myDelegate;
@property (strong) NSManagedObjectContext *managedObjectContext;

@end
