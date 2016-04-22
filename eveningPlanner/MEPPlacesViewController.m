//
//  SecondViewController.m
//  Group app1
//
//  Created by Musho on 06/04/16.
//  Copyright © 2016 Paruyr Danielian. All rights reserved.
//

#import "UIColor+MEPEveningPlannerColor.h"
#import "MEPPlacesViewController.h"
#import <MapKit/MapKit.h>
#import "MEPDataManager.h"
#import "MEPTableViewCell.h"
#import "MEPChoiceViewController.h"
#import "MEPInfoViewController.h"

@interface MEPPlacesViewController () <UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tableViewLabel;

@property (nonatomic) BOOL isTheFirstBottomButtonTouched;
@property (nonatomic) NSInteger numberOfSelectedTopButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomLayout;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sortingButtons;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *sortByViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationPlusTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationPlusWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *animationPlus;

@property (strong, nonatomic) id sortingType;
@property (nonatomic) SEL sortingMethod;
@property (nonatomic) NSInteger currentMoney;
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSDictionary *distances;

@end



@implementation MEPPlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCurrentCoordinates];
    [self customizeViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self basketButtonCustomizing];
    NSManagedObjectContext *context = [[MEPDataManager defaultManager] managedObjectContext];
    self.currentMoney = self.money;
    if (self.placesObjectIDs.count != 0) {
        for (NSManagedObjectID *temp in self.placesObjectIDs) {
            MEPPlaces *place = [context objectWithID:temp];
            self.currentMoney -= [place.price integerValue];
        }
    }
    [self setingMoneyField:self.currentMoney];
}

- (void)basketButtonCustomizing {
    UIImage* __block image = nil;
    
    [UIView animateWithDuration:0.4 animations:^{
        if (self.placesObjectIDs.count == 0) {
            image = [UIImage imageNamed:@"basket"];
        } else {
            image = [UIImage imageNamed:@"basketadd"];
        }
    }];
    CGRect frameimg = CGRectMake(0, 0, 30, 30);
    UIButton *myChoicesButton = [[UIButton alloc] initWithFrame:frameimg];
    [myChoicesButton addTarget:self action:@selector(basketButtonTouched)
              forControlEvents:UIControlEventTouchUpInside];
    [myChoicesButton setShowsTouchWhenHighlighted:NO];
    [myChoicesButton setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *button =[[UIBarButtonItem alloc] initWithCustomView:myChoicesButton];
    self.navigationItem.rightBarButtonItem = button;
    
}

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

- (void)customizeViewController {
    self.currentMoney = self.money;
    self.sortingMethod = @selector(sortByDistance);
    self.placesObjectIDs = [[NSMutableArray alloc] init];
    [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeGym and:kPlaceTypeGame]];
    [self.topButtons[1] setBackgroundColor:[UIColor eveningPlannerGreenColor]];
    [self.topButtons[1] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.numberOfSelectedTopButton = 2;
    [self.bottomButtons[0] setTitle:@"Game" forState:UIControlStateNormal];
    [self.bottomButtons[1] setTitle:@"Gym" forState:UIControlStateNormal];

    [self setingMoneyField:self.currentMoney];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [self basketButtonCustomizing];
}

- (void)setingMoneyField:(NSInteger)money {
    UILabel *barTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 48)];
    barTitle.textColor = [UIColor whiteColor];
    barTitle.text = [NSString stringWithFormat:@"%ld AMD", (long)money];
    [barTitle setFont:[UIFont systemFontOfSize:30]];
    [self.navigationItem setTitleView:barTitle];
}

