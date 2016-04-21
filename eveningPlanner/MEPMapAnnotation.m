//
//  MEPMapAnnotation.m
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MEPMapAnnotation.h"

@implementation MEPMapAnnotation

-(instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinate title:(NSString *)title subTitle:(NSString *)subTitle {
    self = [super init];
    
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _subTitle = subTitle;
    }
    return self;
}

@end
