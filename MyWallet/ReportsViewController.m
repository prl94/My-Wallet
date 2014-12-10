//
//  ReportsViewController.m
//  MyWallet
//
//  Created by mac on 09.12.14.
//  Copyright (c) 2014 Volodymyr Parlah. All rights reserved.
//

#import "ReportsViewController.h"
static NSInteger counter = 0;


@interface ReportsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@end




@implementation ReportsViewController

- (IBAction)previousDateButton:(id)sender {
    counter --;
    //[self setMonth];
    switch (self.segmented.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            [self setMonth];

            break;
        case 2:
             [self setYear];
            break;
        default:
            break;
    }

}
- (IBAction)nextDateButton:(id)sender {
    
    counter ++;
  //  [self setMonth];
    switch (self.segmented.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            [self setMonth];
            
            break;
        case 2:
            [self setYear];
            break;
        default:
            break;
    }


}


// select week mounth year
-(void)reportsInterval:(NSInteger)interval{

    switch (interval) {
        case 0:
            NSLog(@"week reload");
            counter = 0;
            //get week operation from db
            [self.tableView reloadData];
            break;
        case 1:
            NSLog(@"month reload");
            counter = 0;
            //get month operation from db
            [self setMonth];
            [self.tableView reloadData];
            break;
        case 2:
            NSLog(@"year reload");
            counter = 0;
            //get year operation from db
            [self setYear];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }


}



// select week mounth year
- (IBAction)segmentedValueChandgedAction:(UISegmentedControl *)sender {

    [self reportsInterval:sender.selectedSegmentIndex];
}

-(void)setWeek{
    /*
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setWeekOfYear:counter];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    NSLog(@"\ncurrentDate: %@\nseven days ago: %@", currentDate, sevenDaysAgo);
    
    NSDate *today = [NSDate date];
    NSLog(@"Today date is %@",today);
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];// you can use your format.
    
    //Week Start Date
    
    NSCalendar *gregorian = [[NSCalendar alloc]        initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    
    [components setDay:([components day] - ((dayofweek) - 2))];// for beginning of the week.
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"yyyy-MM-dd"];
    dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    
    weekstartPrev = [[dateFormat_first dateFromString:dateString2Prev] retain];
    
    NSLog(@"%@",weekstartPrev);
    
    
    //Week End Date
    
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *componentsEnd = [gregorianEnd components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int Enddayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    
    [componentsEnd setDay:([componentsEnd day]+(7-Enddayofweek)+1)];// for end day of the week
    
    NSDate *EndOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"yyyy-MM-dd"];
    dateEndPrev = [dateFormat stringFromDate:EndOfWeek];
    
    weekEndPrev = [[dateFormat_End dateFromString:dateEndPrev] retain];
    NSLog(@"%@",weekEndPrev);
*/
}
-(void)setYear{
   
    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:counter];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
   
    
    
    
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitWeekOfYear fromDate:sevenDaysAgo];
    
    NSLog(@"%i",[components month]); //gives you month
    NSLog(@"%i",[components day]); //gives you month
    NSLog(@"%i",[components weekOfYear]); //gives you month
    NSLog(@"%i",[components year]); //gives you month

    NSString *year = [NSString stringWithFormat:@"Год %i",[components year]];
    
    self.dateLabel.text = year;
    
}

-(void)setMonth{

    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:counter];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    NSLog(@"\ncurrentDate: %@\nseven days ago: %@", currentDate, sevenDaysAgo);

    
    
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitWeekOfYear fromDate:sevenDaysAgo];
    
    NSLog(@"%i",[components month]); //gives you month
    NSLog(@"%i",[components day]); //gives you month
    NSLog(@"%i",[components weekOfYear]); //gives you month
    NSLog(@"%i",[components year]); //gives you month
    
    int monthNumber = [components month];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString * dateString = [NSString stringWithFormat: @"%d", monthNumber];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM";
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    
    // set swedish locale
    dateFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"RU"];
    
    dateFormatter.dateFormat=@"MMMM";
    NSString * monthString = [[dateFormatter stringFromDate:date] capitalizedString];
    NSLog(@"month: %@ %@" , monthString, language);
    
    dateFormatter.dateFormat=@"EEEE";
    NSString * dayString = [[dateFormatter stringFromDate:date] capitalizedString];
    NSLog(@"day: %@", dayString);
    
    NSString *month = [NSString stringWithFormat:@"%@, %i",monthString,[components year]];
    
    self.dateLabel.text = month;



}

- (void)viewDidLoad {
    [super viewDidLoad];

    // custom interval
    [self reportsInterval:self.segmented.selectedSegmentIndex];
   
  
    
    
    
    // Do any additional setup after loading the view.


}

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
    
  
    
    
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(91, 15, tableView.bounds.size.width, 22)];
    fromLabel.text = @"text";
   // fromLabel.font = customFont;
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.adjustsLetterSpacingToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor blackColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    [sectionView addSubview:fromLabel];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section == 1) {
        return @"Доходи:";
    }else
        return @"Разходы:";

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//
//return @"footer";
//
//}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifire = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }else{
    }
    
    
    cell.textLabel.text = @"text";
    return cell;


}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
