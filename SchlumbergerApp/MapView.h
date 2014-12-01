//
//  MapView.h
//  SchlumbergerApp
//
//  Created by DeviceBee on 10/2/14.
//  Copyright (c) 2014 devicebee. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *gl_AreaName;

@interface MapView : UIViewController<UIPopoverControllerDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIView *bgMapActiveView;
@property (retain, nonatomic) UIPopoverController *AreadataPopoverController;
- (IBAction)MapPointerPressed:(id)sender;

@end
