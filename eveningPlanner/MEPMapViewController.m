//
//  MEPMapViewController.m
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MEPMapViewController.h"
#import <MapKit/MapKit.h>
#import "MEPMapAnnotation.h"

@interface MEPMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPolylineRenderer *polylineRenderer;
@property (strong, nonatomic) MKPolyline *polyline;

@property (nonatomic) BOOL isCurrentLocation;

@end

@implementation MEPMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MKMapView alloc];
    
    for (int i = 0; i < self.latitudes.count; i++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.latitudes[i] doubleValue],
                                                                       [self.longitudes[i] doubleValue]);
        MEPMapAnnotation *annotation = [[MEPMapAnnotation alloc] initWithCoordinates:coordinate title:@"KFC" subTitle:@"Fast Food"];
        [self.mapView addAnnotation:annotation];
    } if (self.latitudes.count == 1) {
        self.mapView.showsUserLocation = YES;
        [self getCurrentCoordinates];
        CLLocationCoordinate2D coordinate[2];
        coordinate[1] = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude,
                                                   self.locationManager.location.coordinate.longitude);
        coordinate[0] = CLLocationCoordinate2DMake([self.latitudes[0] doubleValue], [self.longitudes[0] doubleValue]);
        [self drawPathFrom:coordinate[1] to:coordinate[0]];
    }
    self.mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.177610, 44.512412), 10000,10000);
}

- (void)drawPathFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint {
    NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&mode=driving",startPoint.latitude, startPoint.longitude, endPoint.latitude, endPoint.longitude]];
    NSURLResponse *res;
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:url] returningResponse:&res error:&err];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *routes=dic[@"routes"];
    NSArray *legs=routes[0][@"legs"];
    NSArray *steps=legs[0][@"steps"];
    NSMutableArray *latlong=[[NSMutableArray alloc]init];
    if ([steps count] > 0) {
        [latlong addObject:steps[0][@"start_location"]];
    }
    for(int i=0; i< [steps count]; i++){
        [latlong addObject:steps[i][@"end_location"]];
    }
    [self showDirection:latlong];
}

-(void)showDirection:(NSMutableArray*) latlong{
    CLLocationCoordinate2D coordinates[latlong.count];
    for(int i=0; i<[latlong count]; i++) {
        coordinates[i].latitude  = [latlong[i][@"lat"] doubleValue];
        coordinates[i].longitude = [latlong[i][@"lng"] doubleValue];
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:latlong.count];
    [self.mapView addOverlay:polyline];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer =[[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor orangeColor];
    renderer.lineWidth = 3.0;
    
    return renderer;}

- (void)getCurrentCoordinates {
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    [self.locationManager stopUpdatingLocation];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"current"];
    if (pinView == nil) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    }
    UIImage *pinImage = nil;
    if (self.latitudes.count == 1 && self.isCurrentLocation) {
        pinImage = [UIImage imageNamed:@"app-icon"];
        self.isCurrentLocation = NO;
    } else {
        pinImage = [UIImage imageNamed:@"pin"];
    }
    
    pinView.image = pinImage;
    pinView.canShowCallout = YES;
    self.isCurrentLocation = YES;

    return pinView;
}

@end