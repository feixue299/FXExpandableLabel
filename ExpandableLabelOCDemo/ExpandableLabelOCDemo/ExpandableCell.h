//
//  ExpandableCell.h
//  ExpandableLabelOCDemo
//
//  Created by 8-PC on 2020/6/11.
//  Copyright © 2020 wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExpandableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet  ExpandableLabel*label;

@end

NS_ASSUME_NONNULL_END
