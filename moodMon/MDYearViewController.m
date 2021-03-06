//
//  ViewController.m
//  JSCalendar
//
//  Created by 이재성 on 2016. 3. 27..
//  Copyright © 2016년 이재성. All rights reserved.
//

#import "MDYearViewController.h"
#import "MDCustomStoryboardUnwindSegue.h"
#import "MDMoodFaceView.h"
#import "MDMoodColorView.h"
#import "MDDataManager.h"
#import "MDNavController.h"
#import "MDMonthViewController.h"
@interface MDYearViewController (){
    MDDataManager *mddm;
    NSDate *now;
    NSDateComponents *nowComponents;
    
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;


@end


NSInteger numDays;
RLMArray *createdAt;
NSInteger weekday;
int tag;
int thisMonth=0;
UIFont *quicksand;
UIFont *boldQuicksand;

@implementation MDYearViewController
@synthesize yearly;
//@synthesize thisYear;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mddm = [MDDataManager sharedDataManager];
    createdAt=[mddm moodArray];
    now = [NSDate date];
    
    //_thisYear = [[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    //    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(monthTouch:)];
    
    quicksand = [UIFont fontWithName:@"Quicksand" size:16];
    boldQuicksand = [UIFont fontWithDescriptor:[[quicksand fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:quicksand.pointSize];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self myCalView];
    self.monthBtn.titleLabel.text = NSLocalizedString(@"Month", nil);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        _thisYear++;
        [self removeTags];
        [self myCalView];
        NSLog(@"down Swipe");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        _thisYear--;
        [self removeTags];
        [self myCalView];
        NSLog(@"up Swipe");
    }
    
}
//- (IBAction)unwindeBackbtn:(id)sender {
//    [self performSegueWithIdentifier:@"UnwindingSegueID" sender:self];
////    [self.navigationitem removeFromSuperview];
//}
//- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
//    // Instantiate a new CustomUnwindSegue
//    MDCustomStoryboardUnwindSegue *segue = [[MDCustomStoryboardUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
//    // Set the target point for the animation to the center of the button in this VC
//    return segue;
//}

-(void)removeTags{
    int x=1;
    while(x<=900){
        [[self.view viewWithTag:x]removeFromSuperview];
        x++;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[MDMonthViewController class]]) {
        MDMonthViewController *mainViewConroller = segue.destinationViewController;
        if (thisMonth) {
            mainViewConroller.thisYear =  _thisYear;
            mainViewConroller.thisMonth = thisMonth;
        }
    }
}
- (IBAction)monthTouch:(id)sender {
    CGPoint point = [sender locationInView:[self.view superview]];
    double xVal=CGRectGetWidth(self.view.bounds)/3,yVal=CGRectGetHeight(self.view.bounds)/5;
    if(point.y <= 64) {
        return;
    }else if(point.x <= xVal*1&&point.y<=yVal*1+84){
        thisMonth=1;
    }else if(point.x <= xVal*2 && point.y<=yVal*1+84){
        thisMonth=2;
        
    }else if(point.x <= xVal*3 && point.y<=yVal*1+84){
        thisMonth=3;
        
    }else if(point.x <= xVal*1 && point.y<=yVal*2+84){
        
        thisMonth=4;
    }else if(point.x <= xVal*2 && point.y<=yVal*2+84){
        
        thisMonth=5;
    }else if(point.x <= xVal*3 && point.y<=yVal*2+84){
        
        thisMonth=6;
    }else if(point.x <= xVal*1 && point.y<=yVal*3+84){
        
        thisMonth=7;
    }else if(point.x <= xVal*2 && point.y<=yVal*3+84){
        
        thisMonth=8;
    }else if(point.x <= xVal*3 && point.y<=yVal*3+84){
        
        thisMonth=9;
    }else if(point.x <= xVal*1 && point.y<=yVal*4+84){
        
        thisMonth=10;
    }else if(point.x <= xVal*2 && point.y<=yVal*4+84){
        
        thisMonth=11;
    }else if(point.x < xVal*3 && point.y<=yVal*4+84){
        
        thisMonth=12;
    }
    
    [self performSegueWithIdentifier:@"JSUnwindView" sender:self];
}
-(void)myCalView{
    tag=1;
    _titleLabel.text = [NSString stringWithFormat: NSLocalizedString(@"Year Title Date Format", nil), (long)_thisYear];
    
    double xVal=CGRectGetWidth(self.view.bounds)/3,yVal=CGRectGetHeight(self.view.bounds)/5;
    
    [self moreDateInfo:1 xVal:0 yVal:yVal*0+84];
    [self moreDateInfo:2 xVal:xVal yVal:yVal*0+84];
    [self moreDateInfo:3 xVal:xVal*2 yVal:yVal*0+84];
    [self moreDateInfo:4 xVal:0 yVal:yVal*1+84];
    [self moreDateInfo:5 xVal:xVal yVal:yVal*1+84];
    [self moreDateInfo:6 xVal:xVal*2 yVal:yVal*1+84];
    [self moreDateInfo:7 xVal:0 yVal:yVal*2+84];
    [self moreDateInfo:8 xVal:xVal yVal:yVal*2+84];
    [self moreDateInfo:9 xVal:xVal*2 yVal:yVal*2+84];
    [self moreDateInfo:10 xVal:0 yVal:yVal*3+84];
    [self moreDateInfo:11 xVal:xVal yVal:yVal*3+84];
    [self moreDateInfo:12 xVal:xVal*2 yVal:yVal*3+84];
}

