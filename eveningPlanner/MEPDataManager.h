//
//  MEPDataManager.h
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEPPlaces.h"

static NSString *const kPlaceTypeFastFood = @"Fast Food";
static NSString *const kPlaceTypeRestaurant = @"Restaurant";
static NSString *const kPlaceTypeGame = @"Games";
static NSString *const kPlaceTypeGym = @"Gym";
static NSString *const kPlaceTypeMuseum = @"Museum";
static NSString *const kPlaceTypeCinema = @"TheatreCinema";

@interface MEPDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
+ (id)defaultManager;

- (void)saveContext;
- (void)insertPlacesList;

- (NSArray *)fetchPlaceWith:(NSString *)placeType;
- (NSArray *)fetchPlaceWith:(NSString *)placeTypeOne and:(NSString *)placeTypeTwo;

@end
