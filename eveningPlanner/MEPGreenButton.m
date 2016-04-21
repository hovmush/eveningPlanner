//
//  MEPGreenButton.m
//  eveningPlanner
//
//  Created by Musho on 21/04/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MEPGreenButton.h"
#import "UIColor+MEPEveningPlannerColor.h"

@implementation MEPGreenButton

- (void)awakeFromNib {
    [self setTitleColor:[UIColor eveningPlannerGreenColor] forState:UIControlStateNormal];
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = [[UIColor eveningPlannerGreenColor] CGColor];
    self.layer.cornerRadius = 2.5;
    
    
}

@end
