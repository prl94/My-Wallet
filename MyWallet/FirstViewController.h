//
//  FirstViewController.h
//  MyWallet
//
//  Created by mac on 08.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddBillViewController.h"
#import "AddPaymentViewController.h"
@interface FirstViewController : UIViewController <PopupPassData, PaymentProtocol>
@property (weak, nonatomic) AddBillViewController *myPopover;
@property (weak, nonatomic) AddPaymentViewController *myPopoverPayment;


@end

