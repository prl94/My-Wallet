//
//  Payment.h
//  MyWallet
//
//  Created by Ruslan on 17.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bills;

@interface Payment : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * kindOfPaymnet;
@property (nonatomic, retain) Bills *payment;

@end
