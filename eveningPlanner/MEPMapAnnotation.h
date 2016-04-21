//
//  MEPMapAnnotation.h
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MEPMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subTitle;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinate
                              title:(NSString *)title subTitle:(NSString *)subTitle;

@end
