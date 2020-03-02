//
//  MeHeaderView.m
//  thaialpha
//
//  Created by beyond on 2020/02/29.
//  Copyright © 2020 Christine. All rights reserved.
//

#import "MeHeaderView.h"

@implementation MeHeaderView
+ (MeHeaderView *)meHeaderView
{
    NSArray *tmpArr = [[NSBundle mainBundle]loadNibNamed:@"MeHeaderView" owner:nil options:nil];
    return tmpArr[0];
}
@end
