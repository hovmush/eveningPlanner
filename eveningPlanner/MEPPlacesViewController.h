//
//  MEPPlacesViewController.h
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEPDataManager.h"

@interface MEPPlacesViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <NSManagedObjectID *> *placesObjectIDs;

@property (nonatomic) NSInteger money;
@property (nonatomic) CGFloat distanceLimit;

@end
