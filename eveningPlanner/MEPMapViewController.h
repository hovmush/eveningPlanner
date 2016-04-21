//
//  MEPMapViewController.h
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEPMapViewController : UIViewController

@property (nonatomic, strong) NSArray *latitudes;
@property (nonatomic, strong) NSArray *longitudes;

@property (nonatomic, strong) NSArray *places;

@end
