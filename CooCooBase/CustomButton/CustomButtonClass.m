//
//  CustomButtonClass.m
//  Pods
//
//  Created by ibasemac3 on 3/17/17.
//
//

#import "CustomButtonClass.h"

@implementation CustomButtonClass

-(void)setTitleColor:(UIColor *)color andFontsize:(int)fontSize andTitle:(int)title
{
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font=[UIFont fontWithName:kFontAwesomeFamilyName size:fontSize];
    
    [self setTitle:[NSString fontAwesomeIconStringForEnum:title] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
