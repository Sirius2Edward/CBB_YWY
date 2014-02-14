//
//  UILabel+Add.m
//  CBB
//
//  Created by 卡宝宝 on 13-10-12.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "UILabel+Add.h"

@implementation UILabel (Add)
-(UILabel *)addUnit:(NSString *)aUnit Font:(UIFont *)aFont Color:(UIColor *)aColor xOffset:(CGFloat)x yOffset:(CGFloat)y
{
    [self sizeToFit];
    CGRect rect = self.frame;
    rect.origin.x += rect.size.width+x;
    rect.origin.y += y;
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.font = aFont;
    unitLabel.textColor = aColor;
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.text = aUnit;
    unitLabel.frame = rect;
    [unitLabel sizeToFit];
    [[self superview] addSubview:unitLabel];
    return unitLabel;
}
@end