- (void)makeDistanceLimit:(NSArray *)array {
    NSMutableDictionary *tempDistances = [[NSMutableDictionary alloc] init];
    NSMutableArray *tempPlaces = [[NSMutableArray alloc] init];
    
    if (self.locationManager.location.coordinate.latitude != 0) {
        CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude,
                                                                           self.locationManager.location.coordinate.longitude);
        for (int i = 0; i < array.count; i++) {
            CLLocationCoordinate2D placeCoordinate = CLLocationCoordinate2DMake([[array[i] latitude] doubleValue],
                                                                                [[array[i] longitude] doubleValue]);
            MKMapPoint pointOne = MKMapPointForCoordinate(placeCoordinate);
            MKMapPoint pointTwo = MKMapPointForCoordinate(userCoordinate);
            CLLocationDistance distance = MKMetersBetweenMapPoints(pointOne, pointTwo);
            if (self.distanceLimit > distance/1000 && self.money >= [[array[i] price] integerValue] ) {
                [tempPlaces addObject:array[i]];
                [tempDistances setObject:[NSNumber numberWithFloat:distance] forKey:[array[i] name]];
            }
        }
        
    } else {
        for (int i = 0; i < self.places.count; i++) {
            if (self.money > [[array[i] price] integerValue]) {
                [tempPlaces addObject:array[i]];
                [tempDistances setObject:[NSNumber numberWithFloat:0] forKey:[self.places[i] name]];
            }
        }
    }
    self.distances = [tempDistances copy];
    self.places = [tempPlaces copy];
    [self performSelector:self.sortingMethod];
}

- (void)addOrRemoveButtonTouched:(UIButton *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(MEPTableViewCell *)[[sender superview] superview]];
    NSManagedObjectID *placeID = [self.places[indexPath.row] objectID];
    if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"minus"]]) {
        [self.animationPlus setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        [self addOrRemoveButtonAnimation];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [self.placesObjectIDs removeObject:placeID];
        self.currentMoney += [[self.places[indexPath.row] price] integerValue];
    } else {
        NSInteger money = self.currentMoney - [[self.places[indexPath.row] price] integerValue];
        if (money < 0) {
            UIAlertController *moneyAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                                message:@"Entered amount is not enough. Please update inserted sum."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:nil];
            [moneyAlert addAction:okAction];
            [self presentViewController:moneyAlert animated:YES completion:nil];
        } else {
            self.currentMoney = money;
            [self.animationPlus setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
            [self addOrRemoveButtonAnimation];
            [sender setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            [self.placesObjectIDs addObject:placeID];
        }
        
    }
    [self setingMoneyField:self.currentMoney];
    [self basketButtonCustomizing];
}

- (void)addOrRemoveButtonAnimation {
    if ([self.animationPlus.currentBackgroundImage isEqual:[UIImage imageNamed:@"plus"]]) {
        self.animationPlusTopConstraint.constant = -45;
        self.animationPlusWidthConstraint.constant = 45;
        [self.animationPlus layoutIfNeeded];
        self.animationPlusTopConstraint.constant = -190;
        self.animationPlusWidthConstraint.constant = 10;
    }
    self.animationPlus.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        [self.animationPlus layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.animationPlus.hidden = YES;
    });
}

- (void)basketButtonTouched {
    MEPChoiceViewController *myChoiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myChoiceVC"];
    myChoiceVC.selectedPlacesIDs = self.placesObjectIDs;
    myChoiceVC.currentMoney = self.currentMoney;
    [self showViewController:myChoiceVC sender:self];
}

#pragma mark - GreenButtons methods

