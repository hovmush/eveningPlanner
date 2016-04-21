//
//  MEPInfoViewController.h
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEPDataManager.h"

@interface MEPInfoViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectID *placeObjectID;
@property (nonatomic, strong) NSMutableArray *selectedPlacesIDs;

@property (nonatomic) NSInteger currentMoney;

@end
