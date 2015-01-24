//
//  CustomTableViewCell.h
//  MyWallet
//
//  Created by Ruslan on 09.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *currency;
@property (weak, nonatomic) IBOutlet UILabel *billSize;
@property (weak, nonatomic) IBOutlet UILabel *billName;
@end