- (IBAction)topButtonTouched:(UIButton *)sender {
    [self changeColorsOfBottomButtonsWithIndex:0];
    [self changeColorsOfBottomButtonsWithIndex:1];
    if ([sender.backgroundColor isEqual:self.view.backgroundColor]) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.backgroundColor = [UIColor eveningPlannerGreenColor];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }];
    }
    if ([sender isEqual:self.topButtons[0]]) {
        [self changeColorsOfTopButtonsWithIndex:1 and:2];
        [self setTitlesForBottomButons:@"Fast Food" and:@"Restaurant"];
        [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeFastFood and:kPlaceTypeRestaurant]];
        self.numberOfSelectedTopButton = 1;
        
    }
    if ([sender isEqual:self.topButtons[1]]) {
        [self changeColorsOfTopButtonsWithIndex:0 and:2];
        [self setTitlesForBottomButons:@"Game" and:@"Gym"];
        [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeGym and:kPlaceTypeGame]];
        self.numberOfSelectedTopButton = 2;
        
    }
    if ([sender isEqual:self.topButtons[2]]) {
        [self changeColorsOfTopButtonsWithIndex:0 and:1];
        [self setTitlesForBottomButons:@"Cinema, Theater" and:@"Museum"];
        [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeCinema and:kPlaceTypeMuseum]];
        self.numberOfSelectedTopButton = 3;
    }
    
    [self.tableView reloadData];
}

- (void)setTitlesForBottomButons:(NSString *)titleOne and:(NSString *)titleTwo {
    [self.bottomButtons[0] setTitle:titleOne forState:UIControlStateNormal];
    [self.bottomButtons[1] setTitle:titleTwo forState:UIControlStateNormal];
}

- (void)changeColorsOfTopButtonsWithIndex:(NSInteger)indexOne and:(NSInteger)indexTwo {
    [UIView animateWithDuration:0.2 animations:^{
        [self.topButtons[indexOne] setBackgroundColor:self.view.backgroundColor];
        [self.topButtons[indexOne] setTitleColor:[UIColor eveningPlannerGreenColor] forState:UIControlStateNormal];
        [self.topButtons[indexTwo] setBackgroundColor:self.view.backgroundColor];
        [self.topButtons[indexTwo] setTitleColor:[UIColor eveningPlannerGreenColor] forState:UIControlStateNormal];
    }];
}
- (void)changeColorsOfBottomButtonsWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        [self.bottomButtons[index] setBackgroundColor:self.view.backgroundColor];
        [self.bottomButtons[index] setTitleColor:[UIColor eveningPlannerGreenColor] forState:UIControlStateNormal];
    }];
}


- (IBAction)bottomButtonTouched:(UIButton *)sender {
    if ([sender.backgroundColor isEqual:self.view.backgroundColor]) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.backgroundColor = [UIColor eveningPlannerGreenColor];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }];
    }
    [self.tableView reloadData];
    if ([sender isEqual:self.bottomButtons[0]]) {
        [UIView animateWithDuration:0.2 animations:^{
            [self changeColorsOfBottomButtonsWithIndex:1];
            self.isTheFirstBottomButtonTouched = YES;
        }];
    }
    if ([sender isEqual:self.bottomButtons[1]]) {
        [UIView animateWithDuration:0.2 animations:^{
            [self changeColorsOfBottomButtonsWithIndex:0];
            self.isTheFirstBottomButtonTouched = NO;
        }];
    }
    
    [self choosingPlaceType];
}

