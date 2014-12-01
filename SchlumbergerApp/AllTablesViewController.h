//
//  AllTablesViewController.h
//  SchlumbergerApp
//
//  Created by DeviceBee on 11/26/14.
//  Copyright (c) 2014 devicebee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface AllTablesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITableView *GMTableView;
@property (strong, nonatomic) IBOutlet UITableView *functionTableView;

@property(nonatomic,retain)NSMutableDictionary *AllTableDictionary;
@property(nonatomic,retain)NSMutableArray *geoMarketsJson;
@property(nonatomic,retain)NSMutableArray *geoMarketsTable;
@property(nonatomic,retain)NSMutableArray *functionsJson;
@property(nonatomic,retain)NSMutableArray *functionsTable;
@end
