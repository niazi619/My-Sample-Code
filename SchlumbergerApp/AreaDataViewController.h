//
//  AreaDataViewController.h
//  SchlumbergerApp
//
//  Created by DeviceBee on 10/2/14.
//  Copyright (c) 2014 devicebee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "EColumnChart.h"
@interface AreaDataViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,XYPieChartDelegate, XYPieChartDataSource,EColumnChartDelegate, EColumnChartDataSource>{
    
}
@property (weak, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;

@property(nonatomic,retain) NSDictionary *dictRoot;
@property(nonatomic,retain) NSDictionary *areaData;
@property(nonatomic,retain) NSArray *geoName;
@property(nonatomic,retain) NSArray *values;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UILabel *BarChartValueLabel;

@property (strong, nonatomic) IBOutlet UIButton *barChartRightBtn;
@property (strong, nonatomic) IBOutlet UIButton *barChartLeftBtn;


@end
