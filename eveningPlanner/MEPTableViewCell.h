//
//  MEPTableViewCell.h
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEPTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *addOrRemoveButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starIcons;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (void)showRating:(NSNumber *)activeStarsQty;

@end
