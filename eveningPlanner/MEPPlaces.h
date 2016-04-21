//
//  MEPPlaces.h
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MEPPlaces : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *descriptionInfo;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *rating;
@property (nonatomic, retain) NSString *imageFirst;
@property (nonatomic, retain) NSString *imageSecond;
@property (nonatomic, retain) NSString *imageThird;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *contactNumber;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *placeType;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;


- (void)setName:(NSString *)name
descriptionInfo:(NSString *)descriptionInfo
           logo:(NSString *)logo
          price:(NSNumber *)price
         rating:(NSNumber *)rating
     imageFirst:(NSString *)imageFirst
    imageSecond:(NSString *)imageSecond
     imageThird:(NSString *)imageThird
      urlString:(NSString *)urlString
  contactNumber:(NSString *)contactNumber
        address:(NSString *)address
      placeType:(NSString *)placeType
      longitude:(NSNumber *)longitude
       latitude:(NSNumber *)latitude;

@end
