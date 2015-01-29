//
//  Bills.m
//  MyWallet
//
//  Created by Ruslan on 19.01.15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import "Bills.h"
#import "Payment.h"
#import "AppDelegate.h"

@implementation Bills

@dynamic currency;
@dynamic identifier;
@dynamic nameBill;
@dynamic startBalance;
@dynamic currentBalance;
@dynamic payment;
+(void)getDataToArray:(NSArray*)array{
    AppDelegate *appDelegate = [[ UIApplication sharedApplication]delegate];
    array=[NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Bills" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:description];
    NSError *error = nil;
    array= [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    for (Bills * b in array)
        NSLog(@"%@", b);
        }


@end
