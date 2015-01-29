//
//  Bills.h
//  MyWallet
//
//  Created by Ruslan on 19.01.15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Payment;

@interface Bills : NSManagedObject

@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * nameBill;
@property (nonatomic, retain) NSNumber * startBalance;
@property (nonatomic, retain) NSNumber * currentBalance;
@property (nonatomic, retain) NSSet *payment;
@end

@interface Bills (CoreDataGeneratedAccessors)

- (void)addPaymentObject:(Payment *)value;
- (void)removePaymentObject:(Payment *)value;
- (void)addPayment:(NSSet *)values;
- (void)removePayment:(NSSet *)values;
+(void)getDataToArray:(NSArray*)array;
@end
