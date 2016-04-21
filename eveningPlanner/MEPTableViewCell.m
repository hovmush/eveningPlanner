//
//  MEPTableViewCell.m
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MEPTableViewCell.h"

@implementation MEPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)showRating:(NSNumber *)activeStarsQty {
    for ( NSInteger i = 0; i < 5; ++i ) {
        if( i < [activeStarsQty integerValue] ) {
            [self.starIcons[i] setImage:[UIImage imageNamed:@"star_active"]];
        }
        else {
            [self.starIcons[i] setImage:[UIImage imageNamed:@"star_inactive"]];
        }
    }
}
@end
