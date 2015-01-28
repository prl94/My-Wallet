//
//  AppDelegate.h
//  MyWallet
//
//  Created by mac on 08.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(CGFloat)convert:(CGFloat) value with:(NSString*)currency to:(NSString*)outputCurrency;
-(CGFloat) convert:(CGFloat)value to:(NSString*)currency;
@end

