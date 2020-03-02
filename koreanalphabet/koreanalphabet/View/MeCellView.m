//
//  MeCellView.m
//  thaialpha
//
//  Created by beyond on 2020/03/01.
//  Copyright © 2020 Christine. All rights reserved.
//

#import "MeCellView.h"

@implementation MeCellView
+ (MeCellView *)meCellView
{
    NSArray *tmpArr = [[NSBundle mainBundle]loadNibNamed:@"MeCellView" owner:nil options:nil];
    return tmpArr[0];
}

@end