-(NSUInteger)getCurrDateInfo:(NSDate *)myDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:myDate];
    NSUInteger numberOfDaysInMonth = rng.length;
    
    return numberOfDaysInMonth;
}

-(void)moreDateInfo:(int)showMonth xVal:(int)xVal yVal:(int)yVal{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setDay:1];
    [components setMonth:showMonth];
    [components setYear:_thisYear];
    NSDate * newDate = [calendar dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:newDate];
    weekday=[comps weekday];
    numDays=[self getCurrDateInfo:newDate];
    NSInteger newWeekDay=weekday-1;
    //    NSLog(@"Day week %d",newWeekDay);
    
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    nowComponents = [calendar components:units fromDate:now];
    
    int yCount=1;
    yearly.text=[NSString stringWithFormat:@"%lu",_thisYear];
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(xVal+CGRectGetWidth(self.view.bounds)/6 - 10, yVal-10, 20, 20)];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.tag=tag++;
    [monthLabel setText:[NSString stringWithFormat:@"%d",showMonth]];
    [monthLabel setFont:[UIFont fontWithName:@"Quicksand" size:CGRectGetWidth(self.view.bounds)/2.8/12]];
    [self.view addSubview:monthLabel];
    for(int startDay=1; startDay<=numDays;startDay++){
        UILabel *dayButton = [[UILabel alloc]init];
        dayButton.textAlignment = NSTextAlignmentCenter;
        
        int xCoord=(newWeekDay*CGRectGetWidth(self.view.bounds)/2.8/8)+xVal;
        int yCoord=(yCount*CGRectGetWidth(self.view.bounds)/2.8/8)+yVal;
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        
        dayButton.frame = CGRectMake(xCoord+(CGRectGetWidth(self.view.bounds)/2.8/8/5), yCoord, CGRectGetWidth(self.view.bounds)/2.8/8, CGRectGetWidth(self.view.bounds)/2.8/8);
        float dayBtnBoundsSize = CGRectGetWidth(self.view.bounds)/2.8/8;
        [dayButton setText:[NSString stringWithFormat:@"%d",startDay]];
        [dayButton setFont:[UIFont fontWithName:@"Quicksand-Regular" size:CGRectGetWidth(self.view.bounds)/2.8/13]];
        [dayButton setTextColor:[UIColor blackColor]];
        dayButton.tag=tag++;
        
        
        
        if( ([nowComponents year] == _thisYear) && ([nowComponents month] == showMonth) && ([nowComponents day] == startDay)){
            NSLog(@"yes");
            dayButton.layer.frame = CGRectMake(xCoord+(CGRectGetWidth(self.view.bounds)/2.8/8/5), yCoord, CGRectGetWidth(self.view.bounds)/2.8/8, CGRectGetWidth(self.view.bounds)/2.8/8);
            dayButton.layer.bounds = CGRectMake(xCoord+(CGRectGetWidth(self.view.bounds)/2.8/8/5), yCoord, dayBtnBoundsSize + 3.8, dayBtnBoundsSize + 3.8 );
            dayButton.layer.borderColor =[UIColor redColor].CGColor;
            dayButton.layer.borderWidth = 2;
            dayButton.layer.cornerRadius = dayButton.frame.size.width / 6;
            dayButton.layer.masksToBounds = YES;
        }
        
        [self.view addSubview:dayButton];
        int checkFalg =0;
        for(int parseNum=0; parseNum<createdAt.count; parseNum++){
            Moodmon *parseDate = [createdAt  objectAtIndex:parseNum];
            int parseMonth = (int)parseDate.moodMonth;
            int parseYear = (int)parseDate.moodYear;
            int parseDay = (int)parseDate.moodDay;
            
            
            if((parseYear==_thisYear)&&(parseMonth==showMonth)&&(parseDay==startDay)&&(checkFalg==0)){
                [dayButton setTextColor:[UIColor clearColor]];
                checkFalg=1;
                //                    [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen1"]];
                //                    if([createdAt[parseNum] valueForKey:@"_moodChosen2"]!=0){
                //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen2"]];
                //                    }
                //                    if([createdAt[parseNum] valueForKey:@"_moodChosen3"]!=0){
                //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen3"]];
                //                }
                MDMoodColorView *mcv = [[MDMoodColorView alloc]initWithFrame:CGRectMake(xCoord, yCoord, CGRectGetWidth(self.view.bounds)/2.8/8, CGRectGetWidth(self.view.bounds)/2.8/8)];
                
                [mcv awakeFromNib];
                MDMoodFaceView *mfv = [[MDMoodFaceView alloc]initWithFrame:CGRectMake(xCoord, yCoord, xVal, yVal)];
                
                [mfv awakeFromNib];
                //                mcv.backgroundColor = [UIColor clearColor];
                NSArray *dayRepresenatationColors = [mddm representationOfRealmMoodMonAtYear:(NSInteger)parseYear Month:(NSInteger)parseMonth andDay:parseDay];
                NSNumber *tempMoodChosen = dayRepresenatationColors[0];
                
                if(tempMoodChosen.intValue > 0)
                    //                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                tempMoodChosen = dayRepresenatationColors[1];
                if(tempMoodChosen.intValue > 0)
                    //                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                tempMoodChosen = dayRepresenatationColors[2];
                if(tempMoodChosen.intValue > 0)
                    //                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                
                
                //                    mmm = [[MDMakeMoodMonView alloc]init];
                //                    mcv = [self.view viewWithTag:7];
                //                    [dayButton setImage:[mmm makeMoodMon:createdAt[parseNum] view:mcv] forState:UIControlStateNormal];
                mcv.tag=tag++;
                //                mfv.tag=tag++;
                mcv.layer.cornerRadius = mcv.frame.size.width/6;
                mcv.center = dayButton.center;
                //                mcv.layer.cornerRadius = mcv.frame.size.width/2;
                [mcv setNeedsDisplay];
                //                [mfv setNeedsDisplay];
                [self.view addSubview:mcv];
                
                //                [self.view addSubview:mfv];
            }
        }
        
        
        
    }
}
@end
