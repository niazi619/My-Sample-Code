//
//  AreaDataViewController.m
//  SchlumbergerApp
//
//  Created by DeviceBee on 10/2/14.
//  Copyright (c) 2014 devicebee. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "AreaDataViewController.h"
#import "AreaInfoCell.h"

#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
@interface AreaDataViewController ()
//for bar Chart
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end
NSString *gl_AreaName;
@implementation AreaDataViewController
//for bar Chart
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize BarChartValueLabel = _BarChartValueLabel;

@synthesize areaData,dictRoot,geoName,values,tableView,barChartLeftBtn,barChartRightBtn;
@synthesize pieChart = _pieChart;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _BarChartValueLabel.hidden = YES;
    if (!dictRoot) {
        
        dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PropertyList" ofType:@"plist"]];
    }
    areaData = (NSDictionary*)[dictRoot objectForKey:gl_AreaName];
    geoName = [areaData allKeys];
    values = [areaData allValues];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///Bar Chart
    
    
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < values.count; i++)
    {
        NSString *plistString = [NSString stringWithString:[values objectAtIndex:i]];
        NSString *stringWithoutcomma = [plistString
                                        stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSNumber *one = [NSNumber numberWithInt:[stringWithoutcomma intValue]];
        NSInteger value = [one integerValue];
        
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%@",[geoName objectAtIndex:i]] value:value index:i unit:@""];
        [temp addObject:eColumnDataModel];

        eColumnDataModel = nil;
    }
    _data = [NSArray arrayWithArray:temp];
    
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(410, 344, 300, 250)];
    [_eColumnChart setNormalColumnColor:[UIColor blueColor]];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
	[_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    
    
    [self.view addSubview:_eColumnChart];
    //barChartRightBtn.showsTouchWhenHighlighted = TRUE;
    ///Bar Chart end
    self.slices = [NSMutableArray arrayWithCapacity:17];
    
    for(int i = 0; i < values.count; i ++)
    {
        NSString *plistString = [NSString stringWithString:[values objectAtIndex:i]];
        NSString *stringWithoutcomma = [plistString
                                         stringByReplacingOccurrencesOfString:@"," withString:@""];
      //  NSLog(@"%i",[stringWithoutcomma intValue]);
        
        NSNumber *one = [NSNumber numberWithInt:[stringWithoutcomma intValue]];
        [_slices addObject:one];
    }
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setPieCenter:CGPointMake(240, 240)];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    [self.pieChart setShowPercentage:YES];
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],
                       [UIColor colorWithRed:173/255.0 green:152/255.0 blue:198/255.0 alpha:1],
                       [UIColor colorWithRed:184/255.0 green:213/255.0 blue:140/255.0 alpha:1],
                       [UIColor colorWithRed:255/255.0 green:255/255.0 blue:181/255.0 alpha:1],nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [geoName count];
    
}

- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"AreaInfoCell";
    
    AreaInfoCell *cell = (AreaInfoCell *)[ltableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AreaInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (!([indexPath row]%2==0)) {
        
        cell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    }
//    cell.areaName.text = gl_AreaName;
//    cell.geoName.text = [geoName objectAtIndex:indexPath.row];
//    cell.geoValue.text = [values objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        //tableViewHeaderFooterView.textLabel.textColor = [UIColor whiteColor];
        tableViewHeaderFooterView.textLabel.font = [UIFont boldSystemFontOfSize:14];
        tableViewHeaderFooterView.tintColor = [UIColor colorWithRed:228.0/255.0 green:248.0/255.0 blue:251.0/255.0 alpha:1.0];
    }
    //End
}
//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
//        [headerView setBackgroundColor:[UIColor greenColor]];
//    return headerView;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionTitle = [NSString stringWithFormat:@"Area                           GM            2013 TotalField Cost (USD) (eBlueBook)"];
    return sectionTitle;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 28.0;
}



#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
   // NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
   // NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
   // NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
   // NSLog(@"did select slice at index %d",index);
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"%@:      %@",[self.geoName objectAtIndex:index],[self.values objectAtIndex:index]];
}


#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return 7;
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

//- (UIColor *)colorForEColumn:(EColumn *)eColumn
//{
//    if (eColumn.eColumnDataModel.index < 5)
//    {
//        return [UIColor purpleColor];
//    }
//    else
//    {
//        return [UIColor redColor];
//    }
//
//}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    //NSLog(@"Index: %d  Value: %f", eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    _BarChartValueLabel.text = [NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    /**The EFloatBox here, is just to show an example of
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
    //NSLog(@"Finger did enter %d", eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
       // [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"" title:[geoName objectAtIndex:eColumn.eColumnDataModel.index]];

        [eColumnChart addSubview:_eFloatBox];
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"" title:[geoName objectAtIndex:eColumn.eColumnDataModel.index]];
        _eFloatBox.alpha = 0.0;
        [eColumnChart addSubview:_eFloatBox];
        
    }
    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _eFloatBox.alpha = 1.0;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
    NSLog(@"Finger did leave %d", eColumn.eColumnDataModel.index);
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
        
    }
    
}
- (IBAction)BarChartMoveRight:(id)sender {
    if (self.eColumnChart == nil) return;
    [self.eColumnChart moveRight];
    
}
- (IBAction)BarChartMoveLeft:(id)sender {
    if (self.eColumnChart == nil) return;
    [self.eColumnChart moveLeft];
}

@end
