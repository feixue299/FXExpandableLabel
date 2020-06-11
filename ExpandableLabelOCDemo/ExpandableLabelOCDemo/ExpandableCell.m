//
//  ExpandableCell.m
//  ExpandableLabelOCDemo
//
//  Created by 8-PC on 2020/6/11.
//  Copyright © 2020 wu. All rights reserved.
//

#import "ExpandableCell.h"

@implementation ExpandableCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.collapsed = YES;
    self.label.text = nil;
}

@end