- (void)choosingPlaceType {
    if (self.isTheFirstBottomButtonTouched) {
        switch (self.numberOfSelectedTopButton) {
            case 1:
                [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeFastFood]];
                break;
            case 2:
                [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeGame]];
                break;
            case 3:
                [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeCinema]];
                break;
                
            default:
                break;
        }
    } else {
        switch (self.numberOfSelectedTopButton) {
            case 1:
                [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeRestaurant]];
                break;
            case 2:
                [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeGym]];
                break;
            case 3:
                [self makeDistanceLimit:[[MEPDataManager defaultManager] fetchPlaceWith:kPlaceTypeMuseum]];
                break;
                
            default:
                break;
        }
    }
    [self.tableView reloadData];
}
#pragma mark - TableView Delegate and DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MEPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    MEPPlaces *place = self.places[indexPath.row];
    [cell.logo setImage:[UIImage imageNamed:place.logo]];
    [cell.name setText:place.name];
    [cell.price setText:[NSString stringWithFormat:@"%@",place.price]];
    if (self.locationManager.location.coordinate.latitude != 0) {
        [cell.distanceLabel setText:[NSString stringWithFormat:@"%.01f kilometer from current position.",
                                     [self.distances[place.name] floatValue]/1000]];
    } else {
        [cell.distanceLabel setText:@"Turn On Location Services"];
    }
    [cell.addOrRemoveButton setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    for (NSManagedObjectID *temp in self.placesObjectIDs) {
        if ([temp isEqual:place.objectID]) {
            [cell.addOrRemoveButton setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        }
    }
    [[cell addOrRemoveButton] addTarget:nil
                                 action:@selector(addOrRemoveButtonTouched:)
                       forControlEvents:UIControlEventTouchUpInside];
    [cell showRating:place.rating];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.sortingButtons[0] alpha] == 0) {
        MEPInfoViewController *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"infoVC"];
        infoVC.placeObjectID = [self.places[indexPath.row] objectID];
        infoVC.selectedPlacesIDs = self.placesObjectIDs;
        infoVC.currentMoney = self.currentMoney;
        [self showViewController:infoVC sender:self];
    } else {
        [self setSortingViewsAlpha:0];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Methods for sorting

- (IBAction)sortReverseButtonTouched:(id)sender {
    self.places = [[self.places reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}

- (IBAction)sortByButtonTouched:(id)sender {
    if ([self.sortingButtons[0] alpha] == 0) {
        [self setSortingViewsAlpha:1];
    } else {
        [self setSortingViewsAlpha:0];
    }
}
- (IBAction)sortByRatingButtonTouched:(id)sender {
    [self sortByRating];
    [self setSortingViewsAlpha:0];}
- (IBAction)sortByPriceButtonTouched:(id)sender {
    [self sortByPrice];
    [self setSortingViewsAlpha:0];
}
- (IBAction)sortByDistanceButtonTouched:(id)sender {
    [self sortByDistance];
    [self setSortingViewsAlpha:0];
}
- (IBAction)sortByNameButtonTouched:(id)sender {
    [self sortByName];
    [self setSortingViewsAlpha:0];
}

- (void)setSortingViewsAlpha:(NSInteger)alpha {
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i < self.sortingButtons.count; i++) {
            [self.sortingButtons[i] setAlpha:alpha];
            [self.sortByViews[i] setAlpha:alpha];
        }
        if (alpha == 1) {
            self.tableView.alpha = 0.3;
        } else {
            self.tableView.alpha = 1;
        }
    }];

}



- (void)sortByRating {
    self.sortingMethod = @selector(sortByRating);
    self.places = [self.places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [[(MEPPlaces *)a rating] compare:[(MEPPlaces *)b rating]];
    }];
    [self.tableView reloadData];
    
}

- (void)sortByName {
    self.sortingMethod = @selector(sortByName);
    self.places = [self.places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [[(MEPPlaces *)a name] compare:[(MEPPlaces *)b name]];
    }];
    [self.tableView reloadData];
    
}

- (void)sortByPrice {
    self.sortingMethod = @selector(sortByPrice);
    self.places = [self.places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [[(MEPPlaces *)a price] compare:[(MEPPlaces *)b price]];
    }];
    [self.tableView reloadData];
    
}

- (void)sortByDistance {
    NSArray *names;
    self.sortingMethod = @selector(sortByDistance);
    names = [self.distances keysSortedByValueUsingComparator:^NSComparisonResult(id a, id b) {
        return [a compare:b];
    }];
    NSMutableArray *sortedPlaces = [[NSMutableArray alloc] init];
    for (NSString *name in names) {
        for (MEPPlaces *place in self.places) {
            if ([place.name isEqualToString:name]) {
                [sortedPlaces addObject:place];
                break;
            }
        }
    }
    self.places = [sortedPlaces copy];
    [self.tableView reloadData];
    
}

@end
