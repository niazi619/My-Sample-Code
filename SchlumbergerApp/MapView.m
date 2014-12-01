//
//  MapView.m
//  SchlumbergerApp
//
//  Created by DeviceBee on 10/2/14.
//  Copyright (c) 2014 devicebee. All rights reserved.
//

#import "MapView.h"
#import "AreaDataViewController.h"
#import "AllTablesViewController.h"
@interface MapView ()

@end

@implementation MapView
@synthesize AreadataPopoverController;
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
    // Do any additional setup after loading the view.];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.bgMapActiveView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)MapPointerPressed:(id)sender {
    //Get map button tag number
    UIButton *mapPointerTag = (UIButton *)sender;
    //set frame according to background view buttons
    UIImageView *activeMapPointerView = [[UIImageView alloc]initWithFrame:CGRectMake(mapPointerTag.frame.origin.x, mapPointerTag.frame.origin.y-219, mapPointerTag.frame.size.width, mapPointerTag.frame.size.height)];
    //pass it to uiimageview
    UIImage *activeMapPointerImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_pointer_active.png",mapPointerTag.titleLabel.text]];
    activeMapPointerView.image = activeMapPointerImage;
    [self.bgMapActiveView addSubview:activeMapPointerView];
    self.bgMapActiveView.hidden = NO;

    
    gl_AreaName = [mapPointerTag.titleLabel.text uppercaseString];
    //Add popOver View
    AllTablesViewController *tableDataView= [[AllTablesViewController alloc] initWithNibName: @"AllTablesViewController" bundle:[NSBundle mainBundle]];
    
    UIPopoverController* aPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:tableDataView];
    aPopover.delegate = self;
    
    // Store the popover in a custom property for later use.
    self.AreadataPopoverController = aPopover;

    aPopover.popoverContentSize = CGSizeMake(900, 650);
    [aPopover presentPopoverFromRect:CGRectMake(290, 130.0, 450, 520) inView:self.view permittedArrowDirections:NULL animated:YES];

    
    

    

}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController;
{
    for(UIImageView *view in self.bgMapActiveView.subviews)
    {
        [view removeFromSuperview];
    }
    self.bgMapActiveView.hidden = YES;
    return YES;
}
- (IBAction)backToDashBoard:(id)sender {
[self.navigationController popViewControllerAnimated:YES];
}
@end
