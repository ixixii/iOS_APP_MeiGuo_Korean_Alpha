//
//  OnePixelConstraint.m
//  thaialpha
//
//  Created by beyond on 2020/03/01.
//  Copyright © 2020 Christine. All rights reserved.
//

#import "OnePixelConstraint.h"

@implementation OnePixelConstraint
- (void)awakeFromNib{
    [super awakeFromNib];
     if (self.constant ==1) {
         self.constant=1/[UIScreen mainScreen].scale;
     }

}
@end
