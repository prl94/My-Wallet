//
//  AddBillViewController.h
//  MyWallet
//
//  Created by Ruslan on 16.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopupPassData <NSObject>
@required
-(void)addBillToDataBase:(NSString*)name and:(NSString*)size and:(NSString*)currency;
-(void)resaveBillFromIndex:(NSUInteger)index andName:(NSString*)name andBalance:(NSString*)balance andCurrency:(NSUInteger)currencyIndex;
@end
@interface AddBillViewController : UITableViewController
@property (strong, nonatomic) id myDelegate;
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCurrency;
@property (weak, nonatomic) IBOutlet UITextField *balanceTextField;
@property (assign) BOOL editingMode;

@property (assign) NSUInteger index;
@property (strong) NSString *nameBill;
@property (strong) NSNumber *balanceBill;
@property (assign) NSUInteger currencyIndex;

@end
