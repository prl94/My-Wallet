//
//  PaymentOut.h
//  MyWallet
//
//  Created by Ruslan on 16.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bills;

@interface PaymentOut : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Bills *payment;

@end
