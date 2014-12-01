//
//  AllTablesViewController.m
//  SchlumbergerApp
//
//  Created by DeviceBee on 11/26/14.
//  Copyright (c) 2014 devicebee. All rights reserved.
//

#import "AllTablesViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AllTable.h"
#import "AreaInfoCell.h"
#import "GMHeaderTableViewCell.h"
#import "funcHeaderTableViewCell.h"
#import "functionTableViewCell.h"


#define MAIN_SERVER_URL @"http://testingwebservice.azurewebsites.net/TestService.svc/getGMTableData?area="
@interface AllTablesViewController ()

@end
NSString *gl_AreaName;
@implementation AllTablesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	[HUD show:YES];
    
    [self getAllTableData];
    self.GMTableView.layer.borderWidth = 2;
    self.GMTableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.functionTableView.layer.borderWidth = 2;
    self.functionTableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.GMTableView.hidden = YES;
    self.functionTableView.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.GMTableView) {
        return [self.geoMarketsTable count];
    }else
        return [self.functionsTable count];
    
}

- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (ltableView==self.GMTableView) {
        
        static NSString *simpleTableIdentifier = @"AreaInfoCell";
        AllTable *GmTable = [self.geoMarketsTable objectAtIndex:indexPath.row];
        AreaInfoCell *cell = (AreaInfoCell *)[ltableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AreaInfoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (!([indexPath row]%2==0)) {
            
            cell.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:238.0/255.0 blue:244.0/248.0 alpha:1.0];
        }else
            cell.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:220.0/255.0 blue:237.0/248.0 alpha:1.0];
        cell.gmLbl.text = GmTable.geoMarket;
        cell.countLbl.text = [NSString stringWithFormat:@"%d",GmTable.GMInitiatives];
        cell.expectedLbl.text = GmTable.GMaverageExpected;
        cell.capturedLbl.text = GmTable.GMaverageCaptured;
        cell.ocLbl.text = @"xxx";
        cell.ytdLbl.text = @"xxx";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        static NSString *simpleTableIdentifier = @"FunctionCell";
        AllTable *GmTable = [self.functionsTable objectAtIndex:indexPath.row];
        functionTableViewCell *cell = (functionTableViewCell *)[ltableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"functionTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (!([indexPath row]%2==0)) {
            cell.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:220.0/255.0 blue:237.0/248.0 alpha:1.0];
        }else
            
        cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:220.0/255.0 blue:205.0/248.0 alpha:1.0];
        cell.funtionLbl.text = GmTable.function;
        cell.countLbl.text = [NSString stringWithFormat:@"%d",GmTable.FuncInitiatives];
        cell.expectedLbl.text = GmTable.FuncAaverageExpected;
        cell.capturedLbl.text = GmTable.FuncAverageCaptured;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==self.GMTableView) {
         return 50.0f;
    }else
        return 70.0f;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 28.0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView==self.GMTableView) {
        static NSString *CellIdentifier = @"SectionHeaderGM";
        GMHeaderTableViewCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GMHeaderTableViewCell" owner:self options:nil];
        sectionHeaderView = [nib objectAtIndex:0];
        return sectionHeaderView.contentView;
    }else{
        static NSString *CellIdentifier = @"SectionHeaderFunction";
        funcHeaderTableViewCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"funcHeaderTableViewCell" owner:self options:nil];
        sectionHeaderView = [nib objectAtIndex:0];
        return sectionHeaderView.contentView;
    }
    
}

#pragma mark Call JSON 

-(void)getAllTableData{
    
    self.geoMarketsTable = [NSMutableArray array];
    self.functionsTable = [NSMutableArray array];
    
    NSString *string = [NSString stringWithFormat:@"%@%@", MAIN_SERVER_URL,gl_AreaName];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        self.AllTableDictionary = (NSMutableDictionary *)responseObject;
        
        self.geoMarketsJson = [self.AllTableDictionary objectForKey:@"geoMarketsJson"];
        
        self.functionsJson = [self.AllTableDictionary objectForKey:@"functionsJsonData"];
        
        //get geoMarkets Table
        for (NSDictionary *dict in self.geoMarketsJson) {
            
            AllTable *tableData = [[AllTable alloc]init];
            tableData.geoMarket = [dict objectForKey:@"GeoMarket"];
            tableData.GMaverageCaptured = [dict objectForKey:@"AverageCaptured"];
            tableData.GMaverageExpected = [dict objectForKey:@"AverageExpected"];
            tableData.GMInitiatives = [[dict objectForKey:@"Initiatives"] integerValue];
            [self.geoMarketsTable addObject:tableData];
        }
        
        //get function Table
        for (NSDictionary *dict in self.functionsJson) {
            
            AllTable *tableData = [[AllTable alloc]init];
            tableData.function = [dict objectForKey:@"Function"];
            tableData.FuncAverageCaptured = [dict objectForKey:@"AverageCaptured"];
            tableData.FuncAaverageExpected = [dict objectForKey:@"AverageExpected"];
            tableData.FuncInitiatives = [[dict objectForKey:@"Initiatives"] integerValue];
            [self.functionsTable addObject:tableData];
        }
        
       // NSLog(@"%@",self.functionsTable);
        [HUD hide:YES];
        if (self.geoMarketsTable.count>0) {
            self.GMTableView.hidden = NO;
            self.functionTableView.hidden = NO;
            [self.GMTableView reloadData];
            [self.functionTableView reloadData];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        [HUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];

}
@end
