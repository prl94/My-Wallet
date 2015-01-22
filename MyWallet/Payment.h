//
//  Payment.h
//  MyWallet
//
//  Created by Ruslan on 19.01.15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bills;

@interface Payment : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * descriptionOfPayment;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * kindOfPayment;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * toBill;
@property (nonatomic, retain) Bills *payment;

@end
