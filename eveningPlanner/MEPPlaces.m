//
//  MEPPlaces.m
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MEPPlaces.h"

@implementation MEPPlaces

@dynamic name, descriptionInfo, logo, price, rating, imageFirst, imageSecond, imageThird, urlString, contactNumber, address, placeType, latitude, longitude;

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
       latitude:(NSNumber *)latitude {
    
    self.name = name;
    self.descriptionInfo = descriptionInfo;
    self.logo = logo;
    self.price = price;
    self.rating = rating;
    self.imageFirst = imageFirst;
    self.imageSecond = imageSecond;
    self.imageThird = imageThird;
    self.urlString = urlString;
    self.contactNumber = contactNumber;
    self.address = address;
    self.placeType = placeType;
    self.latitude = latitude;
    self.longitude = longitude;
}

@end
